require_relative '../rv/ooe_items.rb'

class ChestPoolRandomizer
  attr_reader :wooden_chest_item_pools,
              :rng

  def initialize(rng, game)
    @game = game
    @rng = rng
    number_of_item_pools = 0xb
    #Wooden chests are listed after green chests in dominus version
    wooden_chests_list = 0x2bdcb0
    green_chests_list = 0x2bdc50
    @wooden_chest_item_pools = begin
      wooden_chest_item_pools = []

      (number_of_item_pools).times do |i|
        wooden_chest_item_pools << ItemPool.new(i, game, wooden_chests_list)
      end
      (number_of_item_pools).times do |i|
        wooden_chest_item_pools << ItemPool.new(i, game, green_chests_list)
      end

      wooden_chest_item_pools
    end

    randomize_wooden_chests()
  end

  def randomize_wooden_chests
    available_rare_wooden_chest_item_ids = [0x77, 0x7A, 0xCB, 0xCC, 0xCD, 0xD0, 0xD1]
    available_rare_wooden_chest_item_ids += (0x9C..0xA0).to_a # AP raisers (drops)
    available_rare_wooden_chest_item_ids *= 5 # Weight it towards these consumables
    #equipment = @game.checker.all_non_progression_pickups.select{|item_id| item_id >= 0xE5}
    available_rare_wooden_chest_item_ids += OoEItems.equipment.values.map do |v|#.select do |item_id|
      v[:id]#item = OoEItems.items[item_id]
      #item["Price"] >= 4000
    end
    #raise "Completed creating rare chest pools"

    available_common_wooden_chest_item_ids = (0x75..0xA3).to_a + (0xBA..0xD1).to_a
    available_common_wooden_chest_item_ids -= available_rare_wooden_chest_item_ids

    #raise "Completed creating wooden chest pools"

    available_common_wooden_chest_item_ids -= [0x7f,0x80,0x81]
    available_rare_wooden_chest_item_ids -= [0x7f,0x80,0x81]

    available_common_wooden_chest_item_ids.shuffle!(random: rng)
    available_rare_wooden_chest_item_ids.shuffle!(random: rng)

    items = {}
    ((@wooden_chest_item_pools.size-1)*4).times do |i|
      item_name, item = @game.checker.get_unplaced_non_progression_item_except_relics_for_wooden_chest()
      items[item_name + i.to_s] = item #Assign a number so that we can have duplicates in the hash.
    end

    weights = items.keys.map do |item_name|
      #Weight higher-tiered equipment to be more likely to be chosen by green chests, and moreso for later-game chests
      weight = 1.0
      base_name = items[item_name][:name]
      if OoEItems.equipment.has_key?(base_name) #We want to weight equipment higher.
        weight *= 24
        weight *= items[item_name][:tier]*10 + 1
      elsif OoEItems.consumables.has_key?(base_name)
        #Weight consumables by their vanilla price.
        if items[item_name][:price].nil?
          price = 0
        else
          #Cap effective price for weighting at 1500 (slightly higher than Curry, which will typically full heal in randomizer)
          price = [items[item_name][:price], 1500].min
        end
        weight *= price/150.0 + 1.0
      end
      weight = Math.sqrt(weight)
      weight
    end

    ps = weights.map{|w| w.to_f / weights.reduce(:+)}
    weighted_items = items.keys.zip(ps).to_h
    ordered_items = weighted_items.sort_by{|_, w| rng.rand ** (1.0 / w)}.map{|k, v| k}

    @wooden_chest_item_pools.reverse_each do |pool|
      next if pool.pool_id == 0x15 # Skip rare pool A, which is never used
      (0..3).each do |i|
        item_id = items[ordered_items.pop()][:id] + 1
        pool[i] = item_id
      end
    end
  end
end

class ItemPool
  attr_reader :pool_id
  attr_reader :item_ids

  def initialize(pool_id, game, chest_list_ptr)
    @chest_list_ptr = chest_list_ptr
    @pool_id = pool_id
    @internal_id = pool_id
    if chest_list_ptr == 0x2bdc50 #Green chest
      @pool_id += 0xb #this is the external id for randomizer logic
    end
    @dra03 = game.dra03

    read_data()
  end

  def read_data
    @item_pool_pointer = @chest_list_ptr + 8*@internal_id

    @item_ids = @dra03[@item_pool_pointer, 2, 4]
  end

  def []=(i, item_id)
    @item_ids[i] = item_id
    @dra03[@item_pool_pointer, 2] = @item_ids[0..3]
  end
end
