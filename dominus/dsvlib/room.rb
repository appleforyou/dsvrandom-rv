require_relative 'entity'

class Room


  attr_reader :area,
              :sector,
              :area_index,
              :sector_index,
              :room_index,
              :alldata,
              :game

  attr_accessor :entity_list_pointer,
                :entities

  def initialize(e, game)
    @game = game
    @alldata = game.alldata
    @entity_list_pointer = e
    @entities = []
    @area = @sector = @area_index = @sector_index = @room_index = nil
    read_data()
    create_entities()
    if area.nil? or sector.nil? or area_index.nil? or sector_index.nil? or room_index.nil?
      raise "Error occurred while loading room #{e}"
    end
  end

  def read_data()
    e = entity_list_pointer
    if e < 0x21a1b330
      raise "Entity list pointer too low! This shouldn't have happened!"
    #Zones in the code are not exactly in the order of the DS randomizer ID strings, but I'll give them those IDs anyway so I can reuse existing code.
    #Lists of which zone these entity lists belong to are probably in the game data, but writing it out is less effort for now.
    elsif e < 0x21a1b520 #Wygol Village
      @area_index = 0x01
      if e < 0x21a1b440
        @sector_index = 0
      else
        @sector_index = 1
      end
    elsif e < 0x21a1b720 #Ecclesia
      @area_index = 0x02
      @sector_index = 0
    elsif e < 0x21a1be30 #Training Hall
      @area_index = 0x03
      @sector_index = 0
    elsif e < 0x21a1c250 #Ruvas Forest
      @area_index = 0x04
      @sector_index = 0
    elsif e < 0x21a1c4a0 #Argila Swamp
      @area_index = 0x05
      @sector_index = 0
    elsif e < 0x21a1d4c0 #Kalidus Channel
      @area_index = 0x06
      if e < 0x21a1d120
        @sector_index = 0
      else
        @sector_index = 1
      end
    elsif e < 0x21a1dda0 #Somnus Reef
      @area_index = 0x07
      if e < 0x21a1dcb0
        @sector_index = 0
      else
        @sector_index = 1
      end
    elsif e < 0x21a1e750 #Minera Prison Island
      @area_index = 0x08
      if e < 0x21a1e160
        @sector_index = 0
      elsif e < 0x21a1e500
        @sector_index = 1
      else
        @sector_index = 2
      end
    elsif e < 0x21a1e900 #Lighthouse
      @area_index = 0x09
      @sector_index = 0
    elsif e < 0x21a1f5b0 #Tymeo Mountains
      @area_index = 0x0a
      if e < 0x21a1f190
        @sector_index = 0
      else
        @sector_index = 1
      end
    elsif e < 0x21a1fee0 #Tristis Pass
      @area_index = 0x0b
      if e < 0x21a1fbf0
        @sector_index = 0
      else
        @sector_index = 1
      end
    elsif e < 0x21a20350 #Large Cavern
      @area_index = 0x0c
      @sector_index = 0
    elsif e < 0x21a20880 #Giant's Dwelling
      @area_index = 0x0d
      @sector_index = 0
    elsif e < 0x21a20d90 #Mystery Manor
      @area_index = 0x0e
      @sector_index = 0
    elsif e < 0x21a21080 #Misty Forest Road
      @area_index = 0x0f
      @sector_index = 0
    elsif e < 0x21a212e0 #Oblivion Ridge
      @area_index = 0x10
      if e < 0x21a210f0
        @sector_index = 0
      else
        @sector_index = 1
      end
    elsif e < 0x21a21820 #Skeleton Cave
      @area_index = 0x11
      @sector_index = 0
    elsif e < 0x21a25630 #Dracula's Castle
      @area_index = 0x00
      if e < 0x21a21bd0 #Castle Entrance
        @sector_index = 0x00
      elsif e < 0x21a21e90
        @sector_index = 0x01
      elsif e < 0x21a21fa0
        @sector_index = 0x0c
      elsif e < 0x21a22b50 #Underground Labyrinth
        @sector_index = 0x02
      elsif e < 0x21a23090 #Library
        @sector_index = 0x03
      elsif e < 0x21a23320
        @sector_index = 0x04
      elsif e < 0x21a23910 #Barracks
        @sector_index = 0x05
      elsif e < 0x21a244c0 #Mechanical Tower
        @sector_index = 0x06
      elsif e < 0x21a246f0
        @sector_index = 0x07
      elsif e < 0x21a24dd0 #Final Approach
        @sector_index = 0x0a
      elsif e < 0x21a24f50
        @sector_index = 0x0b
      elsif e < 0x21a253d0 #Arms Depot
        @sector_index = 0x08
      else #Forsaken Cloister
        @sector_index = 0x09
      end
    elsif e < 0x21a25f00 #Monastery
      @area_index = 0x12
      if e < 0x21a25eb0
        @sector_index = 0
      else
        @sector_index = 1
      end
    elsif e < 0x21a26638 #Epilogue etc.
      @area_index = 0x13
      if e < 0x21a25fe0
        @sector_index = 0
      elsif e < 0x21a26160
        @sector_index = 1
      elsif e < 0x21a26300
        @sector_index = 2
      elsif e < 0x21a26560
        @sector_index = 3
      elsif e < 0x21a265f0
        @sector_index = 4
      else
        @sector_index = 5
      end
    else
      raise "Entity list pointer too high! This shouldn't have happened!"
    end

    @area, @sector = game.get_area_and_sector_by_id(area_index, sector_index)
    @room_index = sector.size
  end

  def create_entities()
    i = entity_list_pointer
    while alldata[i] != 0xff
    #while game.read(alldata, i)[0] != 0xff
      entity = Entity.new(self, i, alldata)
      entities << entity
      i += 12
    end
  end

  def add_entity()
    entity = Entity.new(self, entity_list_pointer + entities.size*12, alldata)
    #Setting the position bytes here clears the marker that the game has reached the end of the entity list.
    entity.x_pos = 0
    entity.y_pos = 0
    entities << entity
    #entities.size now includes the new entity. Add the marker after the new end of the entity list.
    alldata[entity_list_pointer + (entities.size)*12] = [0xff,0x7f,0xff,0x7f]
    return entity
  end

  def room_str
    @room_str ||= "%02X-%02X-%02X" % [area_index, sector_index, room_index]
  end
end
