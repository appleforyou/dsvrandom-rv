require_relative 'room'
require_relative 'gamefile'
require_relative 'tweaks'
require_relative 'enemy_dna'

class Game


  attr_reader :areas,
              :rooms,
              :alldata,
              :dra03,
              :tweaks,
              :checker,
              :options,
              :mode,
              :enemy_dnas,
              :arthroverta

  def initialize(options, game_folder, backup_folder, patch_folder, checker, mode = :normal, rng, &block)
    @areas = {}
    @rooms = []
    @options = options
    @game_folder = game_folder
    @backup_folder = backup_folder
    @patch_folder = patch_folder
    @checker = checker
    @mode = mode
    dra03_stages = 0
    alldata_stages = 0
    puts "Version is #{@options[:version]}"
    dra03_md5 = @options[:version] == "1.03" ? "59ab56a5b89bd900d938bdb2bca374e3" : "53d82db8c4451830f1ba81c6d6f314ad"
    alldata_md5 = @options[:version] == "1.03" ? "bdda0efe6d40c80d824491aaf9098ffb" : "ffc1fd1b79a313802093c1ecc1cb7c3a"
    @dra03 = GameFile.new(self, @backup_folder + "/dra03_backup.dll", @game_folder + "/dra03.dll", @patch_folder, dra03_md5, options, mode) do |stages|
      dra03_stages = stages
      yield (dra03_stages + alldata_stages)
    end
    if File.file?(@backup_folder + "/windata/alldata_backup.bin")
      @alldata = GameFile.new(self, @backup_folder + "/windata/alldata_backup.bin", @game_folder + "/windata/alldata.bin", @patch_folder, alldata_md5, options, mode) do |stages|
        alldata_stages = stages
        yield (dra03_stages + alldata_stages)
      end
    else
      @alldata = GameFile.new(self, @backup_folder + "/alldata_backup.bin", @game_folder + "/windata/alldata.bin", @patch_folder, alldata_md5, options, mode) do |stages|
        alldata_stages = stages
        yield (dra03_stages + alldata_stages)
      end
    end
    #File.binwrite(@prefix + "windata/alldata_test.bin", File.binread(@prefix + "windata/alldata_backup.bin"))
    @current_sector = 0
    @tweaks = Tweaks.new(self)
    if [:normal, :auto_apply].include?(mode)
      tweaks.general_game_tweaks()
      read_all_rooms()
      tweaks.post_read_tweaks()
      if @options[:rv_arthrovertas_revenge]
        @arthroverta = Arthroverta.new(self, rng)
      end
    end
    yield 5

  end

  #called by room initialization code
  def get_area_and_sector_by_id(target_area, target_sector)
    #target_area, target_sector = id[0..1], id[3..4]
    if areas[target_area].nil?
      areas[target_area] = {target_sector => []}
    elsif areas[target_area][target_sector].nil?
      areas[target_area][target_sector] = []
    end
    a = areas[target_area]
    return [a, a[target_sector]]
  end

  def enemy_dnas
    @enemy_dnas ||= begin
      enemy_dnas = []

      (0x00..0x78).each do |enemy_id|
        enemy_dna = EnemyDNA.new(enemy_id, self)
        enemy_dnas << enemy_dna
      end

      enemy_dnas
    end
  end

  def enemy_docs
    @enemy_docs ||= begin
      file_contents = File.read("./docs/lists/OoE Enemies.txt")
      enemy_docs_arr = file_contents.scan(/^(\h\h [^\n]+\n(?:  [^\n]+\n)*)/)

      enemy_docs = {}
      enemy_docs_arr.each do |desc|
        id = desc.first[0..1].to_i(16)
        enemy_docs[id] = desc.first[3..-1]
      end

      enemy_docs
    end
  rescue Errno::ENOENT => e
    ""
  end

  def read(f, offset, length = 1, bytes = 1)
    encoding = "C*"
    if bytes == 2
      encoding = "v*"
    end
    result = File.binread(f, length, offset).unpack(encoding)
    if length == 1
      return result[0]
    else
      return result
    end
  end

  def read_room(room_offset)
    room_offset_list_start = 0x21a1a3a0
    #room_ptr = room_offset_list_start + alldata[room_offset] + alldata[room_offset+1]*0x100
    room_ptr = room_offset_list_start + alldata[room_offset, 2]
    room = Room.new(room_ptr, self)
    @rooms << room
    areas[room.area_index][room.sector_index] += [room]
  end

  def read_all_rooms()
    i = 0x21a1a3ac
    while i < 0x21a1b330
        read_room(i)
        i += 8
    end
  end

  def get_entity_by_id(id)
    area, sector, room, entity = id[0..1].to_i(16), id[3..4].to_i(16), id[6..7].to_i(16), id[9..10].to_i(16)
    return areas[area][sector][room].entities[entity]
  end

  def write_data()
    File.binwrite(@game_folder + "dra03_test.dll", dra03.pack("C*"))
    #File.binwrite(@game_folder + "/windata/alldata_test.bin", alldata.pack("C*"))
  end
  def write_data2(content, f, offset, bytes = 1)
    encoding = "C*"
    if bytes == 2
      encoding = "v*"
    end
    File.binwrite(@game_folder + "/windata/alldata_test.bin", content.pack(encoding), offset)
  end

  def write_patch()
    @dra03.write_patch()
    @alldata.write_patch()
  end
  def apply_patch(mode = :apply)
    @dra03.apply_patch(mode)
    @alldata.apply_patch(mode)
  end

  class Arthroverta
    attr_reader :boss_room_id,
                :boss_loc,
                :hider_loc,
                :door_loc,
                :magnes_loc,
                :skip_door,
                :skip_hider

    def initialize(game, rng)
      @boss_room_id = possible_rooms.keys.sample(random: rng)
      boss_room = possible_rooms[boss_room_id]
      @boss_loc = boss_room[:boss_loc]
      @door_loc = boss_room[:door_loc]
      @hider_loc = boss_room[:hider_loc]
      @magnes_loc = boss_room[:magnes_loc]
      @skip_door = boss_room[:skip_door]
      @skip_hider = boss_room[:skip_hider]
      arthroverta = game.get_entity_by_id(boss_room_id + "_00")
      magnes = game.get_entity_by_id(boss_room_id + "_01")
      door = @skip_door ? nil : game.get_entity_by_id(boss_room_id + "_02")
      if @skip_hider
        hider = nil
      else
        hider = @skip_door ? game.get_entity_by_id(boss_room_id + "_02") : game.get_entity_by_id(boss_room_id + "_03")
      end
      game.get_entity_by_id(boss_room_id + "_" + boss_loc).copy_data(arthroverta.entity_pointer) if not @boss_loc.nil?
      game.get_entity_by_id(boss_room_id + "_" + magnes_loc).copy_data(magnes.entity_pointer) if not @magnes_loc.nil?
      if not door.nil?
        game.get_entity_by_id(boss_room_id + "_" + door_loc).copy_data(door.entity_pointer) if not @door_loc.nil?
      end
      if not hider.nil?
        game.get_entity_by_id(boss_room_id + "_" + hider_loc).copy_data(hider.entity_pointer) if not @hider_loc.nil?
      end
      arthroverta.x_pos = boss_room[:boss_x]
      arthroverta.y_pos = boss_room[:boss_y]
      arthroverta.type = 1
      arthroverta.subtype = 0x6c
      arthroverta.var_a = 0
      arthroverta.var_b = 0
      if not hider.nil?
        hider.x_pos = 0
        hider.y_pos = 0
        hider.type = 8
        hider.subtype = 1
        hider.byte_8 = 0
        hider.var_a = 0
        hider.var_b = 0
      end
      if not door.nil?
        door.x_pos = boss_room[:door_x]
        door.y_pos = boss_room[:door_y]
        door.type = 2
        door.subtype = 0x4b
        door.var_a = 1
        door.var_b = 1
      end
      if not magnes.nil?
        if boss_room[:magnes_x].nil?
          magnes.x_pos = arthroverta.x_pos - 0x60
        else
          magnes.x_pos = boss_room[:magnes_x]
        end
        magnes.y_pos = arthroverta.y_pos - 0x88
        magnes.type = 2
        magnes.subtype = 1
        magnes.var_a = 0
        magnes.var_b = 0
      end
    end

    def possible_rooms
      #If a loc is nil, it means that the thing that was originally in that location is expendable, so we don't need to copy it somewhere else before overwriting it.
      possible_rooms = {
        "12-00-08" => {
                       boss_loc: "02",
                       door_loc: nil,
                       skip_door: true,
                       magnes_loc: nil,
                       hider_loc: nil,
                       skip_hider: true,
                       boss_x: 0x110,
                       boss_y: 0xb0,
                       magnes_x: 0x190
                      },
        "12-00-09" => {
                       boss_loc: "04",
                       door_loc: "05",
                       magnes_loc: nil,
                       hider_loc: nil,
                       boss_x: 0x390,
                       boss_y: 0xb0,
                       door_x: 0x3e0,
                       door_y: 0x80,
                       magnes_x: 0x200
                      },
        "12-00-0B" => {
                       boss_loc: "04",
                       door_loc: nil,
                       skip_door: true,
                       magnes_loc: "05",
                       hider_loc: nil,
                       boss_x: 0x70,
                       boss_y: 0xb0,
                       magnes_x: 0xf0
                      },
        "12-00-0C" => {
                       boss_loc: "04",
                       door_loc: nil,
                       magnes_loc: nil,
                       hider_loc: "05",
                       boss_x: 0x190,
                       boss_y: 0xb0,
                       door_x: 0x1e0,
                       door_y: 0x80
                      },
        #"06-00-18" => {
                       #boss_loc: "05",
                       #door_loc: nil,
                       #skip_door: true,
                       #magnes_loc: "03",
                       #skip_magnes: true,
                       #hider_loc: nil,
                       #boss_x: 0x50,
                       #boss_y: 0xb0
                      #},
        #"07-00-12" => {
                       #boss_loc: nil,
                       #door_loc: nil,
                       #magnes_loc: "04",
                       #skip_magnes: true,
                       #hider_loc: nil,
                       #boss_x: 0x280,
                       #boss_y: 0x160,
                       #door_x: 0x2f0,
                       #door_y: 0x80
                      #},
        #"07-00-14"?
      }
    end
  end
end
