class Entity
  attr_reader :room,
              :alldata,
              :x_pos,
              :y_pos,
              :unique_id,
              :type,
              :subtype,
              :byte_8,
              :var_a,
              :var_b

  #other instance variables have their own custom setters that write to @alldata
  attr_accessor :entity_pointer

  def x_pos=(x)
    check_pointer()
    @alldata[entity_pointer, 2] = x
    @x_pos = x
  end
  def y_pos=(y)
    check_pointer()
    @alldata[entity_pointer+2, 2] = y
    @y_pos = y
  end
  def unique_id=(id)
    check_pointer()
    @alldata[entity_pointer+4] = id
    @unique_id = id
  end
  def type=(t)
    check_pointer()
    @alldata[entity_pointer+5] = t
    @type = t
  end
  def subtype=(st)
    check_pointer()
    @alldata[entity_pointer+6] = st
    @subtype = st
  end
  def byte_8=(b)
    check_pointer()
    @alldata[entity_pointer+7] = b
    @byte_8 = b
  end
  def var_a=(a)
    check_pointer()
    @alldata[entity_pointer+8, 2] = a
    @var_a = a
  end
  def var_b=(b)
    check_pointer()
    @alldata[entity_pointer+10, 2] = b
    @var_b = b
  end

  def initialize(room, ent_ptr, alldata)
    @room = room
    @game = room.game
    @alldata = alldata
    @entity_pointer = ent_ptr
    @x_pos = @y_pos = @unique_id = @type = @subtype = @byte_8 = @var_a = @var_b = 0
    #unique_id = 0 #@room.get_unused_unique_id()
    read_data(ent_ptr)
  end

  def read_data(e)
    @x_pos = @alldata[e, 2]
    @y_pos = @alldata[e+2, 2]
    @unique_id = @alldata[e+4]
    @type = @alldata[e+5]
    @subtype = @alldata[e+6]
    @byte_8 = @alldata[e+7]
    @var_a = @alldata[e+8, 2]
    @var_b = @alldata[e+10, 2]
  end

  def copy_data(e)
    if e.nil?
      raise "Can't copy an entity that doesn't have a pointer"
    end
    # read_data does not write to the patch, so we have to use copy_data if we want copies to stick.
    @x_pos = @alldata[e, 2]
    @y_pos = @alldata[e+2, 2]
    @unique_id = @alldata[e+4]
    @type = @alldata[e+5]
    @subtype = @alldata[e+6]
    @byte_8 = @alldata[e+7]
    @var_a = @alldata[e+8, 2]
    @var_b = @alldata[e+10, 2]
    @alldata[entity_pointer, 2] = @x_pos
    @alldata[entity_pointer+2, 2] = @y_pos
    @alldata[entity_pointer+4] = @unique_id
    @alldata[entity_pointer+5] = @type
    @alldata[entity_pointer+6] = @subtype
    @alldata[entity_pointer+7] = @byte_8
    @alldata[entity_pointer+8, 2] = @var_a
    @alldata[entity_pointer+10, 2] = @var_b
  end

  def check_pointer
    if entity_pointer.nil?
      raise "Can't save an entity that doesn't have a pointer"
    end
  end

  def is_enemy?
    type == 1
  end

  def is_common_enemy?
    [*0x00..0x66, *0x68..0x6A].include?(subtype)
  end

  def is_boss?
    is_enemy? and not is_common_enemy?
  end

  def is_special_object?
    type == 2
  end

  def is_candle?
    type == 3
  end

  def is_normal_pickup?
    type == 4
  end

  def is_hidden_pickup?
    type == 7
  end

  def is_pickup?
    is_normal_pickup? or is_hidden_pickup?
  end

  def is_heart?
    is_pickup? and subtype == 0x00
  end

  def is_money_bag?
    is_pickup? and subtype == 0x01
  end

  def is_item?
    is_pickup? and subtype == 0xFF
  end

  def is_skill?
    is_pickup? and (0x02..0x04).include?(subtype)
  end

  alias is_glyph? is_skill?

  def is_glyph_statue?
    is_special_object? and subtype == 0x02 and var_a == 0
  end

  def is_item_chest?
    is_special_object? and (0x16..0x17).include?(subtype)
  end

  def is_boss_door?
    is_special_object? and subtype == 0x48
  end

  def is_wooden_door?
    is_special_object? and subtype == 0x2E
  end

  def is_save_point?
    is_special_object? and subtype == 0x46
  end

  def is_warp_point?
    is_special_object and subtype == 0x34
  end

  def is_villager?
    is_special_object and subtype == 0x89
  end

  #def entity_str
    #@entity_str ||= "#{room.room_str}_%02X" % room.entities.index(self)
  #end
end