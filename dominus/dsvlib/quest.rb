class Quest
  attr_reader :quest_index,
              :name,
              :required_item_ids

  QUEST_NAMES = {
    0x00 => "Get Business Started", #unused
    0x01 => "Running Out of Sage",
    0x02 => "Medicinal Ingredients Needed",
    0x03 => "Mandrake is the Best Medicine",
    0x04 => "Unusual Medicine Components",
    0x05 => "A Lucky Stone",
    0x06 => "A Pleasant Accessory",
    0x07 => "A Heartwarming Accessory",
    0x08 => "The Job of a Lifetime",
    0x09 => "Poor Preparation is Costly",
    0x0a => "What the Blacksmith Does Best",
    0x0b => "Work of the Finest Quality",
    0x0c => "Needs More Salt",
    0x0d => "I've Never Eaten That",
    0x0e => "Can't Cook Without Ingredients",
    0x0f => "Case of the Vicious Blight",
    0x10 => "Case of the Demon Horse",
    0x11 => "Case of the Hideous Snowman",
    0x12 => "The Silent Violin",
    0x13 => "The Killing Scream",
    0x14 => "Artists Can Be Selfish",
    0x15 => "Hide and Seek!",
    0x16 => "Show Me the Owl!",
    0x17 => "Can't Catch Me!",
    0x18 => "Finding Tom",
    0x19 => "Mice Make for Good Eats",
    0x1a => "Tom and Jewelry",
    0x1b => "Making a Dress!",
    0x1c => "Silkworm's Tragedy",
    0x1d => "Is That Cashmere?",
    0x1e => "Vicious Crows",
    0x1f => "Do You Hear Howling?",
    0x20 => "An Unwelcome Guest",
    0x21 => "A Beacon of Hope",
    0x22 => "Important Resting Place",
    0x23 => "Tragic Memories"
  }

  def initialize(quest_index, game)
    @quest_index = quest_index
    @game = game
    @dra03 = game.dra03
    @quest_ptr = 0x2bb710 + quest_index*0x18
    @name = QUEST_NAMES[quest_index]
    read_data(@quest_ptr)
  end

  def read_data(ptr)
    @reward = @dra03[ptr, 2]
    @quest_modifiers = @dra03[ptr+0x10]
    requirements_ptr_raw = @dra03[ptr+8, 1, 8]
    if requirements_ptr_raw != [0,0,0,0,0,0,0,0]
      requirements_offset = requirements_ptr_raw[0..2] + [0x0]
      dra03_offset = 0x1a00
      @requirements_ptr = requirements_offset.pack("C*").unpack("V").first - dra03_offset
    else
      @requirements_ptr = nil
    end
    if is_a_kill_quest?
      @which_kill_quest_index, @num_enemies_to_kill = @dra03[@requirements_ptr, 2, 2]
    elsif is_a_fetch_quest?
      @num_required_items = @dra03[@requirements_ptr, 2]
      @required_item_ids = @dra03[@requirements_ptr+2, 2, @num_required_items]
    end
  end

  def reward=(item)
    check_pointer()
    @dra03[@quest_ptr, 2] = item
    @reward = item
  end

  def handle_static_quest_requirement
    @num_required_items = 1
    @dra03[@requirements_ptr, 2] = @num_required_items
    case @quest_index
    when 0x3
      @dra03[@requirements_ptr+2, 2] = 0xc4 #Mandrake Root only
      @game.tweaks.change_item_text_for_static_requirement("Mandrake Root", "MndrkeRt+Sage")
    when 0x4
      @dra03[@requirements_ptr+2, 2] = 0xc5 #Merman Meat only
      @game.tweaks.change_item_text_for_static_requirement("Merman Meat", "MrmnMt+Sage")
    #The rest will just use the first item in the list which is already the correct item.
    when 0x9
      @game.tweaks.change_item_text_for_static_requirement("Iron Ore", "Iron x3")
    when 0xa
      @game.tweaks.change_item_text_for_static_requirement("Silver Ore", "Silver x3")
    when 0xb
      @game.tweaks.change_item_text_for_static_requirement("Gold Ore", "Gold x3")
    when 0x1b
      @game.tweaks.change_item_text_for_static_requirement("Cotton Thread", "Cotton x5")
    when 0x1c
      @game.tweaks.change_item_text_for_static_requirement("Silk Thread", "Silk x5")
    when 0x1d
      @game.tweaks.change_item_text_for_static_requirement("Cashmere Thread", "Cashmere x5")
    end
  end

  def check_pointer
    if @quest_ptr.nil?
      raise "Can't save a quest that doesn't have a pointer"
    end
  end

  def reward_is_gold?
    (@quest_modifiers & 0x1) != 0
  end

  def is_a_kill_quest?
    (@quest_modifiers & 0x4) != 0
  end

  def is_a_fetch_quest?
    (not is_a_kill_quest?) and (not @requirements_ptr.nil?)
  end

  def reward_is_pickup?
    (not reward_is_gold?) and (@reward != 0xffff)
  end
end