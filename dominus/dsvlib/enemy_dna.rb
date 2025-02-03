class EnemyDNA
  attr_reader :enemy_id,
              :name,
              :atk,
              :glyph

  def initialize(enemy_id, game)
    @enemy_id = enemy_id
    @game = game
    @dra03 = game.dra03
    @enemy_ptr = 0x2d76b0 + enemy_id*0x30
    @name = game.enemy_docs[enemy_id].split("\n").first
    read_data(@enemy_ptr)
  end

  def read_data(ptr)
    @create_code = @dra03[ptr, 1, 8]
    @update_code = @dra03[ptr+0x8, 1, 8]
    @item_1 = @dra03[ptr+0x10, 2]
    @item_2 = @dra03[ptr+0x12, 2]
    @petrified_palette = @dra03[ptr+0x14]
    @ap_on_kill = @dra03[ptr+0x15]
    @hp = @dra03[ptr+0x16, 2]
    @exp_on_kill = @dra03[ptr+0x18, 2]
    @blood_color = @dra03[ptr+0x1a]
    @glyph = @dra03[ptr+0x1c, 2]
    @glyph_chance = @dra03[ptr+0x1e]
    @atk = @dra03[ptr+0x1f]
    @def = @dra03[ptr+0x20]
    @mnd = @dra03[ptr+0x21]
    @item_1_chance = @dra03[ptr+0x22]
    @item_2_chance = @dra03[ptr+0x23]
  end

  def item_1=(item)
    check_pointer()
    @dra03[@enemy_ptr+0x10, 2] = item
    @item_1 = item
  end

  def item_2=(item)
    check_pointer()
    @dra03[@enemy_ptr+0x12, 2] = item
    @item_2 = item
  end

  def glyph=(g)
    check_pointer()
    @dra03[@enemy_ptr+0x1c, 2] = g
    @glyph = g
  end

  def check_pointer
    if @enemy_ptr.nil?
      raise "Can't save an enemy that doesn't have a pointer"
    end
  end
end
