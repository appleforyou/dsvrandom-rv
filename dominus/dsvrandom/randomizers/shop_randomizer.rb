require_relative '../rv/ooe_items.rb'

class ShopRandomizer

  attr_reader :rng

  def initialize(rng, game)
    @rng = rng
    @game = game

    number_of_shop_pools = 22
    @shop_item_pools = begin
      shop_item_pools = []
      number_of_shop_pools.times do |i|
        shop_item_pools << ShopItemPool.new(i, @game)
      end
      shop_item_pools
    end

    @cheap_healing_item = ["Meat", "Potion", "Rice Ball", "Corn Soup", "Mushroom", "Cream Puff", "Pudding", "Mocha Eclair"].sample(random: rng)
    randomize_item_prices()
    randomize_shop()
  end

  def randomize_shop()
    available_shop_items = OoEItems.shoppables.reject {|k, v| OoEItems.materials.has_key?(k) or @game.checker.super_drops.include?(v[:id])}
    shop_keys = available_shop_items.keys.shuffle(random: rng)

    hardcoded_pools = [
      [0x83,0xec,0x10c,0x7d,0xe7,0x12b,0x12c], #default pool
      [0x12d,0x12e,0x129],                     #unlocked with Maneater
      [0x12f,0x130,0x10e]                      #unlocked with Goliath
    ]

    hardcoded_pools.each_with_index do |pool, pool_index|
      pool.size.times do |i|
        if pool_index == 0 and i == 0
          #Make sure there is always a cheap healing item in the shop.
          pool[i] = OoEItems.consumables[@cheap_healing_item][:id] + 1
          shop_keys.delete(@cheap_healing_item)
        elsif pool_index == 0 and i == 3
          #Make sure Magical Tickets are always in the shop.
          pool[i] = 0x7c + 1
          shop_keys.delete("Magical Ticket")
        else
          item = shop_keys.pop()
          pool[i] = OoEItems.items[item][:id] + 1
        end
      end
    end

    @game.tweaks.change_hardcoded_shop_pools(hardcoded_pools)

    @shop_item_pools.each_with_index do |pool, pool_index|
      pool.item_ids.size.times do |i|
        item = shop_keys.pop()
        pool[i] = OoEItems.items[item][:id] + 1
      end
    end
  end

  def randomize_item_prices()
    #Setting prices for some items that didn't have one.
    #Since items like Queen of Hearts have prices, having one for these shouldn't be that crazy.
    OoEItems.items["Minerva Mail"][:price] = 12000
    OoEItems.items["Minerva Mask"][:price] = 8000
    OoEItems.items["Minerva Greaves"][:price] = 8000
    OoEItems.items["Robe Decollete"][:price] = 8000
    ["Red Drops", "Blue Drops", "Green Drops", "White Drops", "Black Drops"].each do |drop|
      OoEItems.items[drop][:price] = 4000
    end
    OoEItems.shoppables.each do |name, item|
      progress_item = @game.checker.all_progression_pickups.has_key?(name)
      if item[:tier].nil?
        item[:tier] = 0
      end
      tier_price = {
        0 => 500,
        1 => 1200,
        2 => 2500,
        3 => 6000,
        4 => 12000,
        5 => 20000
      }

      if name == @cheap_healing_item
        # Make the guaranteed cheap healing item reasonably priced (100-400).
        @game.tweaks.set_price(item, rng.rand(100..409)/10*10)
      elsif name == "Magical Ticket"
        @game.tweaks.set_price(item, rng.rand(50..159)/10*10)
      else
        if ["Health", "Hearts"].include?(item[:type])
          #Cheap health recovery items actually become a bit too expensive on average, and expensive ones too cheap when tier 0.
          original_price_weight = 2.0
        elsif item[:type] == "Ring"
          #The original game has extremely high prices for most rings. They are mostly static pickups and are meant to be sold high.
          original_price_weight = 0.5
        else
          original_price_weight = 1.0
        end
        if item[:type] == "Drops"
          #This price was set arbitrarily anyway so no point having to keep the tier 0.
          tier_weight = 0.0
        else
          tier_weight = 1.0
        end
        adjusted_price = (item[:price]*original_price_weight + tier_price[item[:tier]]*tier_weight)/(tier_weight+original_price_weight)
        adjusted_range = (adjusted_price*0.3..adjusted_price*1.7)

        final_price = rand_range_weighted(adjusted_range, average: adjusted_price).to_i/10*10
        item[:price] = final_price
        @game.tweaks.set_price(item, final_price)#named_rand_range_weighted(:item_price_range)/10*10)
      end
    end
  end

  def rand_range_weighted(range, average: (range.begin+range.end)/2)
    if average < range.begin || average > range.end
      raise "Bad random range! Average #{average} not within range #{range}."
    end

    if range.begin.is_a?(Float) || range.end.is_a?(Float)
      float_mode = true
    end

    theta = 2 * Math::PI * rng.rand()
    rho = Math.sqrt(-2 * Math.log(1 - rng.rand()))
    stddev = (range.end-range.begin).to_f/5
    scale = stddev * rho
    x = average + scale * Math.cos(theta)
    #y = average + scale * Math.sin(theta) # Don't care about the second value

    num = x
    num = x.round unless float_mode

    if num < range.begin
      # Retry until we get a value within the range.
      # Since this failed attempt at a number was too low, limit the next one to the lower half of the available range.
      new_range_end = (range.end-range.begin)/2 + range.begin
      new_range = (range.begin..new_range_end)
      if !new_range.include?(average)
        new_range = (range.begin..average)
        new_range = (new_range.begin.floor..new_range.end.ceil) unless float_mode
      end
      return rand_range_weighted(new_range, average: average)
    elsif num > range.end
      # Retry until we get a value within the range.
      # Since this failed attempt at a number was too high, limit the next one to the upper half of the available range.
      new_range_begin = (range.end-range.begin)/2 + range.begin
      new_range = (new_range_begin..range.end)
      if !new_range.include?(average)
        new_range = (average..range.end)
        new_range = (new_range.begin.floor..new_range.end.ceil) unless float_mode
      end
      return rand_range_weighted(new_range, average: average)
    else
      return num
    end
  end
end


class ShopItemPool
  attr_reader :pool_id,
              :game
  attr_accessor :item_ids

  SHOP_ITEM_POOL_LIST = [
    0x2c19e4, #Running Out of Sage
    0x2c5248, #Medicinal Ingredients Needed
    0x2c4f98, #Mandrake is the Best Medicine
    0x2c1e64, #Unusual Medicine Components
    0x2c319c, #A Lucky Stone
    0x2cc270, #A Pleasant Accessory
    0x2cc260, #A Heartwarming Accessory
    0x2c4f08, #Poor Preparation is Costly
    0x2c1cc4, #What the Blacksmith Does Best
    0x2cc250, #Work of the Finest Quality
    0x2c31c4, #Needs More Salt
    0x2c53a8, #I've Never Eaten That
    0x2c21b4, #Can't Cook Without Ingredients
    0x2c30dc, #Case of the Vicious Blight
    0x2c3104, #Case of the Demon Horse
    0x2c30b4, #Case of the Hideous Snowman
    0x2c2364, #The Silent Violin
    0x2c5318, #The Killing Scream
    0x2c50f8, #Artists Can Be Selfish
    0x2c1974, #Making a Dress!
    0x2c5028, #Silkworm's Tragedy
    0x2c29e4  #Is That Cashmere?
  ]

  def initialize(pool_id, game)
    @pool_id = pool_id
    @game = game
    @dra03 = game.dra03

    read_data()
  end

  def []=(i, item_id)
    @item_ids[i] = item_id
    @dra03[@item_pool_pointer+2, 2] = @item_ids[0..@num_items-1]
  end

  def read_data
    @item_pool_pointer = SHOP_ITEM_POOL_LIST[pool_id]


    @num_items = @dra03[@item_pool_pointer, 2]
    @item_ids = @num_items > 1 ? @dra03[@item_pool_pointer+2, 2, @num_items] : [@dra03[@item_pool_pointer+2, 2, @num_items]]
  end
end