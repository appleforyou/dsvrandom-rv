module OoERooms

#The majority of this file's code is from 2019 made for the unfinished map randomizer project, and some aspects of it are obsolete, so it shouldn't be considered accurate for logic.
#It still serves well enough for current needs for other purposes and will be edited gradually.

class Object
  def deep_clone
    return @deep_cloning_obj if @deep_cloning
    @deep_cloning_obj = clone
    @deep_cloning_obj.instance_variables.each do |var|
      val = @deep_cloning_obj.instance_variable_get(var)
      begin
        @deep_cloning = true
        val = val.deep_clone
      rescue TypeError
        next
      ensure
        @deep_cloning = false
      end
      @deep_cloning_obj.instance_variable_set(var, val)
    end
    deep_cloning_obj = @deep_cloning_obj
    @deep_cloning_obj = nil
    deep_cloning_obj
  end
end

class Rm #Room map
  attr_reader :name,
              :zone,
              :subzone,
              :doors,
              :width,
              :height,
              :is_important,
              :id,
              :traits,
              :enemies

  attr_accessor :map_x,
                :map_y

  def initialize(subroom, subzone, entities, id, room = nil, width: 1, height: 1, room_req: true, room_type: :normal, is_important: false, traits: nil)
    castle_subzones = ["Castle Entrance", "Library", "Underground Labyrinth", "Barracks", "Mechanical Tower", "Arms Depot", "Forsaken Cloister", "Final Approach"]
    if castle_subzones.include?(subzone)
      @zone = "Dracula's Castle"
      @subzone = subzone
    else
      @zone = subzone
    end
    @doors = entities.select {|e| e.is_a?(Door)}
    @enemies = {}
    entities.select {|e| e.kind_of?(Enemy)}.each do |e|
      @enemies[e.id] = e
    end
    @id = id
    @subroom = room == nil ? nil : subroom
    @room = room == nil ? subroom : room
    @name = @room
    @width = width
    @height = height
    @room_type = room_type
    @is_important = is_important
    if !traits.kind_of?(Array)
      traits = [traits]
    end
    @traits = traits
    hash_entry = OoERooms.all_rooms[id]
    if hash_entry.nil?
      OoERooms.all_rooms[id] = self
      OoERooms.enemies_by_room[id] = @enemies
    elsif not hash_entry.kind_of?(Array)
      OoERooms.all_rooms[id] = [hash_entry] + [self]
      OoERooms.enemies_by_room[id] = OoERooms.enemies_by_room[id].merge(@enemies)
    else
      OoERooms.all_rooms[id] << self
      OoERooms.enemies_by_room[id] = OoERooms.enemies_by_room[id].merge(@enemies)
    end
  end

  def find_door(direction, target)
    if [:left, :right].include?(direction)
      @doors.find {|door| door.direction == direction && door.height == target}
    elsif [:up, :down].include?(direction)
      @doors.find {|door| door.direction == direction && door.width == target}
    end
  end

  def is_starting_room
    @room_type == :entrance
  end

  def is_loading_room
    @room_type == :loading
  end

  def is_teleporter
    @room_type == :teleporter
  end

  def is_save_room
    @room_type == :save
  end
end

class Door
  attr_reader :direction,
              :width,
              :height

  def initialize(direction, dest_room, available = true, subroom: nil, width: 1, height: 1)
    @direction = direction
    @available = available
    @dest_room = dest_room
    @subroom = subroom
    @width = width
    @height = height
  end
end

class Item
  def initialize(name, available = true, lock: nil, escape: nil, id: nil)
    @name = name
    @available = available
    @lock = lock
    @escape = escape
    @id = id
  end
end

class Enemy
  attr_reader :name,
              :id,
              :type

  def initialize(name, available = true, lock: nil, escape: nil, id: nil, type: "Normal")
    @name = name
    @available = available
    @lock = lock
    @escape = escape
    @id = id
    if !type.kind_of?(Array)
      type = [type]
    end
    @type = type
  end
end

#beginning OoERooms module code

  @@all_rooms = {}
  @@enemies_by_room = {}

  def self.all_rooms
    @@all_rooms
  end

  def self.enemies_by_room
    @@enemies_by_room
  end

  def self.castle_rooms
    castle_rooms = [ [
    #Dracula's Castle
    #Castle Entrance
      Rm.new("Starting Room", "Castle Entrance", [
          Door.new(:right, "00-0C-01"),
          ],
        "00-0C-00", room_type: :entrance, is_important: true
        ),
      Rm.new("Starting Teleporter", "Castle Entrance", [
          Door.new(:left, "00-0C-00"),
          Door.new(:right, "00-0C-02"),
          ],
        "00-0C-01", room_type: :teleporter
        ),
      Rm.new("Drawbridge Outer", "Castle Entrance", [
          Door.new(:left, "00-0C-01"),
          Door.new(:right, "00-0C-03"),
          ],
        "00-0C-02", width: 2
        ),
      Rm.new("Drawbridge Inner", "Castle Entrance", [
          Door.new(:left, "00-0C-02"),
          Door.new(:right, "00-0C-04"),
          ],
        "00-0C-03", width: 2
        ),
      ],[
      Rm.new("Drawbridge Loading", "Castle Entrance", [
          Door.new(:left, "00-0C-03"),
          Door.new(:right, "00-00-00"),
          ],
        "00-0C-04", room_type: :loading
        ),
      Rm.new("Front Door", "Castle Entrance", [
          Door.new(:left, "00-0C-04"),
          Door.new(:right, "00-00-01", "Bottom"),
          Enemy.new("Peeping Eye", id: "01", type: ["Seeker", "Vanguard", "Floor"]),
          Enemy.new("Blood Skeleton", id: "02", type: "Persistent"),
          Enemy.new("Gargoyle", id: "03", type: ["Seeker", "Floor"]),
          Enemy.new("Ghoul", id: "04", type: ["Persistent", "Vanguard"])
          ],
        "00-00-00", width: 3, traits: "Spacious"
        ),
      Rm.new("Lobby Top", "Castle Entrance", [
          Item.new("HEART Max Up", "highJump"),
          Door.new(:down, "00-00-01", subroom: "Bottom", width: 2),
          Door.new(:right, "00-00-03", "highJump", subroom: "Bottom"),
          Enemy.new("Peeping Eye", id: "02", type: ["Seeker", "Floor", "Separated"]),
          Enemy.new("Black Panther", id: "03", type: ["Challenger", "Separated"]),
          Enemy.new("Flea Man", id: "04", type: ["Nuisance", "Floor", "Semi-Enclosed", "Vanguard"]),
          ],
        "00-00-01", "Lobby", width: 2
        ),
      Rm.new("Lobby Bottom", "Castle Entrance", [
          Door.new(:left, "00-00-00"),
          Door.new(:up, "00-00-01", "highJump", subroom: "Top", width: 2),
          Door.new(:right, "00-00-02"),
          Enemy.new("Black Panther", id: "01", type: ["Vanguard", "Semi-Enclosed"]),
          Enemy.new("Flea Man", id: "05", type: ["Nuisance", "Floor"]),
          Enemy.new("Flea Man", id: "06", type: ["Nuisance", "Floor", "Separated", "CollisionIssue"]),
          ],
        "00-00-01", "Lobby", width: 2
        ),
=begin
      Rm.new("Lobby", "Castle Entrance", [
          Door.new(:left, "00-00-00"),
          Item.new("HEART Max Up", "highJump"),
          Door.new(:right, "00-00-03", "highJump", height: 2),
          Door.new(:right, "00-00-02"),
          Enemy.new("Black Panther", id: "01", type: ["Vanguard", "Semi-Enclosed"]),
          Enemy.new("Peeping Eye", id: "02", type: ["Seeker", "Floor", "Separated"]),
          Enemy.new("Black Panther", id: "03", type: ["Challenger", "Separated"]),
          Enemy.new("Flea Man", id: "04", type: ["Nuisance", "Floor", "Semi-Enclosed", "Vanguard"]),
          Enemy.new("Flea Man", id: "05", type: ["Nuisance", "Floor"]),
          Enemy.new("Flea Man", id: "06", type: ["Nuisance", "Floor", "Separated"]),
          ],
        "00-00-01", width: 2, height: 2
        ),
=end
      Rm.new("Lobby Save", "Castle Entrance", [
          Door.new(:left, "00-00-01", subroom: "Bottom"),
        ],
        "00-00-02", room_type: :save
        ),
      Rm.new("Tasty Stairs Top", "Castle Entrance", [
          Door.new(:left, "00-00-04", subroom: "Bottom"),
          Item.new("Tasty Meat", lock: "highJump", escape: "Bottom"),
          Door.new(:down, "00-00-03", subroom: "Bottom"),
          Door.new(:right, "00-00-09"),
          Enemy.new("Blood Skeleton", id: "03", type: ["Persistent", "Enclosed"]),
          Enemy.new("Blood Skeleton", id: "04", type: ["Persistent", "Separated"]),
          ],
        "00-00-03", "Tasty Stairs", height: 2
        ),
      Rm.new("Tasty Stairs Bottom", "Castle Entrance", [
          Door.new(:left, "00-00-01", subroom: "Top"),
          Door.new(:up, "00-00-03", "highJump", subroom: "Top"),
          Enemy.new("Blood Skeleton", id: "02", type: ["Persistent", "Enclosed"]),
          ],
        "00-00-03", "Tasty Stairs"
        ),
=begin
      Rm.new("Tasty Stairs", "Castle Entrance", [
          Door.new(:left, "00-00-04", height: 3),
          Door.new(:left, "00-00-01"),
          Item.new("Tasty Meat", lock: "highJump", escape: "Bottom"),
          Door.new(:right, "00-00-09", height: 3),
          Enemy.new("Blood Skeleton", id: "02", type: ["Persistent", "Enclosed"]),
          Enemy.new("Blood Skeleton", id: "03", type: ["Persistent", "Enclosed"]),
          Enemy.new("Blood Skeleton", id: "04", type: ["Persistent", "Separated"]),
          ],
        "00-00-03", height: 3
        ),
=end
      Rm.new("West Fork Top", "Castle Entrance", [
          Door.new(:left, "00-00-05", "highJump"),
          Door.new(:down, "00-00-04", subroom: "Bottom", width: 2),
          Item.new("White Drops", "highJump"),
          Enemy.new("Black Panther", id: "03", type: ["Challenger", "Wall"]),
          Enemy.new("Peeping Eye", id: "04", type: ["Seeker", "Floor"]),
          ],
        "00-00-04", "West Fork", width: 2
        ),
      Rm.new("West Fork Bottom", "Castle Entrance", [
          Door.new(:up, "00-00-04", subroom: "Top", width: 2),
          Door.new(:right, "00-00-03", subroom: "Top"),
          Enemy.new("Black Panther", id: "02", type: ["Challenger", "Semi-Enclosed", "Wall"]),
          ],
        "00-00-04", "West Fork", width: 2
        ),
=begin
      Rm.new("West Fork", "Castle Entrance", [
          Door.new(:left, "00-00-05", "highJump", height: 2),
          Item.new("White Drops", "highJump"),
          Door.new(:right, "00-00-03"),
          Enemy.new("Black Panther", id: "02", type: ["Challenger", "Semi-Enclosed", "Wall"]),
          Enemy.new("Black Panther", id: "03", type: ["Challenger", "Wall"]),
          Enemy.new("Peeping Eye", id: "04", type: ["Seeker", "Floor"]),
          ],
        "00-00-04", width: 2, height: 2
        ),
=end
      Rm.new("West Fork to West Bend", "Castle Entrance", [
          Door.new(:left, "00-00-06", subroom: "Bottom"),
          Door.new(:right, "00-00-04", subroom: "Top"),
          Enemy.new("Ghoul", id: "01", type: ["Persistent", "Vanguard"]),
          Enemy.new("Black Panther", id: "02", type: "Vanguard"),
          ],
        "00-00-05", width: 2, traits: "Spacious"
        ),
      Rm.new("West Bend Top", "Castle Entrance", [
          Door.new(:down, "00-00-06", subroom: "Bottom"),
          Door.new(:right, "00-00-07", height: 2),
          Enemy.new("Peeping Eye", id: "01", type: ["Seeker", "Floor"]),
          Enemy.new("Black Panther", id: "02", type: ["Challenger", "Separated"]),
          ],
        "00-00-06", "West Bend", height: 2
        ),
      Rm.new("West Bend Bottom", "Castle Entrance", [
          Door.new(:up, "00-00-06", "highJump", subroom: "Top"),
          Door.new(:right, "00-00-05"),
          Enemy.new("Black Panther", id: "00", type: ["Challenger", "Separated", "Enclosed"]),
          ],
        "00-00-06", "West Bend"
        ),
=begin
      Rm.new("West Bend", "Castle Entrance", [
          Door.new(:right, "00-00-07", height: 3),
          Door.new(:right, "00-00-05"),
          Enemy.new("Black Panther", id: "00", type: ["Challenger", "Separated", "Enclosed"]),
          Enemy.new("Peeping Eye", id: "01", type: ["Seeker", "Floor"]),
          Enemy.new("Black Panther", id: "02", type: ["Challenger", "Separated"]),
          ],
        "00-00-06", height: 3
        ),
=end
      Rm.new("West Bend to Library", "Castle Entrance", [
          Door.new(:left, "00-00-06", subroom: "Top"),
          Door.new(:right, "00-00-08"),
          Enemy.new("Ghoul", id: "01", type: ["Persistent", "Vanguard"]),
          Enemy.new("Ghoul", id: "02", type: ["Persistent", "Vanguard"]),
          Enemy.new("Peeping Eye", id: "03", type: ["Seeker", "Floor", "Vanguard"]),
          Enemy.new("Peeping Eye", id: "04", type: ["Seeker", "Floor", "Vanguard"]),
          Enemy.new("Blood Skeleton", id: "05", type: "Persistent"),
          ],
        "00-00-07", width: 4, traits: "Spacious"
        ),
      Rm.new("Entrance to Library Loading", "Castle Entrance", [
          Door.new(:left, "00-00-07"),
          Door.new(:right, "00-03-00")
          ],
        "00-00-08", room_type: :loading
        ),
      Rm.new("East Fork Left", "Castle Entrance", [
          Door.new(:left, "00-00-07"),
          Door.new(:right, "00-00-09", "Paries", subroom: "Right")
          ],
        "00-00-09", "East Fork"
        ),
      Rm.new("East Fork Right", "Castle Entrance", [
          Door.new(:left, "00-00-09", "Paries", subroom: "Left"),
          Item.new("HP Max Up"),
          Door.new(:right, "00-01-00")
          ],
        "00-00-09", "East Fork"
        ),
=begin
      Rm.new("East Fork", "Castle Entrance", [
          Door.new(:left, "00-00-07", "Paries"),
          Item.new("HP Max Up"),
          Door.new(:right, "00-01-00", "Paries")
          ],
        "00-00-09", width: 2
        ),
=end
      ],[
      Rm.new("East Fork Loading", "Castle Entrance", [
          Door.new(:left, "00-00-09", subroom: "Right"),
          Door.new(:right, "00-01-01"),
          ],
        "00-01-00", room_type: :loading
        ),
      Rm.new("East Fork Descent", "Castle Entrance", [
          Door.new(:left, "00-01-00"),
          Door.new(:down, "00-01-02", width: 2),
          Enemy.new("Peeping Eye", id: "05", type: ["Seeker", "Floor"]),
          Enemy.new("Black Panther", id: "06", type: "Challenger"),
          Enemy.new("Blood Skeleton", id: "07", type: ["Persistent", "Semi-Enclosed"]),
          ],
        "00-01-01", width: 2, height: 2
        ),
      Rm.new("Zombie Hall", "Castle Entrance", [
          Door.new(:left, "00-01-03"),
          Door.new(:up, "00-01-01", width: 2),
          Door.new(:right, "00-01-05"),
          Enemy.new("Mimic", id: "04", type: "Challenger"),
          Enemy.new("Ghoul", id: "05", type: ["Persistent", "Vanguard"]),
          Enemy.new("Ghoul", id: "06", type: ["Persistent", "Vanguard"]),
          Enemy.new("Black Panther", id: "07", type: "Vanguard"),
          Enemy.new("Black Panther", id: "08", type: "Vanguard"),
          Enemy.new("Peeping Eye", id: "09", type: ["Seeker", "Floor"]),
          ],
        "00-01-02", width: 4, traits: "Spacious"
        ),
      Rm.new("Zombie to Labyrinth", "Castle Entrance", [
          Door.new(:right, "00-01-02", "highJump", height: 3),
          Door.new(:right, "00-01-04"),
          Enemy.new("Peeping Eye", id: "01", type: ["Seeker", "Floor"]),
          Enemy.new("Peeping Eye", id: "02", type: ["Seeker", "Floor", "Semi-Enclosed", "Platform", "Separated"]),
          Enemy.new("Peeping Eye", id: "03", type: ["Seeker", "Floor", "Semi-Enclosed", "Platform"]),
          ],
        "00-01-03", height: 3
        ),
      Rm.new("Zombie to Labyrinth Loading", "Castle Entrance", [
          Door.new(:left, "00-01-03"),
          Door.new(:right, "00-02-00", subroom: "Top"),
          ],
        "00-01-04", room_type: :loading
        ),
      Rm.new("Valkyrie Greaves Pit", "Castle Entrance", [
          Door.new(:left, "00-01-02", height: 2),
          Item.new("Valkyrie Greaves"),
          Door.new(:right, "00-01-06", height: 2),
          Enemy.new("Blood Skeleton", id: "05", type: "Persistent"),
          Enemy.new("Black Panther", id: "06", type: ["Challenger", "Separated", "Semi-Enclosed"]),
          Enemy.new("Peeping Eye", id: "07", type: ["Seeker", "Floor", "Platform", "Separated"]),
          Enemy.new("Peeping Eye", id: "08", type: ["Seeker", "Floor", "Platform", "Separated"]),
          ],
        "00-01-05", width: 2, height: 2, room_req: "midDistance"
        ),
      Rm.new("East Gargoyles", "Castle Entrance", [
          Door.new(:left, "00-01-05"),
          Door.new(:right, "00-01-07"),
          Enemy.new("Gargoyle", id: "03", type: ["Seeker", "Floor", "Vanguard"]),
          ],
        "00-01-06", width: 2, traits: "Spacious"
        ),
      Rm.new("East Barrier", "Castle Entrance", [
          Door.new(:left, "00-01-06"),
          Door.new(:right, "00-05-02", false),
          Enemy.new("Ghoul", id: "02", type: ["Persistent", "Vanguard", "MustMove"]),
          ],
        "00-01-07", width: 2, traits: "Spacious"
        ),
    ],[
    #Underground Labyrinth
      Rm.new("Northwest Novas Top", "Underground Labyrinth", [
          Door.new(:left, "00-01-04", height: 4),
          Door.new(:down, "00-02-00", subroom: "Bottom"),
          Enemy.new("Polkir", id: "01", type: ["Nuisance", "Enclosed", "Separated", "Passthrough"]),
          Enemy.new("Nova Skeleton", id: "02", type: ["Range", "Enclosed", "Separated"]),
          Enemy.new("Nova Skeleton", id: "03", type: ["Range", "Enclosed", "Separated"]),
          ],
        "00-02-00", "Northwest Novas", height: 4, room_req: "beatNovas"
        ),
      Rm.new("Northwest Novas Bottom", "Underground Labyrinth", [
          Door.new(:left, "00-02-01"),
          Door.new(:up, "00-02-00", subroom: "Top"),
          Door.new(:down, "00-02-04")
          ],
        "00-02-00", "Northwest Novas"
        ),
=begin
      Rm.new("Northwest Novas", "Underground Labyrinth", [
          Door.new(:left, height: 5),
          Door.new(:left),
          Door.new(:down),
          Enemy.new("Polkir", id: "01", type: ["Nuisance", "Enclosed", "Separated", "Passthrough"]),
          Enemy.new("Nova Skeleton", id: "02", type: ["Range", "Enclosed", "Separated"]),
          Enemy.new("Nova Skeleton", id: "03", type: ["Range", "Enclosed", "Separated"]),
          ],
        "00-02-00", height: 5, room_req: "beatNovas"
        ),
=end
      Rm.new("First Fork North", "Underground Labyrinth", [
          Door.new(:down, "00-02-03", subroom: "Top"),
          Door.new(:right, "00-02-00", subroom: "Bottom"),
          Enemy.new("Gashida", id: "00", type: "Vanguard"),
          Enemy.new("Nova Skeleton", id: "01", type: "Range"),
          Enemy.new("Gashida", id: "02", type: "Vanguard"),
          ],
        "00-02-01", width: 4, room_req: "highJump"
        ),
      Rm.new("Vol Ignis Room", "Underground Labyrinth", [
          Item.new("Vol Ignis"),
          Door.new(:right, "00-02-03", subroom: "Top")
          ],
        "00-02-02", width: 4
        ),
      Rm.new("West Novas Top", "Underground Labyrinth", [
          Door.new(:left, "00-02-02"),
          Door.new(:up, "00-02-01"),
          Door.new(:down, "00-02-03", subroom: "Bottom"),
          Door.new(:right, "00-02-04", height: 2),
          Enemy.new("Polkir", id: "03", type: ["Nuisance", "Enclosed"]),
          ],
        "00-02-03", "West Novas", height: 2
        ),
      Rm.new("West Novas Bottom", "Underground Labyrinth", [
          Door.new(:up, "00-02-03", subroom: "Top", height: 3),
          Door.new(:right, "00-02-05"),
          Enemy.new("Nova Skeleton", id: "04", type: ["Range", "Enclosed", "Separated"]),
          Enemy.new("Nova Skeleton", id: "05", type: ["Range", "Enclosed", "Separated"]),
          Enemy.new("Nova Skeleton", id: "06", type: ["Range", "Enclosed", "Separated"]),
          ],
        "00-02-03", "West Novas", height: 3
        ),
=begin
      Rm.new("West Novas", "Underground Labyrinth", [
          Door.new(:left, height: 4),
          Door.new(:up),
          Door.new(:right, height: 5),
          Door.new(:right),
          Enemy.new("Polkir", id: "03", type: ["Nuisance", "Enclosed"]),
          Enemy.new("Nova Skeleton", id: "04", type: ["Range", "Enclosed", "Separated"]),
          Enemy.new("Nova Skeleton", id: "05", type: ["Range", "Enclosed", "Separated"]),
          Enemy.new("Nova Skeleton", id: "06", type: ["Range", "Enclosed", "Separated"]),
          ],
        "00-02-03", height: 5
        ),
=end
      Rm.new("First Fork South", "Underground Labyrinth", [
          Door.new(:left, "00-02-03", subroom: "Top"),
          Door.new(:up, "00-02-00", "highJump", subroom: "Bottom", width: 4),
          Enemy.new("Gurkha Master", id: "01", type: "Challenger"),
          Enemy.new("Gurkha Master", id: "02", type: "Challenger"),
          ],
        "00-02-04", width: 4
        ),
      Rm.new("Second Fork Entry", "Underground Labyrinth", [
          Door.new(:left, "00-02-03", subroom: "Bottom"),
          Door.new(:down, "00-02-08", width: 4),
          Door.new(:right, "00-02-07"),
          Enemy.new("Gurkha Master", id: "06", type: "Guard"),
          Enemy.new("Gurkha Master", id: "07", type: "Guard"),
          ],
        "00-02-05", width: 4, room_req: "highJump"
        ),
      Rm.new("Second Fork Attic", "Underground Labyrinth", [
          Door.new(:down, "00-02-07"),
          Item.new("Mercury Boots"),
          Enemy.new("Polkir", id: "01", type: "Nuisance"),
          Enemy.new("Polkir", id: "02", type: "Nuisance"),
          ],
        "00-02-06", width: 2
        ),
      Rm.new("Second Fork North", "Underground Labyrinth", [
          Door.new(:left, "00-02-05"),
          Door.new(:up, "00-02-06", width: 3),
          Door.new(:down, "00-02-09", subroom: "Top", width: 4),
          Enemy.new("Gurkha Master", id: "00", type: ["Guard", "Vanguard"]),
          Enemy.new("Gashida", id: "01", type: "Challenger"),
          Enemy.new("Gashida", id: "02", type: "Vanguard"),
          ],
        "00-02-07", width: 4, room_req: "highJump"
        ),
      Rm.new("Second Fork South", "Underground Labyrinth", [
          Item.new("MP Max Up"),
          Door.new(:up, "00-02-05", "highJump"),
          Door.new(:right, "00-02-09", subroom: "Top"),
          Enemy.new("Polkir", id: "04", type: "Nuisance"),
          Enemy.new("Gurkha Master", id: "05", type: "Guard"),
          Enemy.new("Gurkha Master", id: "06", type: ["Guard", "Vanguard"]),
          ],
        "00-02-08", width: 4
        ),
      Rm.new("Southwest Novas Top", "Underground Labyrinth", [
          Door.new(:left, "00-02-08"),
          Door.new(:up, "00-02-07"),
          Door.new(:down, "00-02-09", subroom: "Mid")
          ],
        "00-02-09", "Southwest Novas"
        ),
      Rm.new("Southwest Novas Mid", "Underground Labyrinth", [
          Door.new(:up, "00-02-09", subroom: "Top"),
          Door.new(:down, "00-02-09", subroom: "Bottom"),
          Enemy.new("Polkir", id: "00", type: ["Nuisance", "Enclosed", "Platform"]),
          Enemy.new("Nova Skeleton", id: "01", type: ["Range", "Enclosed", "Separated"]),
          Enemy.new("Nova Skeleton", id: "02", type: ["Range", "Enclosed", "Separated"]),
          ],
        "00-02-09", "Southwest Novas", room_req: "beatNovas"
        ),
      Rm.new("Southwest Novas Bottom", "Underground Labyrinth", [
          Door.new(:left, "00-02-0A", height: 3),
          Door.new(:left, "00-02-0B"),
          Door.new(:up, "00-02-09", subroom: "Mid"),
          Door.new(:right, "00-02-1C", height: 2),
          Enemy.new("Polkir", id: "03", type: ["Nuisance", "Enclosed", "Passthrough"]),
          ],
        "00-02-09", "Southwest Novas", height: 3
        ),
=begin
      Rm.new("Southwest Novas", "Underground Labyrinth", [
          Door.new(:left, height: 5),
          Door.new(:left, height: 3),
          Door.new(:left),
          Door.new(:up),
          Door.new(:right, height: 2),
          Enemy.new("Polkir", id: "00", type: ["Nuisance", "Enclosed", "Platform"]),
          Enemy.new("Nova Skeleton", id: "01", type: ["Range", "Enclosed", "Separated"]),
          Enemy.new("Nova Skeleton", id: "02", type: ["Range", "Enclosed", "Separated"]),
          Enemy.new("Polkir", id: "03", type: ["Nuisance", "Enclosed", "Passthrough"]),
          ],
        "00-02-09", height: 5
        ),
=end
      Rm.new("Blackmore Teleporter", "Underground Labyrinth", [
          Door.new(:right, "00-02-09", subroom: "Bottom")
          ],
        "00-02-0A", room_type: :teleporter
        ),
      Rm.new("Blackmore Save", "Underground Labyrinth", [
          Door.new(:right, "00-02-09", subroom: "Bottom")
          ],
        "00-02-0B", room_type: :save
        ),
      Rm.new("Blackmore Room", "Underground Labyrinth", [
          Door.new(:left, "00-02-1C"),
          Door.new(:right, "00-02-0D")
          ],
        "00-02-0C", width: 2, room_req: "beatBlackmore", is_important: true
        ),
      Rm.new("Blackmore Exit", "Underground Labyrinth", [
          Door.new(:left, "00-02-0C"),
          Door.new(:right, "00-02-13", subroom: "Bottom"),
          Enemy.new("Nova Skeleton", id: "00", type: ["Range", "Vanguard"]),
          Enemy.new("Nova Skeleton", id: "01", type: ["Range", "Vanguard"]),
          ],
        "00-02-0D", width: 2
        ),
      Rm.new("Squid Stairs", "Underground Labyrinth", [
          Door.new(:right, "00-05-06", height: 5),
          Door.new(:right, "00-02-0F"),
          Enemy.new("Polkir", id: "06", type: ["Nuisance", "Enclosed"]),
          Enemy.new("Polkir", id: "07", type: ["Nuisance", "Enclosed", "Separated"]),
          Enemy.new("Polkir", id: "08", type: ["Nuisance", "Enclosed", "Separated", "Passthrough"]),
          Enemy.new("Polkir", id: "09", type: ["Nuisance", "Enclosed", "Separated"]),
          Enemy.new("Polkir", id: "0A", type: ["Nuisance", "Enclosed", "Separated", "Passthrough"]),
          ],
        "00-02-0E", height: 5
        ),
      Rm.new("Block Puzzle Exit", "Underground Labyrinth", [
          Door.new(:left, "00-02-0E"),
          Door.new(:right, "00-02-1D"),
          Enemy.new("Hammer Shaker", id: "00", type: "Vanguard"),
          ],
        "00-02-0F", width: 2, room_req: "highJump"
        ),
      Rm.new("Block Puzzle Entrance", "Underground Labyrinth", [
          Door.new(:left, "00-02-1D"),
          Door.new(:down, "00-02-11", width: 2),
          Enemy.new("Hammer Shaker", id: "00", type: "Vanguard"),
          ],
        "00-02-10", width: 2, room_req: "highJump"
        ),
      Rm.new("Northeast Novas", "Underground Labyrinth", [
          Door.new(:left, "00-02-13", subroom: "Top", height: 2),
          Door.new(:up, "00-02-10"),
          Item.new("White Drops"),
          Enemy.new("Nova Skeleton", id: "00", type: ["Range", "Enclosed", "Separated"]),
          Enemy.new("Polkir", id: "01", type: ["Nuisance", "Enclosed", "Separated", "Passthrough"]),
          Enemy.new("Nova Skeleton", id: "02", type: ["Range", "Enclosed", "Separated"]),
          Enemy.new("Nova Skeleton", id: "03", type: ["Range", "Enclosed", "Separated"]),
          Enemy.new("Nova Skeleton", id: "04", type: ["Range", "Enclosed", "Separated"]),
          ],
        "00-02-11", height: 5, room_req: "beatNovas"
        ),
      Rm.new("Lapiste Entrance", "Underground Labyrinth", [
          Door.new(:left, "00-02-14"),
          Door.new(:right, "00-02-13", subroom: "Bottom"),
          Enemy.new("Gashida", id: "00", type: "Vanguard"),
          Enemy.new("Nova Skeleton", id: "01", type: ["Range", "Vanguard"]),
          ],
        "00-02-12", width: 2, room_req: "highJump"
        ),
      Rm.new("Lapiste Novas Top", "Underground Labyrinth", [
          Door.new(:down, "00-02-13", subroom: "Bottom"),
          Door.new(:right, "00-02-11", height: 2),
          Enemy.new("Nova Skeleton", id: "01", type: ["Range", "Enclosed", "Separated"]),
          Enemy.new("Nova Skeleton", id: "02", type: ["Range", "Enclosed", "Separated"]),
          ],
        "00-02-13", "Lapiste Novas", height: 2, room_req: "beatNovas"
        ),
      Rm.new("Lapiste Novas Bottom", "Underground Labyrinth", [
          Door.new(:left, "00-02-12", height: 3),
          Door.new(:left, "00-02-0D"),
          Door.new(:up, "00-02-13", subroom: "Top"),
          Door.new(:right, "00-02-15", height: 2),
          Enemy.new("Polkir", id: "00", type: ["Nuisance", "Enclosed", "Passthrough"]),
          ],
        "00-02-13", "Lapiste Novas", height: 3
        ),
=begin
      Rm.new("Lapiste Novas", "Underground Labyrinth", [
          Door.new(:left, height: 3),
          Door.new(:left),
          Door.new(:right, height: 5),
          Door.new(:right, height: 2),
          Enemy.new("Polkir", id: "00", type: ["Nuisance", "Enclosed", "Passthrough"]),
          Enemy.new("Nova Skeleton", id: "01", type: ["Range", "Enclosed", "Separated"]),
          Enemy.new("Nova Skeleton", id: "02", type: ["Range", "Enclosed", "Separated"]),
          ],
        "00-02-13", height: 5, room_req: "beatNovas"
        ),
=end
      Rm.new("Lapiste Room", "Underground Labyrinth", [
          Item.new("Lapiste", "lapistePuzzle"),
          Item.new("Star Ring"),
          Door.new(:right, "00-02-12")
          ],
        "00-02-14", height: 5
        ),
      Rm.new("Deadend Entrance Novas", "Underground Labyrinth", [
          Door.new(:left, "00-02-13", subroom: "Bottom"),
          Door.new(:right, "00-02-16"),
          Enemy.new("Nova Skeleton", id: "06", type: ["Range", "Vanguard"]),
          Enemy.new("Nova Skeleton", id: "07", type: "Range"),
          Enemy.new("Nova Skeleton", id: "08", type: ["Range", "Vanguard"]),
          Enemy.new("Polkir", id: "09", type: "Nuisance"),
          Enemy.new("Polkir", id: "0A", type: "Nuisance"),
          ],
        "00-02-15", width: 4
        ),
      Rm.new("Deadend Novas Top", "Underground Labyrinth", [
          Door.new(:down, "00-02-16", subroom: "Bottom"),
          Door.new(:right, "00-02-17", height: 3),
          Enemy.new("Nova Skeleton", id: "02", type: ["Range", "Enclosed", "Separated"]),
          Enemy.new("Nova Skeleton", id: "03", type: ["Range", "Enclosed", "Separated"]),
          Enemy.new("Nova Skeleton", id: "04", type: ["Range", "Enclosed", "Separated"]),
          ],
        "00-02-16", "Deadend Novas", height: 3, room_req: "beatNovas"
        ),
      Rm.new("Deadend Novas Bottom", "Underground Labyrinth", [
          Door.new(:left, "00-02-15", height: 2),
          Door.new(:up, "00-02-16", "beatNovas", subroom: "Top"),
          Door.new(:down, "00-02-19", "breakFloor", subroom: "Left"),
          Enemy.new("Flea Man", id: "00", type: ["Nuisance", "Floor", "Enclosed", "Separated"]),
          Enemy.new("Nova Skeleton", id: "01", type: ["Range", "Vanguard", "Enclosed"]),
          ],
        "00-02-16", "Deadend Novas", height: 2
        ),
=begin
      Rm.new("Deadend Novas", "Underground Labyrinth", [
          Door.new(:left, height: 2),
          Door.new(:down, "breakFloor"),
          Door.new(:right, height: 5),
          Enemy.new("Flea Man", id: "00", type: ["Nuisance", "Floor", "Enclosed", "Separated"]),
          Enemy.new("Nova Skeleton", id: "01", type: ["Range", "Vanguard", "Enclosed"]),
          Enemy.new("Nova Skeleton", id: "02", type: ["Range", "Enclosed", "Separated"]),
          Enemy.new("Nova Skeleton", id: "03", type: ["Range", "Enclosed", "Separated"]),
          Enemy.new("Nova Skeleton", id: "04", type: ["Range", "Enclosed", "Separated"]),
          ],
        "00-02-16", height: 5
        ),
=end
      Rm.new("Deadend Hearts", "Underground Labyrinth", [
          Door.new(:left, "00-02-16", subroom: "Top"),
          Item.new("HEART Max Up"),
          Enemy.new("Red Smasher", id: "04", type: "Challenger"),
          ],
        "00-02-17", width: 2, room_req: "highJump"
        ),
      Rm.new("Basement Potion Room", "Underground Labyrinth", [
          Item.new("Super Potion"),
          Door.new(:right, "00-02-19", subroom: "Left")
          ],
        "00-02-18"
        ),
      Rm.new("Basement Left", "Underground Labyrinth", [
          Door.new(:left, "00-02-18"),
          Door.new(:up, "00-02-16", subroom: "Bottom"),
          Door.new(:right, "00-02-19", subroom: "Right")
          ],
        "00-02-19", "Basement"
        ),
      Rm.new("Basement Right", "Underground Labyrinth", [
          Door.new(:left, "00-02-19", subroom: "Left"),
          Item.new("Felicem Fio"),
          Door.new(:up, "00-02-1A", width: 3)
          ],
        "00-02-19", "Basement", width: 3, room_req: "Paries"
        ),
=begin
      Rm.new("Basement", "Underground Labyrinth", [
          Door.new(:left),
          Door.new(:up),
          Item.new("Felicem Fio"),
          Door.new(:up, width: 4)
          ],
        "00-02-19", width: 4, room_req: "Paries"
        ),
=end
      Rm.new("Basement Novas", "Underground Labyrinth", [
          Door.new(:down, "00-02-19", subroom: "Right"),
          Door.new(:right, "00-02-1B"),
          Enemy.new("Nova Skeleton", id: "06", type: ["Range", "Vanguard"]),
          Enemy.new("Nova Skeleton", id: "07", type: ["Range", "Vanguard"]),
          Enemy.new("Gashida", id: "08", type: "Challenger"),
          ],
        "00-02-1A", width: 4
        ),
      Rm.new("Basement Exit", "Underground Labyrinth", [
          Door.new(:left, "00-02-1A"),
          Item.new("Rapidus Fio")
          ],
        "00-02-1B", is_important: true
        ),
      Rm.new("Blackmore Entrance", "Underground Labyrinth", [
          Door.new(:left, "00-02-09", subroom: "Bottom"),
          Door.new(:right, "00-02-0C"),
          Enemy.new("Polkir", id: "01", type: ["Nuisance", "Vanguard"]),
          ],
        "00-02-1C", width: 2
        ),
      Rm.new("Block Puzzle", "Underground Labyrinth", [
          Door.new(:left, "00-02-0F", height: 2),
          Door.new(:right, "00-02-10", height: 2)
          ],
        "00-02-1D", height: 2, room_req: "highJump"
        ),
      ],[
    #Library
      Rm.new("Entrance", "Library", [
          Door.new(:left, "00-03-01", "highJump", height: 3),
          Door.new(:left, "00-00-08"),
          Enemy.new("Peeping Eye", id: "03", type: ["Seeker", "Floor", "Platform", "Passthrough"]),
          Enemy.new("Peeping Eye", id: "04", type: ["Seeker", "Floor", "Platform", "Passthrough"]),
          ],
        "00-03-00", height: 3
        ),
      Rm.new("Entrance to West Bend", "Library", [
          Door.new(:left, "00-03-02", subroom: "Bottom"),
          Door.new(:right, "00-03-00"),
          Enemy.new("Ghoul", id: "01", type: ["Persistent", "Vanguard"]),
          Enemy.new("Black Panther", id: "02", type: "Vanguard"),
          ],
        "00-03-01", width: 2
        ),
      Rm.new("West Bend Top", "Library", [
          Item.new("HP Max Up", "smallDistance"),
          Door.new(:right, "00-03-03", height: 2),
          Door.new(:down, "00-03-02", subroom: "Bottom"),
          Enemy.new("Peeping Eye", id: "03", type: ["Seeker", "Floor", "Platform", "Passthrough"]),
          ],
        "00-03-02", "West Bend", height: 2
        ),
      Rm.new("West Bend Bottom", "Library", [
          Door.new(:up, "00-03-02", "highJump", subroom: "Top"),
          Door.new(:right, "00-03-01"),
          Enemy.new("Draculina", id: "02", type: ["Nuisance", "Floor", "Vanguard"]),
          ],
        "00-03-02", "West Bend"
        ),
=begin
      Rm.new("West Bend", "Library", [
          Item.new("HP Max Up", "highJump"),
          Door.new(:right, "highJump", height: 3),
          Door.new(:right)
          ],
        "00-03-02", height: 3
        ),
=end
      Rm.new("South Wallman Approach", "Library", [
          Door.new(:left, "00-03-02", subroom: "Top"),
          Door.new(:up, "00-03-04", width: 2),
          Enemy.new("Black Panther", id: "01", type: "Vanguard"),
          Enemy.new("Black Panther", id: "02", type: "Challenger"),
          ],
        "00-03-03", width: 2
        ),
      Rm.new("Central Wallman Approach", "Library", [
          Door.new(:up, "00-03-05", "highJump"),
          Door.new(:down, "00-03-03", width: 2),
          Enemy.new("Draculina", id: "01", type: ["Nuisance", "Floor", "Vanguard"]),
          ],
        "00-03-04", width: 2
        ),
      Rm.new("North Wallman Approach", "Library", [
          Door.new(:up, "00-03-07", "highJump", width: 2),
          Door.new(:down, "00-03-04"),
          Enemy.new("Tin Man", id: "01", type: "Vanguard"),
          ],
        "00-03-05", width: 2
        ),
      Rm.new("Wallman Teleporter", "Library", [
          Door.new(:right, "00-03-07")
          ],
        "00-03-06", room_type: :teleporter
        ),
      Rm.new("Wallman Lobby", "Library", [
          Door.new(:left, "00-03-06"),
          Item.new("MP Max Up", "smallDIstance"),
          Door.new(:down, "00-03-05", width: 2),
          Door.new(:right, "00-03-09", subroom: "Left", height: 2),
          Door.new(:right, "00-03-08"),
          Enemy.new("Draculina", id: "04", type: ["Nuisance", "Floor"]),
          Enemy.new("Black Panther", id: "05", type: "Vanguard"),
          Enemy.new("White Fomor", id: "06", type: ["Nuisance", "AirOnly", "Passthrough"]),
          ],
        "00-03-07", width: 2, height: 2
        ),
      Rm.new("Wallman Save", "Library", [
          Door.new(:left, "00-03-07")
          ],
        "00-03-08", room_type: :save
        ),
      Rm.new("Wallman Room Left", "Library", [
          Door.new(:left, "00-03-07"),
          Item.new("Paries"),
          Door.new(:right, "00-03-09", "Paries", subroom: "Right")
          ],
        "00-03-09", "Wallman Room"
        ),
      Rm.new("Wallman Room Right", "Library", [
          Door.new(:left, "00-03-09", "Paries", subroom: "Left"),
          Item.new("Melio Confodere"),
          Door.new(:right, "00-03-0A")
          ],
        "00-03-09", "Wallman Room"
        ),
=begin
       Rm.new("Wallman Room", "Library", [
          Door.new(:left, "Paries"),
          Item.new("Paries"),
          Item.new("Melio Confodere"),
          Door.new(:right, "Paries")
          ],
        "00-03-09", width: 2
        ),
=end
      Rm.new("Wallman Exit", "Library", [
          Door.new(:left, "00-03-09", subroom: "Right"),
          Door.new(:right, "00-03-0C"),
          Enemy.new("Draculina", id: "01", type: ["Nuisance", "Floor", "Vanguard"]),
          Enemy.new("Tin Man", id: "02", type: "Vanguard"),
          ],
        "00-03-0A", width: 2, room_req: "highJump"
        ),
      Rm.new("Volaticus Shortcut", "Library", [
          Door.new(:down, "00-03-0C", width: 2),
          Door.new(:right, "00-0A-00", height: 2),
          Enemy.new("Devil", id: "02", type: ["Range", "Wall"]),
          Enemy.new("Great Knight", id: "03", type: ["Guard", "Vanguard"]),
          ],
        "00-03-0B", width: 2, height: 2
        ),
      Rm.new("Shorcut Hub", "Library", [
          Door.new(:left, "00-03-0A", "highJump", height: 2),
          Door.new(:up, "00-03-0B", "hasFlight", width: 2),
          Door.new(:down, "00-03-0D"),
          Enemy.new("Black Panther", id: "01", type: "Vanguard"),
          Enemy.new("Blood Skeleton", id: "02", type: ["Persistent", "Air", "Vanguard"]),
          ],
        "00-03-0C", width: 2, height: 2
        ),
      Rm.new("Wallman Descent Entrance", "Library", [
          Door.new(:up, "00-03-0C"),
          Door.new(:right, "00-03-0E"),
          Enemy.new("Peeping Eye", id: "02", type: ["Seeker", "Floor", "Wall"]),
          Enemy.new("Black Panther", id: "03", type: "Vanguard"),
          ],
        "00-03-0D", width: 2
        ),
      Rm.new("Wallman Descent", "Library", [
          Door.new(:left, "00-03-0D", "highJump", height: 3),
          Door.new(:left, "00-04-00"),
          Door.new(:right, "00-03-0F"),
          Enemy.new("Peeping Eye", id: "00", type: ["Seeker", "Floor", "Platform", "Passthrough"]),
          Enemy.new("Draculina", id: "01", type: ["Nuisance", "Floor", "Platform", "Passthrough"]),
          Enemy.new("Draculina", id: "02", type: ["Nuisance", "Floor", "Platform"]),
          ],
        "00-03-0E", height: 3
        ),
      Rm.new("East Corridor Entrance", "Library", [
          Door.new(:left, "00-03-0E"),
          Door.new(:right, "00-03-10"),
          Enemy.new("Tin Man", id: "03", type: "Challenger"),
          Enemy.new("Draculina", id: "04", type: ["Nuisance", "Floor"]),
          Enemy.new("Draculina", id: "05", type: ["Nuisance", "Floor"]),
          Enemy.new("White Fomor", id: "06", type: ["Nuisance", "Vanguard", "Platform", "Passthrough"]),
          Enemy.new("White Fomor", id: "07", type: ["Nuisance", "Vanguard"]),
          ],
        "00-03-0F", width: 5, room_req: "highJump"
        ),
      Rm.new("East Corridor Descent", "Library", [
          Door.new(:left, "00-03-0F", "highJump", height: 3),
          Door.new(:left, "00-03-11"),
          Door.new(:right, "00-09-02"),
          Enemy.new("Draculina", id: "03", type: ["Nuisance", "Floor", "Platform", "Passthrough"]),
          Enemy.new("Peeping Eye", id: "04", type: ["Seeker", "Floor", "Platform", "Passthrough"]),
          Enemy.new("Draculina", id: "05", type: ["Nuisance", "Floor", "Platform"]),
          ],
        "00-03-10", height: 3
        ),
      Rm.new("Cloister Teleporter", "Library", [
          Door.new(:right, "00-03-10")
          ],
        "00-03-11", room_type: :teleporter
        ),
      ],[
      Rm.new("Kitchen Loading", "Library", [
          Door.new(:left, "00-04-01", subroom: "Top"),
          Door.new(:right, "00-03-0E")
          ],
        "00-04-00", room_type: :loading
        ),
      Rm.new("Kitchen Entrance Top", "Library", [
          Door.new(:left, "00-04-02"),
          Door.new(:right, "00-04-00"),
          Door.new(:down, "00-04-01", subroom: "Bottom"),
          Enemy.new("Draculina", id: "04", type: ["Nuisance", "Floor", "Wall"]),
          ],
        "00-04-01", width: 2, height: 2
        ),
      Rm.new("Kitchen Entrance Bottom", "Library", [
          Door.new(:up, "00-04-01", "highJump", subroom: "Top"),
          Door.new(:down, "00-04-03", width: 2),
          Enemy.new("Mad Butcher", id: "01", type: "Challenger"),
          Enemy.new("Mad Butcher", id: "02", type: "Vanguard"),
          Enemy.new("Mad Butcher", id: "03", type: "Ambush"),
          ],
        "00-04-01", width: 2, height: 2
        ),
=begin

      Rm.new("Kitchen Entrance", "Library", [
          Door.new(:left, height: 2),
          Door.new(:right, height: 2),
          Door.new(:down, width: 2)
          ],
        "00-04-01", width: 2, height: 2
        ),
=end
      Rm.new("Hidden Room", "Library", [
          Item.new("Hanged Man Ring"),
          Item.new("Refectio"),
          Door.new(:right, "00-04-01", subroom: "Top")
          ],
        "00-04-02", width: 2
        ),
      Rm.new("West Kitchen Robots", "Library", [
          Door.new(:up, "00-04-01", "highJump", subroom: "Bottom", width: 2),
          Door.new(:down, "00-04-04"),
          Enemy.new("Tin Man", id: "00", type: "Vanguard"),
          Enemy.new("Tin Man", id: "01", type: "Challenger"),
          ],
        "00-04-03", width: 2
        ),
      Rm.new("West Kitchen Bats", "Library", [
          Door.new(:up, "00-04-03", "highJump"),
          Door.new(:right, "00-04-05"),
          Enemy.new("Draculina", id: "00", type: ["Nuisance", "Floor"]),
          Enemy.new("Draculina", id: "01", type: ["Nuisance", "Floor"]),
          ],
        "00-04-04", width: 2
        ),
      Rm.new("Central Kitchen", "Library", [
          Door.new(:left, "00-04-04", "highJump", height: 2),
          Door.new(:right, "00-04-06"),
          Enemy.new("Mad Butcher", id: "00", type: ["Challenger", "WallR"]),
          Enemy.new("Mad Butcher", id: "01", type: "Challenger"),
          Enemy.new("Mad Butcher", id: "02", type: "Challenger"),
          ],
        "00-04-05", width: 2, height: 2
        ),
      Rm.new("East Kitchen Robots", "Library", [
          Door.new(:left, "00-04-05"),
          Door.new(:right, "00-04-07", subroom: "Top"),
          Enemy.new("Tin Man", id: "00", type: "Challenger"),
          Enemy.new("Tin Man", id: "01", type: "Challenger"),
          ],
        "00-04-06", width: 2, room_req: "highJump"
        ),
      Rm.new("Custos Descent Top", "Library", [
          Door.new(:left, "00-04-06", height: 2),
          Door.new(:down, "00-04-07", subroom: "Bottom"),
          Item.new("Cream Puff"),
          Enemy.new("Mad Butcher", id: "00", type: ["Challenger", "Platform"]),
          Enemy.new("Mad Butcher", id: "01", type: ["Challenger", "Platform"]),
          ],
        "00-04-07", "Custos Descent", height: 2
        ),
      Rm.new("Custos Descent Bottom", "Library", [
          Door.new(:up, "00-04-07", "highJump", subroom: "Top"),
          Door.new(:left, "00-04-08"),
          ],
        "00-04-07", "Custos Descent", height: 3
        ),
=begin
      Rm.new("Custos Descent", "Library", [
          Door.new(:left, "highJump", height: 3),
          Door.new(:left),
          Item.new("Cream Puff", "highJump")
          ],
        "00-04-07", height: 3
        ),
=end
      Rm.new("Custos Room", "Library", [
          Item.new("Dextro Custos"),
          Door.new(:right, "00-04-07", subroom: "Bottom")
          ],
        "00-04-08", width: 2
        ),
      ],[
    #Barracks
      Rm.new("Heart Room", "Barracks", [
          Item.new("HEART Max Up"),
          Door.new(:right, "00-05-01")
          ],
        "00-05-00"
        ),
      Rm.new("Northwest Big Stairs Top", "Barracks", [
          Door.new(:left, "00-05-00"),
          Door.new(:down, "00-05-01", subroom: "Bottom"),
          Door.new(:right, "00-05-07"),
          Enemy.new("Devil", id: "07", type: ["Guard", "Vanguard"]),
          ],
        "00-05-01", "Northwest Big Stairs", width: 2
        ),
      Rm.new("Northwest Big Stairs Bottom", "Barracks", [
          Door.new(:up, "00-05-01", "highJump", subroom: "Top"),
          Door.new(:down, "00-05-03"),
          Enemy.new("Nova Skeleton", id: "04", type: ["Range", "Semi-Enclosed"]),
          Enemy.new("Nova Skeleton", id: "05", type: ["Range", "Semi-Enclosed", "Separated", "WallR"]),
          Enemy.new("Nova Skeleton", id: "06", type: ["Range", "Semi-Enclosed", "Separated"]),
          ],
        "00-05-01", "Northwest Big Stairs", width: 2
        ),
=begin
      Rm.new("Northwest Big Stairs", "Barracks", [
          Door.new(:left, height: 2),
          Door.new(:down),
          Door.new(:right, height: 2)
          ],
        "00-05-01", width: 2, height: 2
        ),
=end
      Rm.new("Entrance to Barracks Loading", "Barracks", [
          Door.new(:left, "00-01-07"),
          Door.new(:right, "00-05-03", subroom: "Top")
          ],
        "00-05-02", room_type: :loading
        ),
      Rm.new("Southwest Big Stairs Top", "Barracks", [
          Door.new(:left, "00-05-02"),
          Door.new(:up, "00-05-01", "highJump", subroom: "Bottom"),
          Door.new(:down, "00-05-03", width: 2, subroom: "Bottom"),
          Enemy.new("Tin Man", id: "03", type: ["Challenger", "Enclosed", "Wall", "CollisionIssue"]),
          Enemy.new("Tin Man", id: "04", type: ["Challenger", "Semi-Enclosed", "WallR", "CollisionIssue"]),
          ],
        "00-05-03", "Southwest Big Stairs", width: 2
        ),
      Rm.new("Southwest Big Stairs Bottom", "Barracks", [
          Door.new(:left, "00-05-04", subroom: "Top"),
          Door.new(:up, "00-05-03", "smallDistance", subroom: "Top", width: 2),
          Door.new(:right, "00-05-08"),
          Enemy.new("Nova Skeleton", id: "02", type: ["Range", "Vanguard", "Enclosed"]),
          ],
        "00-05-03", "Southwest Big Stairs", width: 2, room_req: "beatNovas"
        ),
=begin
      Rm.new("Southwest Big Stairs", "Barracks", [
          Door.new(:left, height: 2),
          Door.new(:left),
          Door.new(:up, "highJump"),
          Door.new(:right)
          ],
        "00-05-03", width: 2, height: 2, room_req: "beatNovas"
        ),
=end
      Rm.new("Entrance Stairs Top", "Barracks", [
          Door.new(:down, "00-05-04", subroom: "Bottom"),
          Door.new(:right, "00-05-03", "highJump", subroom: "Bottom", height: 2),
          Door.new(:right, "00-05-05"),
          Enemy.new("Nova Skeleton", id: "04", type: ["Range", "Enclosed"]),
          Enemy.new("Nova Skeleton", id: "05", type: ["Range", "Vanguard"]),
          ],
        "00-05-04", "Entrance Stairs", height: 2, room_req: "beatNovas"
        ),
      Rm.new("Entrance Stairs Bottom", "Barracks", [
          Door.new(:left, "00-05-06"),
          Door.new(:up, "00-05-04", "highJump", subroom: "Top"),
          Item.new("Melio Hasta"),
          Enemy.new("Nova Skeleton", id: "03", type: ["Range", "Enclosed"]),
          ],
        "00-05-04", "Entrance Stairs"
        ),
=begin
      Rm.new("Entrance Stairs", "Barracks", [
          Door.new(:left),
          Item.new("Melio Hasta"),
          Door.new(:right, "highJump", height: 3),
          Door.new(:right, height: 2)
          ],
        "00-05-04", height: 3
        ),
=end
      Rm.new("Entrance Save", "Barracks", [
          Door.new(:left, "00-05-04", subroom: "Top")
          ],
        "00-05-05", room_type: :save
        ),
      Rm.new("Entrance Loading", "Barracks", [
          Door.new(:left, "00-02-0E"),
          Door.new(:right, "00-05-04", subroom: "Bottom")
          ],
        "00-05-06", room_type: :loading
        ),
      Rm.new("Ramparts", "Barracks", [
          Door.new(:left, "00-05-01", subroom: "Top"),
          Item.new("$2000", id: "01"),
          Item.new("$2000", id: "02"),
          Door.new(:right, "00-05-09", subroom: "Top"),
          Enemy.new("Blade Master", id: "03", type: "Vanguard"),
          Enemy.new("Red Smasher", id: "04", type: "Vanguard"),
          ],
        "00-05-07", width: 3, room_req: "highJump"
        ),
      Rm.new("Under Ramparts", "Barracks", [
          Door.new(:left, "00-05-03", subroom: "Bottom"),
          Item.new("Green Drops"),
          Item.new("$2000", "beatNovas"),
          Enemy.new("Blade Master", id: "04", type: ["Vanguard", "Semi-Enclosed"]),
          Enemy.new("Hammer Shaker", id: "05", type: ["Guard", "Semi-Enclosed"]),
          ],
        "00-05-08", width: 3, room_req: "highJump"
        ),
      Rm.new("North-Central Big Stairs Top", "Barracks", [
          Door.new(:left, "00-05-07"),
          Door.new(:down, "00-05-09", subroom: "Bottom"),
          Door.new(:right, "00-05-0F"),
          Enemy.new("Lizardman Blade", id: "03", type: ["Vanguard", "Semi-Enclosed", "WallR"]),
          Enemy.new("Nova Skeleton", id: "04", type: ["Range", "Semi-Enclosed", "Separated", "Wall"]),
          ],
        "00-05-09", "North-Central Big Stairs", width: 2
        ),
      Rm.new("North-Central Big Stairs Bottom", "Barracks", [
          Door.new(:up, "00-05-09", "highJump", subroom: "Top"),
          Door.new(:down, "00-05-0A"),
          Item.new("Green Drops"),
          Enemy.new("Nova Skeleton", id: "05", type: ["Range", "Semi-Enclosed"]),
          ],
        "00-05-09", "North-Central Big Stairs", width: 2
        ),
=begin
      Rm.new("North-Central Big Stairs", "Barracks", [
          Door.new(:left, height: 2),
          Door.new(:down),
          Item.new("Green Drops"),
          Door.new(:right, height: 2)
          ],
        "00-05-09", width: 2, height: 2
        ),
=end
      Rm.new("South-central Big Stairs", "Barracks", [
          Item.new("MP Max Up", "beatNovas"),
          Door.new(:up, "00-05-09", "highJump", subroom: "Bottom"),
          Door.new(:right, "00-05-0B"),
          Enemy.new("Lizardman Blade", id: "01", type: ["Challenger", "Semi-Enclosed", "WallR"]),
          Enemy.new("Lizardman Blade", id: "02", type: ["Challenger", "Enclosed", "Separated", "Wall"]),
          Enemy.new("Blade Master", id: "03", type: ["Challenger", "Enclosed"]),
          Enemy.new("Blade Master", id: "04", type: ["Challenger", "Enclosed", "Wall"]),
          ],
        "00-05-0A", width: 2, height: 2
        ),
      Rm.new("West Courtyard", "Barracks", [
          Door.new(:left, "00-05-0A", subroom: "Bottom"),
          Door.new(:right, "00-05-0C"),
          Enemy.new("Blade Master", id: "02", type: "Vanguard"),
          Enemy.new("Blade Master", id: "03", type: "Vanguard"),
          ],
        "00-05-0B", width: 3, room_req: "highJump"
        ),
      Rm.new("East Courtyard", "Barracks", [
          Door.new(:left, "00-05-0B"),
          Item.new("Red Drops", "highJump"),
          Door.new(:right, "00-05-12"),
          Enemy.new("Lizardman Blade", id: "02", type: "Vanguard"),
          ],
        "00-05-0C", width: 2
        ),
      Rm.new("Moon Ring Room", "Barracks", [
          Item.new("Moon Ring"),
          Door.new(:right, "00-05-11", subroom: "Top")
          ],
        "00-05-0D"
        ),
      Rm.new("Valkyrie Mail Room", "Barracks", [
          Door.new(:left, "00-05-10", subroom: "Bottom"),
          Item.new("Valkyrie Mail")
          ],
        "00-05-0E"
        ),
      Rm.new("Hidden HP Room", "Barracks", [
          Door.new(:left, "00-05-09", subroom: "Top"),
          Item.new("HP Max Up")
          ],
        "00-05-0F"
        ),
      Rm.new("Teleporter Stairs Top", "Barracks", [
          Door.new(:left, "00-05-12", "highJump", height: 2),
          Door.new(:left, "00-05-13"),
          Door.new(:down, "00-05-10", subroom: "Bottom"),
          Enemy.new("Bugbear", id: "03", type: ["Seeker", "Vanguard", "Floor", "Semi-Enclosed"]),
          Enemy.new("Imp", id: "05", type: ["Nuisance", "Vanguard", "Semi-Enclosed", "Hardmode"]),
          ],
        "00-05-10", "Teleporter Stairs", height: 2
        ),
      Rm.new("Teleporter Stairs Bottom", "Barracks", [
          Door.new(:up, "00-05-10", "highJump", subroom: "Top"),
          Door.new(:right, "00-05-0E"),
          Enemy.new("Bugbear", id: "02", type: ["Seeker", "Vanguard", "Floor", "Enclosed"]),
          Enemy.new("Imp", id: "06", type: ["Nuisance", "Ambush", "Semi-Enclosed", "Hardmode"]),
          ],
        "00-05-10", "Teleporter Stairs"
        ),
=begin
      Rm.new("Teleporter Stairs", "Barracks", [
          Door.new(:left, "highJump", height: 3),
          Door.new(:left, height: 2),
          Door.new(:right)
          ],
        "00-05-10", height: 3
        ),
=end
      Rm.new("Northeast Big Stairs Top", "Barracks", [
          Door.new(:left, "00-05-0D"),
          Door.new(:down, "00-05-11", subroom: "Bottom"),
          Door.new(:right, "00-07-00"),
          Enemy.new("Blade Master", id: "02", type: ["Challenger", "Separated", "Semi-Enclosed"]),
          Enemy.new("Lizardman Blade", id: "03", type: ["Vanguard", "Semi-Enclosed", "WallR"]),
          Enemy.new("Imp", id: "04", type: ["Nuisance", "Semi-Enclosed"]),
          ],
        "00-05-11", "Northeast Big Stairs", width: 2
        ),
      Rm.new("Northeast Big Stairs Bottom", "Barracks", [
          Door.new(:up, "00-05-11", "highJump", subroom: "Top"),
          Door.new(:down, "00-05-12"),
          Enemy.new("Gurkha Master", id: "01", type: ["Range", "Vanguard", "Semi-Enclosed"]),
          Enemy.new("Imp", id: "05", type: ["Nuisance", "Offscreen", "Semi-Enclosed"]),
          ],
        "00-05-11", "Northeast Big Stairs", width: 2
        ),
=begin
      Rm.new("Northeast Big Stairs", "Barracks", [
          Door.new(:left, height: 2),
          Door.new(:down),
          Door.new(:right, height: 2)
          ],
        "00-05-11", width: 2, height: 2
        ),
=end
      Rm.new("Southeast Big Stairs", "Barracks", [
          Door.new(:left, "00-05-0C"),
          Door.new(:up, "00-05-11", "highJump", subroom: "Bottom"),
          Door.new(:right, "00-05-10", subroom: "Top"),
          Enemy.new("Gurkha Master", id: "02", type: ["Guard", "Vanguard", "Enclosed"]),
          Enemy.new("Blade Master", id: "03", type: ["Challenger", "Vanguard", "Enclosed", "Wall"]),
          Enemy.new("Blade Master", id: "04", type: ["Challenger", "Semi-Enclosed", "WallR"]),
          ],
        "00-05-12", width: 2, height: 2, room_req: "beatNovas"
        ),
      Rm.new("Teleporter", "Barracks", [
          Door.new(:right, "00-05-10", subroom: "Top")
          ],
        "00-05-13", room_type: :teleporter
        ),
      ],[
    #Mechanical Tower
      Rm.new("Arms Depot Loading", "Mechanical Tower", [
          Door.new(:left, "00-08-02"),
          Door.new(:right, "00-06-01")
          ],
        "00-06-00", room_type: :loading
        ),
      Rm.new("Arms Depot Exit", "Mechanical Tower", [
          Door.new(:left, "00-06-00"),
          Door.new(:right, "00-06-02"),
          Enemy.new("Bugbear", id: "02", type: ["Seeker", "Floor", "Vanguard"]),
          Enemy.new("Bugbear", id: "03", type: ["Seeker", "Floor", "Vanguard"]),
          Enemy.new("Imp", id: "04", type: ["Nuisance", "Vanguard"]),
          ],
        "00-06-01", width: 2
        ),
      Rm.new("South Depot Balcony", "Mechanical Tower", [
          Door.new(:left, "00-06-03", "highJump", height: 2),
          Door.new(:left, "00-06-01"),
          Enemy.new("Lizardman Blade", id: "02", type: ["Vanguard", "Semi-Enclosed"]),
          Enemy.new("Hammer Shaker", id: "03", type: ["Guard", "Vanguard", "Semi-Enclosed"]),
          Enemy.new("Bugbear", id: "04", type: ["Seeker", "Floor", "Vanguard", "Semi-Enclosed"]),
          ],
        "00-06-02", width: 2, height: 2, room_req: "beatArmor"
        ),
      Rm.new("Lizard Maze", "Mechanical Tower", [
          Door.new(:right, "00-06-1A", "mechTower", height: 2),
          Door.new(:right, "00-06-02", "armsDepot"),
          Enemy.new("Lizardman Blade", id: "06", type: ["Challenger", "Enclosed", "Wall"]),
          Enemy.new("Lizardman Blade", id: "07", type: ["Vanguard", "Enclosed"]),
          Enemy.new("Lizardman Blade", id: "08", type: ["Challenger", "Semi-Enclosed"]),
          Enemy.new("Imp", id: "09", type: ["Nuisance", "Separated", "Semi-Enclosed"]),
          ],
        "00-06-03", width: 3, height: 2, room_req: "beatLizards"
        ),
      Rm.new("South Epsilon Chamber", "Mechanical Tower", [
          Door.new(:right, "00-06-19", "mechTower", height: 3),
          Door.new(:right, "00-06-05")
          ],
        "00-06-04", height: 3
        ),
      Rm.new("Speedbumps to Arms Depot", "Mechanical Tower", [
          Door.new(:left, "00-06-04"),
          Door.new(:right, "00-06-1A"),
          Enemy.new("Lizardman Blade", id: "00", type: ["Vanguard", "Semi-Enclosed"]),
          Enemy.new("Imp", id: "01", type: ["Nuisance", "Semi-Enclosed"]),
          Enemy.new("Bugbear", id: "02", type: ["Seeker", "Floor", "Vanguard", "Semi-Enclosed", "WallR"]),
          ],
        "00-06-05", width: 3
        ),
      Rm.new("Mid Tower Loading", "Mechanical Tower", [
          Door.new(:left, "00-07-04"),
          Door.new(:right, "00-06-07")
          ],
        "00-06-06", room_type: :loading
        ),
      Rm.new("Mid-tower Speedbumps", "Mechanical Tower", [
          Door.new(:left, "00-06-06"),
          Door.new(:right, "00-06-08"),
          Enemy.new("Automaton ZX27", id: "00", type: ["Guard", "Vanguard"]),
          Enemy.new("Imp", id: "01", type: ["Nuisance", "Vanguard"]),
          Enemy.new("Imp", id: "02", type: ["Nuisance", "Vanguard"]),
          ],
        "00-06-07", width: 2
        ),
      Rm.new("Mid-tower Balcony", "Mechanical Tower", [
          Door.new(:left, "00-06-09", "highJump", height: 2),
          Door.new(:left, "00-06-07"),
          Enemy.new("Medusa Head", id: "03", type: ["Persistent", "Vanguard", "Air", "Semi-Enclosed"]),
          Enemy.new("Medusa Head", id: "04", type: ["Persistent", "Vanguard", "Air", "Semi-Enclosed"]),
          Enemy.new("Gorgon Head", id: "05", type: ["Persistent", "Vanguard", "Air", "Semi-Enclosed"]),
          Enemy.new("Lizardman Blade", id: "06", type: ["Vanguard", "Semi-Enclosed"]),
          Enemy.new("Lizardman Blade", id: "07", type: ["Vanguard", "Semi-Enclosed"]),
          Enemy.new("Bugbear", id: "08", type: ["Seeker", "Floor", "Vanguard", "Semi-Enclosed"]),
          ],
        "00-06-08", width: 2, height: 2
        ),
      Rm.new("Magnet Maze", "Mechanical Tower", [
          Door.new(:left, "00-06-0A", subroom: "Top", height: 2),
          Item.new("Valkyrie Mask"),
          Door.new(:right, "00-06-08"),
          Enemy.new("Medusa Head", id: "0E", type: ["Persistent", "Air", "Platform", "Spikes"]),
          Enemy.new("Medusa Head", id: "10", type: ["Persistent", "Air", "Platform", "Spikes", "Hardmode"]),
          ],
        "00-06-09", width: 3, height: 2, room_req: "mechTower"
        ),
      Rm.new("S Fork Top", "Mechanical Tower", [
          Door.new(:down, "00-06-0A", subroom: "Bottom"),
          Door.new(:right, "00-06-0E", "mechTower", subroom: "Bottom", height: 2),
          Door.new(:right, "00-06-09"),
          Enemy.new("Medusa Head", id: "03", type: ["Persistent", "Vanguard", "Air"]),
          Enemy.new("Medusa Head", id: "04", type: ["Persistent", "Vanguard", "Air"]),
          Enemy.new("Gorgon Head", id: "05", type: ["Persistent", "Vanguard", "Air"]),
          ],
        "00-06-0A", "S Fork", height: 2
        ),
      Rm.new("S Fork Bottom", "Mechanical Tower", [
          Door.new(:left, "00-06-0B"),
          Door.new(:up, "00-06-0A", "mechTower", subroom: "Top")
          ],
        "00-06-0A", "S Fork"
        ),
=begin
      Rm.new("S Fork", "Mechanical Tower", [
          Door.new(:left),
          Door.new(:right, "mechTower", height: 3),
          Door.new(:right, height: 2)
          ],
        "00-06-0A", height: 3
        ),
=end
      Rm.new("Speedbumps to Cloister", "Mechanical Tower", [
          Door.new(:left, "00-09-08"),
          Door.new(:right, "00-06-0A", subroom: "Bottom"),
          Enemy.new("Automaton ZX27", id: "03", type: ["Guard", "Vanguard", "Wall"]),
          Enemy.new("Automaton ZX27", id: "04", type: ["Guard", "Vanguard"]),
          Enemy.new("Imp", id: "05", type: "Nuisance"),
          ],
        "00-06-0B", width: 3
        ),
      Rm.new("Death Ring Eyes", "Mechanical Tower", [
          Door.new(:left, "00-06-1B"),
          Door.new(:right, "00-06-0D"),
          Enemy.new("Bugbear", id: "02", type: ["Seeker", "Floor", "Vanguard"]),
          Enemy.new("Bugbear", id: "03", type: ["Seeker", "Floor", "Vanguard"]),
          Enemy.new("Bugbear", id: "04", type: ["Seeker", "Floor", "Vanguard"]),
          ],
        "00-06-0C", width: 2
        ),
      Rm.new("Death Ring Balcony", "Mechanical Tower", [
          Door.new(:left, "00-06-0C", "highJump", height: 2),
          Door.new(:left, "00-06-0E", subroom: "Top"),
          Enemy.new("Medusa Head", id: "02", type: ["Persistent", "Vanguard", "Air", "Semi-Enclosed"]),
          Enemy.new("Medusa Head", id: "03", type: ["Persistent", "Vanguard", "Air", "Semi-Enclosed"]),
          Enemy.new("Gorgon Head", id: "04", type: ["Persistent", "Vanguard", "Air", "Semi-Enclosed"]),
          ],
        "00-06-0D", width: 2, height: 2
        ),
      Rm.new("Death Ring Fork Top", "Mechanical Tower", [
          Door.new(:left, "00-06-0F"),
          Door.new(:down, "00-06-0E", subroom: "Bottom"),
          Door.new(:right, "00-06-0D"),
          Enemy.new("Medusa Head", id: "0B", type: ["Persistent", "Air", "Vanguard", "Enclosed", "Wall"]),
          Enemy.new("Medusa Head", id: "0D", type: ["Persistent", "Air", "Vanguard", "Enclosed", "Wall", "Hardmode"]),
          ],
        "00-06-0E", "Death Ring Fork", width: 3
        ),
      Rm.new("Death Ring Fork Bottom", "Mechanical Tower", [
          Door.new(:left, "00-06-0A", subroom: "Top"),
          Item.new("Heart Cuirass"),
          Door.new(:up, "00-06-0E", subroom: "Top"),
          Item.new("HP Max Up")
          ],
        "00-06-0E", "Death Ring Fork", width: 3, room_req: "mechTower"
        ),
=begin
      Rm.new("Death Ring Fork", "Mechanical Tower", [
          Door.new(:left, height: 2),
          Door.new(:left),
          Item.new("Heart Cuirass"),
          Item.new("HP Max Up"),
          Door.new(:right, height: 2)
          ],
        "00-06-0E", width: 3, height: 2, room_req: "mechTower"
        ),
=end
      Rm.new("North Epsilon Chamber", "Mechanical Tower", [
          Door.new(:right, "00-06-10", "mechTower", height: 3),
          Door.new(:right, "00-06-0E", subroom: "Top"),
          Enemy.new("Medusa Head", id: "07", type: ["Persistent", "Air", "AirOnly", "Platform", "Separated"]),
          Enemy.new("Gorgon Head", id: "08", type: ["Persistent", "Air", "AirOnly", "Platform", "Separated"]),
          Enemy.new("Medusa Head", id: "0A", type: ["Persistent", "Air", "AirOnly", "Platform", "Separated", "Hardmode"]),
          ],
        "00-06-0F", height: 3
        ),
      Rm.new("Frank Room", "Mechanical Tower", [
          Door.new(:left, "00-06-0F"),
          Door.new(:right, "00-06-11"),
          Enemy.new("Rebuild", id: "01", type: ["Guard", "Vanguard"]),
          ],
        "00-06-10", width: 2
        ),
      Rm.new("Death Entrance Top", "Mechanical Tower", [
          Door.new(:left, "00-06-14"),
          Door.new(:down, "00-06-11", subroom: "Bottom"),
          Door.new(:right, "00-06-13")
          ],
        "00-06-11", "Death Entrance"
        ),
      Rm.new("Death Entrance Bottom", "Mechanical Tower", [
          Door.new(:left, "00-06-10"),
          Door.new(:up, "00-06-11", "mechTower", subroom: "Top"),
          Door.new(:right, "00-06-12")
          ],
        "00-06-11", "Death Entrance", height: 2
        ),
      Rm.new("Death Teleporter", "Mechanical Tower", [
          Door.new(:left, "00-06-11", subroom: "Bottom")
          ],
        "00-06-12", room_type: :teleporter
        ),
      Rm.new("Death Save", "Mechanical Tower", [
          Door.new(:left, "00-06-11", subroom: "Top")
          ],
        "00-06-13", room_type: :save
        ),
      Rm.new("Death Boss Room", "Mechanical Tower", [
          Door.new(:left, "00-06-15"),
          Door.new(:right, "00-06-11", subroom: "Top")
          ],
        "00-06-14", width: 2, room_req: "beatDeath", is_important: true
        ),
      Rm.new("Custos Room", "Mechanical Tower", [
          Item.new("Sinestro Custos"),
          Door.new(:right, "00-06-14")
          ],
        "00-06-15"
        ),
      Rm.new("South Tower Loading", "Mechanical Tower", [
          Door.new(:left, "00-06-19"),
          Door.new(:right, "00-07-03")
          ],
        "00-06-16", room_type: :loading
        ),
      Rm.new("Morbus Robots", "Mechanical Tower", [
          Door.new(:left, "00-06-1C"),
          Door.new(:right, "00-06-18"),
          Enemy.new("Automaton ZX27", id: "01", type: ["Guard", "Vanguard"]),
          Enemy.new("Automaton ZX27", id: "02", type: ["Guard", "Vanguard"]),
          ],
        "00-06-17", width: 2
        ),
      Rm.new("Morbus Balcony", "Mechanical Tower", [
          Door.new(:left, "00-06-19", "highJump", height: 2),
          Door.new(:left, "00-06-17"),
          Enemy.new("Automaton ZX27", id: "02", type: ["Guard", "Vanguard", "Semi-Enclosed"]),
          Enemy.new("Red Smasher", id: "03", type: ["Vanguard", "Semi-Enclosed"]),
          ],
        "00-06-18", width: 2, height: 2, room_req: "beatArmor"
        ),
      Rm.new("Morbus Fork", "Mechanical Tower", [
          Door.new(:left, "00-06-04"),
          Door.new(:right, "00-06-16", height: 2),
          Door.new(:right, "00-06-18")
          ],
        "00-06-19", width: 3, height: 2, room_req: "mechTower"
        ),
      Rm.new("North Depot Balcony", "Mechanical Tower", [
          Door.new(:left, "00-06-05", height: 2),
          Door.new(:left, "00-06-03"),
          Enemy.new("Gurkha Master", id: "02", type: ["Guard", "Vanguard", "Semi-Enclosed"]),
          Enemy.new("Red Smasher", id: "03", type: ["Vanguard", "Semi-Enclosed"]),
          ],
        "00-06-1A", width: 2, height: 2, room_req: "beatArmor"
        ),
      Rm.new("Death Ring Room", "Mechanical Tower", [
          Item.new("Death Ring"),
          Door.new(:right, "00-06-0C")
          ],
        "00-06-1B"
        ),
      Rm.new("Morbus Room", "Mechanical Tower", [
          Item.new("Morbus"),
          Door.new(:right, "00-06-17")
          ],
        "00-06-1C"
        ),
      ],[
      Rm.new("Barracks to Tower Loading", "Mechanical Tower", [
          Door.new(:left, "00-05-11"),
          Door.new(:right, "00-07-01")
          ],
        "00-07-00", room_type: :loading
        ),
      Rm.new("Tower Entrance", "Mechanical Tower", [
          Door.new(:left, "00-07-00"),
          Door.new(:right, "00-07-02", subroom: "Bottom"),
          Enemy.new("Gurkha Master", id: "02", type: ["Guard", "Vanguard", "Semi-Enclosed"]),
          Enemy.new("Hammer Shaker", id: "03", type: ["Guard", "Vanguard", "Semi-Enclosed"]),
          Enemy.new("Imp", id: "04", type: ["Nuisance", "Vanguard", "Semi-Enclosed"]),
          Enemy.new("Imp", id: "05", type: ["Nuisance", "Semi-Enclosed"]),
          Enemy.new("Imp", id: "06", type: ["Nuisance", "Vanguard", "Semi-Enclosed"]),
          ],
        "00-07-01", width: 3, room_req: "beatArmor"
        ),
      Rm.new("Lizard Hub Top Left", "Mechanical Tower", [
          Door.new(:left, "00-07-04"),
          Door.new(:down, "00-07-02", subroom: "Bottom"),
          Door.new(:right, "00-07-02", "highJump", subroom: "Top Right", height: 2),
          Enemy.new("Imp", id: "06", type: ["Nuisance", "Platform", "Ambush"]),
          ],
        "00-07-02", "Lizard Hub", height: 2
        ),
      Rm.new("Lizard Hub Top Right", "Mechanical Tower", [
          Door.new(:left, "00-07-02", subroom: "Top Left"),
          Door.new(:down, "00-07-02", subroom: "Mid Right", width: 2),
          Door.new(:right, "00-07-05", "highJump"),
          Enemy.new("Imp", id: "05", type: "Nuisance"),
          ],
        "00-07-02", "Lizard Hub", width: 2
        ),
      Rm.new("Lizard Hub Mid Right", "Mechanical Tower", [
          Door.new(:up, "00-07-02", "highJump", subroom: "Top Right", width: 2),
          Door.new(:down, "00-07-02", "beatLizards", subroom: "Bottom", width: 2),
          Item.new("Vis Fio"),
          Door.new(:right, "00-07-03"),
          Enemy.new("Lizardman Blade", id: "03", type: ["Guard", "Enclosed"]),
          Enemy.new("Imp", id: "04", type: ["Nuisance", "Enclosed"]),
          ],
        "00-07-02", "Lizard Hub", width: 2
        ),
      Rm.new("Lizard Hub Bottom", "Mechanical Tower", [
          Door.new(:left, "00-07-01"),
          Door.new(:up, "00-07-02", "canFly", subroom: "Top Left"),
          Door.new(:up, "00-07-02", "highJumpbeatLizards", subroom: "Mid Right", width: 3),
          Enemy.new("Lizardman Blade", id: "01", type: ["Guard", "Vanguard", "Enclosed"]),
          Enemy.new("Lizardman Blade", id: "02", type: ["Guard", "Enclosed"]),
          ],
        "00-07-02", "Lizard Hub", width: 3
        ),
      Rm.new("Lizard Hub Southeast Fork", "Mechanical Tower", [
          Door.new(:left, "00-07-02", "mechTower", subroom: "Mid Right", height: 3),
          Door.new(:left, "00-06-16")
          ],
        "00-07-03", height: 3
        ),
      Rm.new("Lizard Hub Northwest Fork", "Mechanical Tower", [
          Door.new(:right, "00-06-06", "mechTower", height: 3),
          Door.new(:right, "00-07-02", subroom: "Top Left")
          ],
        "00-07-04", height: 3
        ),
      Rm.new("Lizard Hub Save", "Mechanical Tower", [
          Door.new(:left, "00-07-02", subroom: "Top Right")
          ],
        "00-07-05", room_type: :save
        ),
      ],[
    #Arms Depot
      Rm.new("HP Max Up Room", "Arms Depot", [
          Item.new("HP Max Up"),
          Door.new(:right, "00-08-01"),
          Enemy.new("Hammer Shaker", id: "03", type: ["Guard", "Vanguard"]),
          ],
        "00-08-00", room_req: "beatArmor"
        ),
      Rm.new("Corridor to HP Room", "Arms Depot", [
          Door.new(:left, "00-08-00"),
          Door.new(:right, "00-08-02"),
          Enemy.new("Gurkha Master", id: "02", type: ["Guard", "Vanguard"]),
          Enemy.new("Hammer Shaker", id: "03", type: ["Guard", "Vanguard"]),
          ],
        "00-08-01", width: 2, room_req: "beatArmor"
        ),
      Rm.new("Entrance Stairs", "Arms Depot", [
          Door.new(:left, "00-08-01", "smallDistance", height: 3),
          Door.new(:left, "00-08-07"),
          Door.new(:right, "00-06-00", height: 3),
          Door.new(:right, "00-08-08"),
          Enemy.new("Bugbear", id: "02", type: ["Seeker", "Floor", "Vanguard"]),
          Enemy.new("Bugbear", id: "03", type: ["Seeker", "Floor", "Ambush"]),
          ],
        "00-08-02", height: 3
        ),
      Rm.new("Teleporter Room", "Arms Depot", [
          Door.new(:right, "00-08-04")
          ],
        "00-08-03", room_type: :teleporter
        ),
      Rm.new("West Stairs", "Arms Depot", [
          Door.new(:left, "00-08-03"),
          Door.new(:right, "00-08-05", height: 3),
          Door.new(:right, "00-08-0A"),
          Enemy.new("Mad Snatcher", id: "00", type: ["Challenger", "Platform"]),
          Enemy.new("Mad Snatcher", id: "01", type: ["Ambush", "Platform"]),
          ],
        "00-08-04", height: 3
        ),
      Rm.new("Northwest Corridor", "Arms Depot", [
          Door.new(:left, "00-08-04"),
          Item.new("Melio Falcis"),
          Door.new(:right, "00-08-06"),
          Enemy.new("Great Knight", id: "01", type: ["Guard", "Vanguard"]),
          Enemy.new("King Skeleton", id: "02", type: ["Guard", "Vanguard"]),
          ],
        "00-08-05", width: 3, room_req: "beatArmor"
        ),
      Rm.new("North-Central Corridor", "Arms Depot", [
          Door.new(:left, "00-08-05"),
          Door.new(:right, "00-08-07"),
          Enemy.new("Rebuild", id: "00", type: "Guard"),
          ],
        "00-08-06", width: 3, room_req: "highJump"
        ),
      Rm.new("Northeast Corridor", "Arms Depot", [
          Door.new(:left, "00-08-06"),
          Item.new("Melio Culter"),
          Door.new(:right, "00-08-02"),
          Enemy.new("Red Smasher", id: "01", type: "Vanguard"),
          Enemy.new("Hammer Shaker", id: "02", type: "Guard"),
          Enemy.new("Gurkha Master", id: "03", type: ["Guard", "Vanguard"]),
          ],
        "00-08-07", width: 3, room_req: "beatArmor"
        ),
      Rm.new("Northeast Sword Corridor", "Arms Depot", [
          Door.new(:left, "00-08-02"),
          Item.new("Melio Scutum"),
          Door.new(:right, "00-08-09"),
          Enemy.new("Spectral Sword", id: "01", type: ["Threat", "Air"]),
          ],
        "00-08-08", width: 2
        ),
      Rm.new("Wooden Chest Room", "Arms Depot", [
          Door.new(:left, "00-08-08"),
          Enemy.new("Mad Snatcher", id: "03", type: "Vanguard"),
          ],
        "00-08-09"
        ),
      Rm.new("Southwest Corridor", "Arms Depot", [
          Door.new(:left, "00-08-04"),
          Door.new(:right, "00-08-0B"),
          Enemy.new("Great Knight", id: "03", type: ["Guard", "Vanguard"]),
          Enemy.new("King Skeleton", id: "04", type: ["Guard", "Vanguard"]),
          ],
        "00-08-0A", width: 3, room_req: "beatArmor"
        ),
      Rm.new("South Sword Corridor", "Arms Depot", [
          Door.new(:left, "00-08-0A"),
          Door.new(:right, "00-08-0C"),
          Enemy.new("Spectral Sword", id: "03", type: ["Threat", "Air", "Vanguard"]),
          Enemy.new("Spectral Sword", id: "04", type: ["Threat", "Air", "Vanguard"]),
          ],
        "00-08-0B", width: 3, room_req: "beatArmor"
        ),
      Rm.new("Eligor Stairs", "Arms Depot", [
          Door.new(:left, "00-08-0B", "smallDistance", height: 3),
          Door.new(:left, "00-08-0D"),
          Item.new("Mint Sundae"),
          Door.new(:right, "00-08-0E"),
          Enemy.new("Mad Snatcher", id: "03", type: "Challenger"),
          Enemy.new("Mad Snatcher", id: "04", type: ["Ambush", "Platform"]),
          ],
        "00-08-0C", height: 3
        ),
      Rm.new("Eligor Save", "Arms Depot", [
          Door.new(:right, "00-08-0C")
          ],
        "00-08-0D", room_type: :save
        ),
      Rm.new("Eligor Room", "Arms Depot", [
          Door.new(:left, "00-08-0C"),
          Door.new(:right, "00-08-0F", height: 2)
          ],
        "00-08-0E", width: 3, height: 2, room_req: "beatEligor", is_important: true
        ),
      Rm.new("Custos Room", "Arms Depot", [
          Door.new(:left, "00-08-0E")
          ],
        "00-08-0F"
        ),
      ],[
    #Forsaken Cloister
      Rm.new("Custos Save", "Forsaken Cloister", [
          Door.new(:right, "00-09-01", subroom: "Top")
          ],
        "00-09-00", room_type: :save
        ),
      Rm.new("Custos Stairs Top", "Forsaken Cloister", [
          Door.new(:left, "00-09-00"),
          Door.new(:down, "00-09-01", subroom: "Bottom"),
          Door.new(:right, "00-0A-13"),
          Item.new("Eisbein", lock: "highJump", escape: "Bottom"),
          Enemy.new("Medusa Head", id: "04", type: ["Persistent", "Air", "Platform", "MustMove"]),
          Enemy.new("Gorgon Head", id: "05", type: ["Persistent", "Air"]),
          Enemy.new("Winged Guard", id: "06", type: ["Persistent", "Air", "Offscreen"]),
          ],
        "00-09-01", "Custos Stairs", height: 5
        ),
      Rm.new("Custos Stairs Bottom", "Forsaken Cloister", [
          Door.new(:up, "00-09-01", "highJump", subroom: "Top"),
          Door.new(:down, "00-09-05")
          ],
        "00-09-01", "Custos Stairs"
        ),
=begin
      Rm.new("Custos Stairs", "Forsaken Cloister", [
          Door.new(:left, height: 6),
          Item.new("Eisbein"),
          Door.new(:down),
          Door.new(:right, height: 6),
        ],
        "00-09-01", height: 6, is_important: true
      ),
=end
      Rm.new("Library to Cloister Loading", "Forsaken Cloister", [
          Door.new(:left, "00-03-10"),
          Door.new(:right, "00-09-03"),
          ],
        "00-09-02", room_type: :loading
        ),
      Rm.new("West Entrance", "Forsaken Cloister", [
          Door.new(:left, "00-09-02"),
          Door.new(:right, "00-09-04"),
          Enemy.new("Cave Troll", id: "02", type: ["Threat", "Vanguard"]),
          ],
        "00-09-03", width: 2, room_req: "beatLizards"
        ),
      Rm.new("West Corridor", "Forsaken Cloister", [
          Door.new(:left, "00-09-03"),
          Door.new(:right, "00-09-05"),
          Enemy.new("Bugbear", id: "00", type: ["Seeker", "Floor"]),
          Enemy.new("Cave Troll", id: "01", type: ["Threat", "Vanguard"]),
          Enemy.new("Cave Troll", id: "02", type: "Threat"),
          Enemy.new("Nova Skeleton", id: "03", type: "Range"),
          Enemy.new("Nova Skeleton", id: "04", type: ["Range", "Vanguard"]),
          ],
        "00-09-04", width: 4, room_req: "beatLizards"
        ),
      Rm.new("Cerberus Room", "Forsaken Cloister", [
          Door.new(:left, "00-09-04"),
          Door.new(:up, "00-09-01", "finalApproach", subroom: "Bottom"),
          Door.new(:right, "00-09-06")
          ],
        "00-09-05", is_important: true
        ),
      Rm.new("East Corridor", "Forsaken Cloister", [
          Door.new(:left, "00-09-05"),
          Door.new(:right, "00-09-07", false),
          Enemy.new("Cave Troll", id: "01", type: "Threat"),
          Enemy.new("Blade Master", id: "02", type: "Challenger"),
          Enemy.new("Blade Master", id: "03", type: "Vanguard"),
          ],
        "00-09-06", width: 4, room_req: "beatLizards"
        ),
      Rm.new("East Entrance", "Forsaken Cloister", [
          Door.new(:left, "00-09-06"),
          Door.new(:right, "00-09-08"),
          Enemy.new("Blade Master", id: "02", type: "Challenger"),
          Enemy.new("Nova Skeleton", id: "03", type: ["Range", "Vanguard"]),
          ],
        "00-09-07", width: 2, room_req: "beatNovas"
        ),
      Rm.new("Tower to Cloister Loading", "Forsaken Cloister", [
          Door.new(:left, "00-09-07"),
          Door.new(:right, "00-06-0B")
          ],
        "00-09-08", room_type: :loading
        ),
      ],[
    #Final Approach
      Rm.new("Volaticus Shortcut Loading", "Final Approach", [
          Door.new(:left, "00-03-0B"),
          Door.new(:right, "00-0A-01")
          ],
        "00-0A-00", room_type: :loading
        ),
      Rm.new("Volaticus Shortcut Barrier", "Final Approach", [
          Door.new(:left, "00-0A-00"),
          Door.new(:right, "00-0A-02", false)
          ],
        "00-0A-01", width: 4
        ),
      Rm.new("Volaticus Attic", "Final Approach", [
          Item.new("Sun Ring"),
          Item.new("Blue Drops"),
          Item.new("MP Max Up"),
          Item.new("HEART Max Up"),
          Door.new(:down, "00-0A-03", width: 2),
          Enemy.new("Bugbear", id: "04", type: ["Seeker", "Floor", "Vanguard"]),
          Enemy.new("Bugbear", id: "05", type: ["Seeker", "Floor", "Vanguard"]),
          Enemy.new("Bugbear", id: "06", type: ["Seeker", "Floor", "Ambush"]),
          Enemy.new("Bugbear", id: "07", type: ["Seeker", "Floor", "Ambush"]),
          Enemy.new("Bugbear", id: "08", type: ["Seeker", "Floor", "Vanguard"]),
          Enemy.new("Bugbear", id: "09", type: ["Seeker", "Floor", "Vanguard"]),
          ],
        "00-0A-02", width: 3
        ),
      Rm.new("Volaticus Courtyard", "Final Approach", [
          Door.new(:left, "00-0A-01", "canFly", height: 2),
          Item.new("Volaticus"),
          Item.new("MP Max Up"),
          Door.new(:right, "00-0A-04", "canFly", height: 2),
          Door.new(:up, "00-0A-02", "canFly", width: 2),
          Enemy.new("Winged Skeleton", id: "03", type: ["Persistent", "Air", "Offscreen"]),
          ],
        "00-0A-03", width: 3, height: 2
        ),
      Rm.new("Volaticus Knight Corridor", "Final Approach", [
          Door.new(:left, "00-0A-03"),
          Door.new(:right, "00-0A-05"),
          Enemy.new("Final Knight", id: "00", type: "Guard"),
          Enemy.new("Final Knight", id: "01", type: "Guard"),
          ],
        "00-0A-04", width: 4, room_req: "beatArmor"
        ),
      Rm.new("Succubus Chamber", "Final Approach", [
          Door.new(:left, "00-0A-04"),
          Door.new(:right, "00-0A-06"),
          Enemy.new("Lilith", id: "00", type: ["Range", "Vanguard"]),
          ],
        "00-0A-05"
        ),
      Rm.new("Merman Stairs", "Final Approach", [
          Door.new(:left, "00-0A-05"),
          Door.new(:right, "00-0A-09", "highJump", height: 2),
          Door.new(:right, "00-0A-0A"),
          Enemy.new("Cave Troll", id: "00", type: ["Threat", "Vanguard", "Semi-Enclosed"]),
          Enemy.new("Cave Troll", id: "01", type: ["Threat", "Vanguard", "Semi-Enclosed"]),
          Enemy.new("Cave Troll", id: "02", type: ["Threat", "Vanguard", "Semi-Enclosed"]),
          Enemy.new("Cave Troll", id: "03", type: ["Threat", "Semi-Enclosed"]),
          Enemy.new("Cave Troll", id: "04", type: ["Threat", "Vanguard", "Semi-Enclosed", "Platform"]),
          ],
        "00-0A-06", width: 2, height: 2, room_req: "beatLizards"
        ),
      Rm.new("Dracula Loading", "Final Approach", [
          Door.new(:left, "00-0A-0C"),
          Door.new(:right, "00-0B-02")
          ],
        "00-0A-07", room_type: :loading
        ),
      Rm.new("Dracula Hub Heart Room", "Final Approach", [
          Item.new("HEART Max Up"),
          Door.new(:right, "00-0A-0C")
          ],
        "00-0A-08"
        ),
      Rm.new("Devil Chamber", "Final Approach", [
          Door.new(:left, "00-0A-06"),
          Door.new(:right, "00-0A-0D"),
          Enemy.new("Devil", id: "00", type: ["Guard", "Vanguard"]),
          ],
        "00-0A-09", room_req: "beatDevils"
        ),
      Rm.new("Skeleton Chamber", "Final Approach", [
          Door.new(:left, "00-0A-06"),
          Door.new(:right, "00-0A-0E"),
          Enemy.new("Blade Master", id: "00", type: "Vanguard"),
          ],
        "00-0A-0A", room_req: "highJump"
        ),
      Rm.new("Dracula Hub Attic", "Final Approach", [
          Item.new("Gold Ore"),
          Item.new("Diamond", id: "01"),
          Item.new("Diamond", id: "02"),
          Item.new("Onyx"),
          Door.new(:down, "00-0A-0C"),
          Enemy.new("Blade Master", id: "05", type: "Vanguard"),
          Enemy.new("Blade Master", id: "06", type: "Vanguard"),
          Enemy.new("Blade Master", id: "07", type: "Vanguard"),
          Enemy.new("Blade Master", id: "08", type: "Vanguard"),
          ],
        "00-0A-0B", width: 3, room_req: "beatNovas"
        ),
      Rm.new("Dracula Hub", "Final Approach", [
          Door.new(:left, "00-0A-07", height: 2),
          Door.new(:left, "00-0A-08"),
          Door.new(:up, "00-0A-0B", "canFly", width: 2),
          Item.new("Judgement Ring", "midDistance"),
          Door.new(:right, "00-0A-0F", height: 2),
          Door.new(:right, "00-0A-10"),
          Enemy.new("Blade Master", id: "03", type: ["Vanguard", "Enclosed"]),
          Enemy.new("Blade Master", id: "04", type: ["Vanguard", "Enclosed"]),
          Enemy.new("Lizardman Blade", id: "05", type: ["Challenger", "Enclosed"]),
          Enemy.new("Lizardman Blade", id: "06", type: ["Challenger", "Enclosed"]),
          Enemy.new("Bugbear", id: "07", type: ["Seeker", "Floor", "Vanguard", "Semi-Enclosed"]),
          Enemy.new("Bugbear", id: "08", type: ["Seeker", "Floor", "Vanguard", "Semi-Enclosed"]),
          Enemy.new("Devil", id: "09", type: ["Guard", "Semi-Enclosed", "Wall", "WallR"]),
          Enemy.new("Blade Master", id: "0A", type: ["Vanguard", "Semi-Enclosed", "Wall"]),
          Enemy.new("Blade Master", id: "0B", type: ["Vanguard", "Semi-Enclosed", "WallR"]),
          ],
        "00-0A-0C", width: 3, height: 2, room_req: "beatDevils"
        ),
      Rm.new("Final Knight Corridor", "Final Approach", [
          Door.new(:left, "00-0A-09"),
          Door.new(:right, "00-0A-10"),
          Enemy.new("Final Knight", id: "00", type: ["Guard", "Vanguard"]),
          Enemy.new("Final Knight", id: "01", type: ["Guard", "Vanguard"]),
          ],
        "00-0A-0D", width: 3, room_req: "beatArmor"
        ),
      Rm.new("Sword Corridor", "Final Approach", [
          Door.new(:left, "00-0A-0A"),
          Door.new(:right, "00-0A-11"),
          Enemy.new("Spectral Sword", id: "00", type: ["Threat", "Vanguard", "Air"]),
          Enemy.new("Spectral Sword", id: "01", type: ["Threat", "Vanguard", "Air"]),
          ],
        "00-0A-0E", width: 3, room_req: "beatArmor"
        ),
      Rm.new("Hub Teleporter", "Final Approach", [
          Door.new(:left, "00-0A-0C")
          ],
        "00-0A-0F", room_type: :teleporter
        ),
      Rm.new("Northeast Big Stairs", "Final Approach", [
          Door.new(:left, "00-0A-0C", "highJump", height: 2),
          Door.new(:left, "00-0A-0D"),
          Enemy.new("Lilith", id: "00", type: ["Range", "Vanguard", "Enclosed"]),
          Enemy.new("Lilith", id: "01", type: ["Range", "Enclosed"]),
          Enemy.new("Automaton ZX27", id: "02", type: ["Guard", "Semi-Enclosed"]),
          Enemy.new("Bugbear", id: "03", type: ["Seeker", "Floor", "Vanguard", "Semi-Enclosed", "Platform"]),
          Enemy.new("Devil", id: "04", type: ["Guard", "Vanguard", "Semi-Enclosed"]),
          Enemy.new("Devil", id: "05", type: ["Guard", "Vanguard", "Semi-Enclosed", "Wall"]),
          ],
        "00-0A-10", width: 2, height: 2, room_req: "beatDevils"
        ),
      Rm.new("Southeast Big Stairs", "Final Approach", [
          Door.new(:left, "00-0A-0E", "highJump", height: 2),
          Door.new(:left, "00-0A-12"),
          Enemy.new("Lizardman Blade", id: "01", type: ["Vanguard", "Enclosed"]),
          Enemy.new("Lizardman Blade", id: "02", type: ["Challenger", "Enclosed"]),
          Enemy.new("Lizardman Blade", id: "03", type: ["Vanguard", "Semi-Enclosed"]),
          Enemy.new("Imp", id: "04", type: ["Nuisance", "Enclosed", "Platform"]),
          Enemy.new("Bugbear", id: "05", type: ["Seeker", "Floor", "Semi-Enclosed"]),
          Enemy.new("Imp", id: "06", type: ["Nuisance", "Semi-Enclosed", "Vanguard", "Platform"]),
          Enemy.new("Imp", id: "07", type: ["Nuisance", "Semi-Enclosed", "Vanguard"]),
          ],
        "00-0A-11", width: 2, height: 2, room_req: "beatLizards"
        ),
      Rm.new("Entrance", "Final Approach", [
          Door.new(:left, "00-0A-13"),
          Door.new(:right, "00-0A-11", height: 2),
          Enemy.new("Imp", id: "01", type: ["Nuisance", "Semi-Enclosed", "Vanguard"]),
          Enemy.new("Imp", id: "02", type: ["Nuisance", "Semi-Enclosed"]),
          Enemy.new("Imp", id: "03", type: ["Nuisance", "Semi-Enclosed"]),
          Enemy.new("Imp", id: "04", type: ["Nuisance", "Semi-Enclosed", "Separated"]),
          Enemy.new("Imp", id: "05", type: ["Nuisance", "Semi-Enclosed", "Separated"]),
          Enemy.new("Imp", id: "06", type: ["Nuisance", "Semi-Enclosed"]),
          Enemy.new("Devil", id: "07", type: ["Guard", "Vanguard", "Semi-Enclosed"]),
          Enemy.new("Lizardman Blade", id: "08", type: ["Guard", "Semi-Enclosed"]),
          ],
        "00-0A-12", width: 3, height: 2, room_req: "beatDevils"
        ),
      Rm.new("Entrance Loading", "Final Approach", [
          Door.new(:left, "00-09-01"),
          Door.new(:right, "00-0A-12")
          ],
        "00-0A-13", room_type: :loading
        ),
      ],[
      Rm.new("Dracula Boss Room", "Final Approach", [
          Door.new(:right, "00-0B-01")
          ],
        "00-0B-00", width: 2, room_req: "beatDracula", is_important: true
        ),
      Rm.new("Dracula Save", "Final Approach", [
          Door.new(:left, "00-0B-00"),
          Door.new(:right, "00-0B-02")
          ],
        "00-0B-01", room_type: :save
        ),
      Rm.new("Broken Stairs", "Final Approach", [
          Door.new(:left, "00-0B-01", "canFly", height: 3),
          Item.new("Super Potion", "Paries"),
          Item.new("MP Max Up", "Paries"),
          Door.new(:right, "00-0A-07", height: 2)
          ],
        "00-0B-02", width: 2, height: 3, room_req: "highJump"
        ),
       ]]
  end

  def self.training_hall_rooms
    training_hall_rooms = [ [
      Rm.new("Entrance", "Training Hall", [
          Door.new(:left, "03-00-01", subroom: "Bottom"),
          ],
        "03-00-00", room_type: :entrance, is_important: true
        ),
      Rm.new("Redire Room Top", "Training Hall", [
          Door.new(:left, false, "03-00-0A", height: 8),
          Item.new("Redire"),
          Door.new(:down, "03-00-01", subroom: "Bottom"),
          ],
        "03-00-01", "Redire Room", height: 8
        ),
      Rm.new("Redire Room Bottom", "Training Hall", [
          Door.new(:left, "03-00-05", false, height: 4),
          Door.new(:left, "03-00-02"),
          Door.new(:right, "03-00-00"),
          Door.new(:up, false, "03-00-01", subroom: "Top"),
          ],
        "03-00-01", "Redire Room", height: 4
        ),
      Rm.new("Blade Room", "Training Hall", [
          Door.new(:left, "03-00-03"),
          Door.new(:right, "03-00-01", subroom: "Bottom"),
          ],
        "03-00-02", width: 4
        ),
      Rm.new("Southwest Flame Room", "Training Hall", [
          Door.new(:right, "03-00-04", "trainingHall", height: 3),
          Door.new(:right, "03-00-02"),
          ],
        "03-00-03", width: 2, height: 3
        ),
      Rm.new("Autoscroller Room", "Training Hall", [
          Door.new(:right, "03-00-05", height: 2),
          Door.new(:left, "03-00-03"),
          Enemy.new("Nova Skeleton", id: "01", type: "Range"),
          Enemy.new("Bone Pillar", id: "02", type: ["Guard", "Semi-Enclosed"]),
          Enemy.new("Double Hammer", id: "03", type: "Vanguard"),
          Enemy.new("Double Hammer", id: "04", type: "Challenger"),
          Enemy.new("Automaton ZX26", id: "05", type: ["Guard", "Enclosed"]),
          ],
        "03-00-04", width: 3, height: 2
        ),
      Rm.new("Rings Room", "Training Hall", [
          Door.new(:left, "03-00-06", "trainingHall", height: 3),
          Door.new(:left, "03-00-04"),
          Door.new(:right, "03-00-01", subroom: "Bottom"),
          ],
        "03-00-05", height: 3
        ),
      Rm.new("Central Flame Room", "Training Hall", [
          Door.new(:left, "03-00-07", "trainingHall", height: 2),
          Door.new(:right, "03-00-05"),
          ],
        "03-00-06", width: 3, height: 2
        ),
      Rm.new("Gear Room", "Training Hall", [
          Door.new(:right, "03-00-08", "trainingHall", height: 3),
          Door.new(:right, "03-00-06"),
          ],
        "03-00-07", width: 2, height: 3
        ),
      Rm.new("Obstacle Course", "Training Hall", [
          Door.new(:left, "03-00-09", "trainingHall", height: 2),
          Door.new(:left, "03-00-07"),
          Enemy.new("Automaton ZX26", id: "0E", type: "Guard"),
          Enemy.new("Automaton ZX26", id: "0F", type: "Guard"),
          ],
        "03-00-08", width: 3, height: 2
        ),
      Rm.new("Flame Elevator", "Training Hall", [
          Door.new(:right, "03-00-0A", "trainingHall", height: 3),
          Door.new(:right, "03-00-08"),
          ],
        "03-00-09", height: 3
        ),
      Rm.new("Final Flames", "Training Hall", [
          Door.new(:left, "03-00-09"),
          Door.new(:right, "03-00-01", "trainingHall", subroom: "Top"),
          ],
        "03-00-0A", width: 4
        ),
    ] ]
  end

  def self.forest_rooms
    forest_rooms = [ [
      Rm.new("Entrance", "Ruvas Forest", [
          Door.new(:right, "04-00-01"),
          ],
        "04-00-00", room_type: :entrance, is_important: true
        ),
      Rm.new("West Corridor", "Ruvas Forest", [
          Door.new(:left, "04-00-00"),
          Door.new(:right, "04-00-04"),
          Item.new("Macir"),
          Enemy.new("Nominon", id: "01", type: ["Nuisance", "Vanguard"]),
          Enemy.new("Bone Scimitar", id: "02", type: "Vanguard"),
          Enemy.new("Bone Scimitar", id: "03", type: "Challenger"),
          Enemy.new("Nominon", id: "04", type: "Nuisance"),
          Enemy.new("Une", id: "05", type: "Guard"),
          Enemy.new("Bone Scimitar", id: "06", type: "Challenger"),
          Enemy.new("Nominon", id: "07", type: "Nuisance"),
          Enemy.new("Une", id: "08", type: "Guard"),
          Enemy.new("Necromancer", id: "09", type: ["Nuisance", "Floor"]),
          Enemy.new("Nominon", id: "0A", type: ["Nuisance", "Vanguard"]),
          Enemy.new("Bone Scimitar", id: "0B", type: "Vanguard"),
          Enemy.new("Bone Scimitar", id: "0C", type: "Vanguard"),
          Enemy.new("Winged Guard", id: "16", type: ["Persistent", "Air", "Offscreen", "Hardmode"]),
          ],
        "04-00-01", width: 8
        ),
      Rm.new("East Corridor", "Ruvas Forest", [
          Door.new(:left, "04-00-04"),
          Door.new(:right, "04-00-03"),
          Enemy.new("Nominon", id: "00", type: "Nuisance"),
          Enemy.new("Bone Scimitar", id: "01", type: "Challenger"),
          Enemy.new("Bone Scimitar", id: "02", type: "Challenger"),
          Enemy.new("Necromancer", id: "03", type: ["Nuisance", "Floor"]),
          Enemy.new("Nominon", id: "04", type: "Nuisance"),
          Enemy.new("Une", id: "05", type: "Guard"),
          Enemy.new("Bone Scimitar", id: "06", type: "Challenger"),
          Enemy.new("Axe Knight", id: "07", type: "Range"),
          Enemy.new("Bone Scimitar", id: "08", type: "Challenger"),
          Enemy.new("Nominon", id: "09", type: "Nuisance"),
          Enemy.new("Une", id: "0A", type: "Guard"),
          Enemy.new("Necromancer", id: "0B", type: ["Nuisance", "Floor"]),
          Enemy.new("Une", id: "0C", type: "Guard"),
          Enemy.new("Une", id: "0D", type: "Guard"),
          Enemy.new("Nominon", id: "0E", type: "Nuisance"),
          Enemy.new("Bone Scimitar", id: "0F", type: "Vanguard"),
          Enemy.new("Medusa Head", id: "19", type: ["Persistent", "Air", "Vanguard", "Hardmode"]),
          ],
        "04-00-02", width: 8
        ),
      Rm.new("Exit", "Ruvas Forest", [
          Door.new(:left, "04-00-02"),
          ],
        "04-00-03", is_important: true
        ),
      Rm.new("Central Corridor", "Ruvas Forest", [
          Door.new(:left, "04-00-01"),
          Door.new(:right, "04-00-02"),
          Enemy.new("Zombie", id: "04", type: ["Guard", "Vanguard"]),
          Enemy.new("Zombie", id: "05", type: "Guard"),
          Enemy.new("Zombie", id: "06", type: "Guard"),
          Enemy.new("Bat", id: "07", type: ["Persistent", "Air", "Offscreen"]),
          Enemy.new("Nominon", id: "08", type: "Nuisance"),
          Enemy.new("Skeleton", id: "09", type: "Range"),
          Enemy.new("Skeleton", id: "0A", type: "Range"),
          Enemy.new("Skeleton", id: "0B", type: "Range"),
          Enemy.new("Skeleton", id: "0C", type: "Range"),
          Enemy.new("Axe Knight", id: "0D", type: "Range"),
          Enemy.new("Axe Knight", id: "0E", type: "Range"),
          Enemy.new("Axe Knight", id: "0F", type: "Range"),
          Enemy.new("Nominon", id: "10", type: "Nuisance"),
          Enemy.new("Nominon", id: "11", type: "Nuisance"),
          Enemy.new("Nominon", id: "12", type: "Nuisance"),
          Enemy.new("Zombie", id: "13", type: "Guard"),
          Enemy.new("Zombie", id: "14", type: "Guard"),
          Enemy.new("Zombie", id: "15", type: "Guard"),
          Enemy.new("Zombie", id: "16", type: "Guard"),
          Enemy.new("Zombie", id: "17", type: "Guard"),
          Enemy.new("Zombie", id: "18", type: "Guard"),
          Enemy.new("Bone Scimitar", id: "19", type: "Challenger"),
          Enemy.new("Bone Scimitar", id: "1A", type: "Vanguard"),
          Enemy.new("Bone Scimitar", id: "1B", type: "Vanguard"),
          ],
        "04-00-04", width: 8
        ),
    ] ]
  end

  def self.monastery_rooms
    monastery_rooms = [ [
      Rm.new("Lobby", "Monastery", [
          Door.new(:left, "12-01-01"),
          Door.new(:right, "12-00-01"),
          Enemy.new("Skeleton", id: "00", type: ["Range", "Vanguard"]),
          Enemy.new("Skeleton", id: "01", type: "Range"),
          Enemy.new("Skeleton", id: "02", type: "Range"),
          Enemy.new("Skeleton", id: "03", type: "Range"),
          Enemy.new("Skeleton", id: "04", type: ["Range", "Vanguard"]),
          Enemy.new("Axe Knight", id: "09", type: ["Range", "Vanguard", "Hardmode"]),
          Enemy.new("Bone Archer", id: "0A", type: ["Range", "Hardmode"]),
          Enemy.new("Axe Knight", id: "0B", type: ["Range", "Vanguard", "Hardmode"]),
          ],
        "12-00-00", width: 4
        ),
      Rm.new("South Climb", "Monastery", [
          Door.new(:left, "12-00-04", height: 4),
          Door.new(:left, "12-00-00"),
          Door.new(:right, "12-00-03", height: 4),
          Door.new(:right, "12-00-02"),
          Enemy.new("Bat", id: "01", type: ["Nuisance", "Enclosed"]),
          Enemy.new("Bat", id: "02", type: ["Nuisance", "Vanguard", "Semi-Enclosed", "AirOnly"]),
          Enemy.new("Skeleton", id: "03", type: ["Range", "Separated", "Enclosed"]),
          Enemy.new("Bat", id: "04", type: ["Nuisance", "Platform", "Separated", "Enclosed"]),
          Enemy.new("Bat", id: "05", type: ["Nuisance", "Platform", "Separated", "Passthrough"]),
          Enemy.new("Bat", id: "0A", type: ["Persistent", "Air", "Offscreen", "Hardmode"]),
          ],
        "12-00-01", height: 4
        ),
      Rm.new("Teleporter Corridor", "Monastery", [
          Door.new(:left, "12-00-01"),
          Door.new(:right, "12-00-15"),
          Enemy.new("Skeleton", id: "00", type: ["Range", "Vanguard"]),
          Enemy.new("Zombie", id: "01", type: ["Guard", "Vanguard"]),
          Enemy.new("Zombie", id: "02", type: ["Guard", "Ambush"]),
          ],
        "12-00-02", width: 2
        ),
      Rm.new("Sandals Room", "Monastery", [
          Door.new(:left, "12-00-01"),
          Enemy.new("Skeleton", id: "01", type: ["Range", "Vanguard"]),
          Enemy.new("Skeleton", id: "02", type: "Range"),
          Enemy.new("Banshee", id: "03", type: "Seeker"),
          Enemy.new("Banshee", id: "04", type: ["Seeker", "Vanguard"]),
          ],
        "12-00-03", width: 2
        ),
      Rm.new("Corridor to Magnes", "Monastery", [
          Door.new(:left, "12-00-05", subroom: "Bottom"),
          Door.new(:right, "12-00-03"),
          Enemy.new("Skeleton", id: "00", type: ["Range", "Vanguard"]),
          Enemy.new("Skeleton", id: "01", type: "Range"),
          Enemy.new("Skeleton", id: "02", type: "Range"),
          Enemy.new("Skeleton", id: "03", type: ["Range", "Vanguard"]),
          Enemy.new("Axe Knight", id: "07", type: ["Range", "Hardmode"]),
          Enemy.new("Axe Knight", id: "08", type: ["Range", "Vanguard", "Hardmode"]),
          ],
        "12-00-04", width: 3
        ),
      Rm.new("Magnes Climb Top", "Monastery", [
          Door.new(:left, "12-00-07"),
          Item.new("Cotton Hat"),
          Door.new(:down, "12-00-05", subroom: "Mid"),
          ],
        "12-00-05", "Magnes Climb"
        ),
      Rm.new("Magnes Climb Mid", "Monastery", [
          Door.new(:up, "12-00-05", "magnesFlight", subroom: "Top"),
          Door.new(:right, "12-00-09"),
          Door.new(:down, "12-00-05", subroom: "Bottom"),
          ],
        "12-00-05", "Magnes Climb"
        ),
      Rm.new("Magnes Climb Bottom", "Monastery", [
          Door.new(:left, "12-00-06"),
          Door.new(:up, "12-00-05", "magnesFlght", subroom: "Mid"),
          Door.new(:right, "12-00-04"),
          Item.new("Magnes"),
          ],
        "12-00-05", "Magnes Climb", height: 2
        ),
      Rm.new("Magnes Save", "Monastery", [
          Door.new(:right, "12-00-05", subroom: "Bottom"),
          ],
        "12-00-06", room_type: :save
        ),
      Rm.new("Cat Room", "Monastery", [
          Door.new(:left, "12-00-08"),
          Door.new(:right, "12-00-05", subroom: "Top", height: 2),
          Item.new("Fool Ring", "highJump"),
          Item.new("HP Max Up"),
          Enemy.new("Ghost", id: "02", type: ["Persistent", "Air", "Vanguard", "Enclosed"]),
          Enemy.new("Banshee", id: "03", type: ["Seeker", "Semi-Enclosed"]),
          ],
        "12-00-07", width: 2, height: 2
        ),
      Rm.new("Cube Room", "Monastery", [
          Door.new(:right, "12-00-07"),
          Item.new("Cubus", "hasFire"),
          Enemy.new("Bone Scimitar", id: "01", type: "Vanguard"),
          ],
        "12-00-08", width: 2
        ),
      Rm.new("Culter Corridor", "Monastery", [
          Door.new(:left, "12-00-05", subroom: "Mid"),
          Door.new(:right, "12-00-0A"),
          Item.new("Culter"),
          Enemy.new("Zombie", id: "02", type: "Persistent"),
          Enemy.new("Bone Archer", id: "07", type: ["Range", "Hardmode"]),
          Enemy.new("Bone Archer", id: "08", type: ["Range", "Hardmode"]),
          ],
        "12-00-09", width: 4
        ),
      Rm.new("Book Room", "Monastery", [
          Door.new(:left, "12-00-0B", height: 2),
          Door.new(:left, "12-00-09"),
          Door.new(:right, "12-00-0C"),
          Item.new("Book of Spirits"),
          Enemy.new("Ghost", id: "03", type: ["Persistent", "Air"]),
          Enemy.new("Banshee", id: "04", type: "Seeker"),
          Enemy.new("Banshee", id: "05", type: ["Seeker", "Semi-Enclosed"]),
          ],
        "12-00-0A", width: 2, height: 2
        ),
      Rm.new("Heart Room", "Monastery", [
          Door.new(:right, "12-00-0A"),
          Item.new("HEART Max Up"),
          Enemy.new("Zombie", id: "02", type: ["Persistent", "Vanguard"]),
          Enemy.new("Ghost", id: "03", type: ["Persistent", "Air", "Vanguard"]),
          ],
        "12-00-0B", width: 2
        ),
      Rm.new("Banshee Corridor", "Monastery", [
          Door.new(:left, "12-00-0A"),
          Door.new(:right, "12-00-0D"),
          Enemy.new("Banshee", id: "01", type: ["Seeker", "Vanguard"]),
          Enemy.new("Banshee", id: "02", type: ["Seeker", "Vanguard"]),
          Enemy.new("Bone Scimitar", id: "03", type: "Vanguard"),
          ],
        "12-00-0C", width: 2
        ),
      Rm.new("Northeast Climb", "Monastery", [
          Door.new(:left, "12-00-0F", height: 4),
          Door.new(:left, "12-00-0C"),
          Door.new(:right, "12-00-0E", height: 4),
          Item.new("$500"),
          Item.new("Red Drops"),
          Enemy.new("Bat", id: "05", type: ["Nuisance", "Enclosed", "Separated"]),
          Enemy.new("Bat", id: "06", type: ["Nuisance", "Enclosed", "Separated"]),
          Enemy.new("Bat", id: "07", type: ["Nuisance", "Enclosed", "Separated"]),
          Enemy.new("Bat", id: "08", type: ["Nuisance", "Enclosed", "Separated"]),
          Enemy.new("Skeleton", id: "09", type: ["Range", "Separated"]),
          Enemy.new("Skeleton", id: "0A", type: ["Range", "Separated"]),
          ],
        "12-00-0D", height: 4
        ),
      Rm.new("Northeast Alcove", "Monastery", [
          Door.new(:left, "12-00-0D"),
          Enemy.new("Banshee", id: "02", type: ["Seeker", "Vanguard"]),
          Enemy.new("Bone Scimitar", id: "03", type: "Vanguard"),
          Enemy.new("Banshee", id: "04", type: "Seeker"),
          ],
        "12-00-0E", width: 2
        ),
      Rm.new("North Corridor", "Monastery", [
          Door.new(:left, "12-00-10", subroom: "Bottom"),
          Door.new(:right, "12-00-0D"),
          Enemy.new("Zombie", id: "01", type: "Persistent"),
          Enemy.new("Skeleton", id: "02", type: ["Range", "Vanguard"]),
          Enemy.new("Skeleton", id: "03", type: "Range"),
          Enemy.new("Skeleton", id: "04", type: "Range"),
          Enemy.new("Bone Scimitar", id: "05", type: "Challenger"),
          Enemy.new("Skeleton", id: "06", type: "Range"),
          Enemy.new("Skeleton", id: "07", type: "Range"),
          Enemy.new("Bone Scimitar", id: "08", type: "Challenger"),
          Enemy.new("Skeleton", id: "09", type: ["Range", "Vanguard"]),
          ],
        "12-00-0F", width: 7
        ),
      Rm.new("Boss Lobby Top", "Monastery", [
          Door.new(:left, "12-00-12"),
          Door.new(:down, "12-00-10", subroom: "Bottom"),
          Door.new(:right, "12-00-13"),
          ],
        "12-00-10", "Boss Lobby"
        ),
      Rm.new("Boss Lobby Bottom", "Monastery", [
          Door.new(:left, "12-00-11"),
          Door.new(:up, "12-00-10", "magnesFlight", subroom: "Top"),
          Door.new(:right, "12-00-0F"),
          ],
        "12-00-10", "Boss Lobby"
        ),
      Rm.new("Boss Save", "Monastery", [
          Door.new(:right, "12-00-10", subroom: "Bottom"),
          ],
        "12-00-11", room_type: :save
        ),
      Rm.new("Boss Teleporter", "Monastery", [
          Door.new(:right, "12-00-10", subroom: "Top"),
          ],
        "12-00-12", room_type: :teleporter
        ),
      Rm.new("Boss Room", "Monastery", [
          Door.new(:left, "12-00-10", subroom: "Top"),
          Door.new(:right, "12-00-14"),
          ],
        "12-00-13", room_req: "beatArthroverta", is_important: true
        ),
      Rm.new("Albus Room", "Monastery", [
          Door.new(:left, "12-00-13"),
          ],
        "12-00-14", is_important: true
        ),
      Rm.new("Lower Teleporter", "Monastery", [
          Door.new(:left, "12-00-02"),
          ],
        "12-00-15", room_type: :teleporter
        ),
      ],[
      Rm.new("Entrance", "Monastery", [
          Door.new(:right, "12-01-01"),
          ],
        "12-01-00", room_type: :entrance, is_important: true
        ),
      Rm.new("Front Door", "Monastery", [
          Door.new(:left, "12-01-00"),
          Door.new(:right, "12-00-00"),
          ],
        "12-01-01"
        ),
    ] ]
  end

  def self.skeleton_cave_rooms
    skeleton_cave_rooms = [ [
      Rm.new("Entrance", "Skeleton Cave", [
          Door.new(:left, "11-00-09"),
          ],
        "11-00-00", room_type: :entrance, is_important: true
        ),
      Rm.new("First Descent", "Skeleton Cave", [
          Door.new(:down, "11-00-02"),
          Door.new(:right, "11-00-09"),
          Enemy.new("Bone Pillar", id: "01", type: ["Range", "Wall"]),
          Enemy.new("Skeleton Frisky", id: "02", type: ["Nuisance", "Floor", "Vanguard"]),
          Enemy.new("Skeleton Frisky", id: "03", type: ["Nuisance", "Floor"]),
          Enemy.new("Skeleton Frisky", id: "04", type: ["Nuisance", "Floor"]),
          Enemy.new("Dullahan", id: "05", type: ["Challenger", "Separated", "Enclosed", "Wall"]),
          Enemy.new("Blade Master", id: "0B", type: ["Challenger", "Hardmode"]),
          ],
        "11-00-01", width: 4
        ),
      Rm.new("U-Turn", "Skeleton Cave", [
          Door.new(:down, "11-00-04", width: 4),
          Door.new(:up, "11-00-01", width: 4),
          Door.new(:left, "11-00-0A"),
          Enemy.new("Skeleton Hero", id: "00", type: ["Range", "Enclosed", "Wall"]),
          Enemy.new("Skeleton Hero", id: "01", type: ["Range", "Enclosed", "Wall", "WallR"]),
          Enemy.new("Skeleton Hero", id: "02", type: ["Range", "Enclosed", "WallR"]),
          Enemy.new("Dullahan", id: "03", type: ["Vanguard", "Enclosed"]),
          Enemy.new("Dullahan", id: "04", type: ["Vanguard", "Enclosed"]),
          Enemy.new("Dullahan", id: "05", type: ["Challenger", "Enclosed"]),
          Enemy.new("Winged Guard", id: "0E", type: ["Persistent", "Air", "Offscreen", "Hardmode"]),
          ],
        "11-00-02", width: 4
        ),
      Rm.new("HP Room", "Skeleton Cave", [
          Door.new(:right, "11-00-0A"),
          Item.new("HP Max Up"),
          Enemy.new("White Dragon", id: "03", type: ["Range", "Semi-Enclosed", "Vanguard", "Wall", "MustMove"]),
          ],
        "11-00-03"
        ),
      Rm.new("Rex Descent", "Skeleton Cave", [
          Door.new(:down, "11-00-05", width: 4),
          Door.new(:up, "11-00-02", width: 2),
          Enemy.new("Skeleton Rex", id: "01", type: "Vanguard"),
          Enemy.new("White Dragon", id: "02", type: ["Range", "Enclosed", "Wall", "MustMove"]),
          Enemy.new("Dullahan", id: "03", type: ["Vanguard", "Enclosed"]),
          Enemy.new("Skeleton Hero", id: "04", type: ["Challenger", "Enclosed"]),
          ],
        "11-00-04", width: 4
        ),
      Rm.new("Bone Pile", "Skeleton Cave", [
          Door.new(:left, "11-00-0B"),
          Door.new(:up, "11-00-04", width: 2),
          Item.new("Black Drops"),
          Item.new("MP Max Up"),
          Enemy.new("Bone Pillar", id: "04", type: ["Range", "Vanguard", "Enclosed"]),
          Enemy.new("Bone Pillar", id: "05", type: ["Range", "Enclosed"]),
          Enemy.new("Bone Pillar", id: "06", type: ["Range", "Enclosed"]),
          Enemy.new("Bone Pillar", id: "07", type: ["Range", "Enclosed"]),
          Enemy.new("Bone Pillar", id: "08", type: ["Range", "Enclosed"]),
          Enemy.new("Bone Pillar", id: "0C", type: ["Range", "Vanguard", "Hardmode"]),
          ],
        "11-00-05", width: 2
        ),
      Rm.new("Boss Save", "Skeleton Cave", [
          Door.new(:left, "11-00-07"),
          Door.new(:right, "11-00-0B"),
          ],
        "11-00-06", room_type: :save
        ),
      Rm.new("Boss Room", "Skeleton Cave", [
          Door.new(:left, "11-00-08"),
          Door.new(:right, "11-00-06"),
          ],
        "11-00-07", width: 2, is_important: true
        ),
      Rm.new("George's Room", "Skeleton Cave", [
          Door.new(:right, "11-00-07"),
          Item.new("Ordinary Rock"),
          Enemy.new("Skeleton Beast", id: "04", type: "Guard"),
          ],
        "11-00-08", width: 2, is_important: true
        ),
      Rm.new("Lobby", "Skeleton Cave", [
          Door.new(:left, "11-00-01"),
          Door.new(:right, "11-00-00"),
          Enemy.new("Bone Pillar", id: "01", type: ["Range", "Vanguard"]),
          Enemy.new("Dullahan", id: "02", type: "Vanguard"),
          Enemy.new("Dullahan", id: "03", type: "Vanguard"),
          Enemy.new("Skeleton Frisky", id: "04", type: ["Nuisance", "Floor", "Vanguard"]),
          Enemy.new("Skeleton Frisky", id: "05", type: ["Nuisance", "Floor", "Vanguard"]),
          Enemy.new("Skeleton Frisky", id: "06", type: ["Nuisance", "Floor", "Vanguard"]),
          Enemy.new("Skeleton Frisky", id: "07", type: ["Nuisance", "Floor", "Vanguard"]),
          Item.new("HEART Max Up"),
          ],
        "11-00-09", width: 3
        ),
      Rm.new("Frisky Room", "Skeleton Cave", [
          Door.new(:left, "11-00-03"),
          Door.new(:right, "11-00-02"),
          Enemy.new("Skeleton Hero", id: "00", type: ["Range", "Vanguard"]),
          Enemy.new("Skeleton Hero", id: "01", type: ["Range", "Vanguard"]),
          Enemy.new("Skeleton Frisky", id: "02", type: ["Nuisance", "Floor", "Vanguard"]),
          Enemy.new("Skeleton Frisky", id: "03", type: ["Nuisance", "Floor", "Vanguard"]),
          Enemy.new("Skeleton Frisky", id: "04", type: ["Nuisance", "Floor", "Vanguard"]),
          Enemy.new("Skeleton Frisky", id: "05", type: ["Nuisance", "Floor", "Vanguard"]),
          Enemy.new("Skeleton Frisky", id: "06", type: ["Nuisance", "Floor", "Vanguard"]),
          Enemy.new("Skeleton Frisky", id: "07", type: ["Nuisance", "Floor"]),
          Enemy.new("Skeleton Frisky", id: "08", type: ["Nuisance", "Floor"]),
          Enemy.new("Skeleton Frisky", id: "09", type: ["Nuisance", "Floor"]),
          Enemy.new("Skeleton Frisky", id: "0A", type: ["Nuisance", "Floor"]),
          Enemy.new("Skeleton Frisky", id: "0B", type: ["Nuisance", "Floor"]),
          Enemy.new("Skeleton Frisky", id: "0C", type: ["Nuisance", "Floor"]),
          Enemy.new("Skeleton Frisky", id: "0D", type: ["Nuisance", "Floor"]),
          Enemy.new("Skeleton Frisky", id: "0E", type: ["Nuisance", "Floor", "Vanguard"]),
          Enemy.new("Skeleton Frisky", id: "0F", type: ["Nuisance", "Floor", "Vanguard"]),
          Enemy.new("Skeleton Frisky", id: "10", type: ["Nuisance", "Floor", "Vanguard"]),
          Enemy.new("Skeleton Frisky", id: "11", type: ["Nuisance", "Floor", "Vanguard"]),
          Enemy.new("Skeleton Frisky", id: "12", type: ["Nuisance", "Floor", "Vanguard"]),
          Item.new("HEART Max Up"),
          ],
        "11-00-0A", width: 3
        ),
      Rm.new("Rex Room", "Skeleton Cave", [
          Door.new(:left, "11-00-06"),
          Door.new(:right, "11-00-05"),
          Enemy.new("Skeleton Rex", id: "02", type: "Vanguard"),
          Enemy.new("Skeleton Rex", id: "03", type: "Vanguard"),
          ],
        "11-00-0B", width: 3
        ),
    ] ]
  end

  def self.misty_rooms
    misty_rooms = [ [
      Rm.new("Exit", "Misty Forest Road", [
          Door.new(:right, "0F-00-01"),
          ],
        "0F-00-00", is_important: true
        ),
      Rm.new("Werebat Courtyard", "Misty Forest Road", [
          Door.new(:left, "0F-00-00"),
          Door.new(:right, "0F-00-01"),
          Enemy.new("Bitterfly", id: "00", type: ["Seeker", "Vanguard"]),
          Enemy.new("Werebat", id: "01", type: "Vanguard"),
          Enemy.new("Werebat", id: "02", type: "Challenger"),
          Enemy.new("Werebat", id: "03", type: "Challenger"),
          Enemy.new("Bitterfly", id: "04", type: "Seeker"),
          Enemy.new("Bitterfly", id: "05", type: "Seeker"),
          Enemy.new("Bitterfly", id: "06", type: ["Seeker", "Vanguard"]),
          ],
        "0F-00-01", width: 4
        ),
      Rm.new("West Hill", "Misty Forest Road", [
          Door.new(:left, "0F-00-01"),
          Door.new(:right, "0F-00-03", height: 2),
          Door.new(:right, "0F-00-04", "Paries"),
          Item.new("Rue", "oblivionJump"),
          Enemy.new("Specter", id: "04", type: ["Nuisance", "Vanguard"]),
          Enemy.new("Specter", id: "05", type: ["Nuisance", "Vanguard"]),
          ],
        "0F-00-02", width: 2, height: 2
        ),
      Rm.new("Enkidu Chamber", "Misty Forest Road", [
          Door.new(:left, "0F-00-02"),
          Door.new(:right, "0F-00-05"),
          Enemy.new("Enkidu", id: "00", type: "Guard"),
          ],
        "0F-00-03", width: 4
        ),
      Rm.new("Lizard Cave", "Misty Forest Road", [
          Door.new(:left, "0F-00-02", "Paries"),
          Item.new("Melio Arcus"),
          Item.new("White Drops"),
          Item.new("Hierophant Ring"),
          Enemy.new("Lizardman Blade", id: "04", type: "Vanguard"),
          Enemy.new("Lizardman Blade", id: "05", type: "Challenger"),
          Enemy.new("Lizardman Blade", id: "06", type: "Challenger"),
          Enemy.new("Lizardman Blade", id: "07", type: "Challenger"),
          Enemy.new("Lizardman Blade", id: "08", type: "Challenger"),
          Enemy.new("Lizardman Blade", id: "09", type: "Challenger"),
          ],
        "0F-00-04", width: 4
        ),
      Rm.new("East Hill", "Misty Forest Road", [
          Door.new(:left, "0F-00-03", height: 2),
          Door.new(:right, "0F-00-06"),
          Item.new("Sage", "magnesFlight"),
          Item.new("Vol Macir"),
          Enemy.new("Bitterfly", id: "04", type: ["Seeker", "Platform", "Passthrough"]),
          Enemy.new("Specter", id: "05", type: ["Nuisance", "Vanguard"]),
          Enemy.new("Specter", id: "06", type: ["Nuisance", "Vanguard"]),
          Enemy.new("Werebat", id: "07", type: "Range"),
          ],
        "0F-00-05", width: 2, height: 2
        ),
      Rm.new("East Courtyard", "Misty Forest Road", [
          Door.new(:left, "0F-00-05"),
          Door.new(:right, "0F-00-07"),
          Enemy.new("Grave Digger", id: "00", type: "Vanguard"),
          Enemy.new("Bitterfly", id: "01", type: ["Seeker", "Vanguard"]),
          Enemy.new("Bitterfly", id: "02", type: "Seeker"),
          Enemy.new("Bitterfly", id: "03", type: "Seeker"),
          Enemy.new("Black Fomor", id: "04", type: ["Nuisance", "Vanguard"]),
          Enemy.new("Bitterfly", id: "05", type: ["Seeker", "Vanguard"]),
          ],
        "0F-00-06", width: 4
        ),
      Rm.new("Ruined Walls", "Misty Forest Road", [
          Door.new(:left, "0F-00-06"),
          Door.new(:right, "0F-00-08"),
          Enemy.new("Grave Digger", id: "00", type: "Vanguard"),
          Enemy.new("Grave Digger", id: "01", type: "Vanguard"),
          Enemy.new("Specter", id: "02", type: "Nuisance"),
          Enemy.new("Specter", id: "03", type: "Nuisance"),
          Enemy.new("Bitterfly", id: "04", type: ["Seeker", "Vanguard"]),
          Enemy.new("Bitterfly", id: "05", type: ["Seeker", "Vanguard"]),
          Enemy.new("Bitterfly", id: "06", type: ["Seeker", "Vanguard"]),
          ],
        "0F-00-07", width: 4
        ),
      Rm.new("Entrance", "Misty Forest Road", [
          Door.new(:left, "0F-00-07"),
          ],
        "0F-00-07", room_type: :entrance, is_important: true
        ),
    ] ]
  end

  def self.minera_rooms
    minera_rooms = [ [
      Rm.new("Entrance", "Minera Prison Island", [
          Door.new(:right, "08-00-01"),
          ],
        "08-00-00", room_type: :entrance, is_important: true
        ),
      Rm.new("Boss Teleporter", "Minera Prison Island", [
          Door.new(:left, "08-00-00"),
          Door.new(:right, "08-00-02"),
          ],
        "08-00-01", room_type: :teleporter
        ),
      Rm.new("Boss Room", "Minera Prison Island", [
          Door.new(:left, "08-00-01"),
          Door.new(:right, "08-00-03"),
          ],
        "08-00-02", width: 2, is_important: true
        ),
      Rm.new("West Searchlights", "Minera Prison Island", [
          Door.new(:left, "08-00-02"),
          Door.new(:right, "08-00-04"),
          Enemy.new("Evil Force", id: "01", type: ["Seeker", "Searchlight"]),
          Enemy.new("Spear Guard", id: "02", type: "Vanguard"),
          Enemy.new("Axe Knight", id: "03", type: "Range"),
          Enemy.new("Spear Guard", id: "04", type: "Vanguard"),
          ],
        "08-00-03", width: 3
        ),
      Rm.new("West-Central Searchlights", "Minera Prison Island", [
          Door.new(:left, "08-00-03"),
          Door.new(:right, "08-00-05"),
          Enemy.new("Evil Force", id: "01", type: ["Seeker", "Searchlight"]),
          Enemy.new("Spear Guard", id: "02", type: "Vanguard"),
          Enemy.new("Spear Guard", id: "03", type: "Challenger"),
          Enemy.new("Bone Archer", id: "04", type: "Range"),
          Enemy.new("Spear Guard", id: "05", type: "Challenger"),
          Enemy.new("Spear Guard", id: "06", type: "Vanguard"),
          ],
        "08-00-04", width: 5
        ),
      Rm.new("West Lobby", "Minera Prison Island", [
          Door.new(:left, "08-00-04", height: 2),
          Door.new(:right, "08-00-06", height: 3),
          Door.new(:right, "08-00-08", height: 2),
          Door.new(:right, "08-00-07"),
          Item.new("$500"),
          Enemy.new("Spear Guard", id: "02", type: ["Vanguard", "Enclosed"]),
          Enemy.new("Bone Archer", id: "03", type: ["Range", "Platform"]),
          ],
        "08-00-05", height: 3
        ),
      Rm.new("Northwest Cells", "Minera Prison Island", [
          Door.new(:left, "08-00-05"),
          Door.new(:right, "08-00-0A"),
          Enemy.new("Spear Guard", id: "03", type: ["Vanguard", "Enclosed", "Wall"]),
          Enemy.new("Spear Guard", id: "04", type: ["Challenger", "Enclosed"]),
          Enemy.new("Spear Guard", id: "05", type: ["Challenger", "Enclosed", "Wall"]),
          Enemy.new("Spear Guard", id: "06", type: ["Challenger", "Enclosed"]),
          Enemy.new("Bone Archer", id: "07", type: ["Range", "Enclosed", "WallR"]),
          Enemy.new("Bone Archer", id: "08", type: ["Range", "Enclosed"]),
          Enemy.new("Spear Guard", id: "09", type: ["Challenger", "Enclosed", "WallR"]),
          Enemy.new("Spear Guard", id: "0A", type: ["Vanguard", "Enclosed"]),
          Enemy.new("Spear Guard", id: "0B", type: ["Vanguard", "Enclosed"]),
          ],
        "08-00-06", width: 4
        ),
      Rm.new("Southwest Cells", "Minera Prison Island", [
          Door.new(:left, "08-00-05"),
          Item.new("Cabriolet"),
          Item.new("MP Max Up"),
          Enemy.new("Spear Guard", id: "03", type: ["Vanguard", "Enclosed"]),
          Enemy.new("Spear Guard", id: "04", type: ["Challenger", "Enclosed"]),
          Enemy.new("Spear Guard", id: "05", type: ["Challenger", "Enclosed"]),
          Enemy.new("Spear Guard", id: "06", type: ["Challenger", "Enclosed"]),
          Enemy.new("Bone Archer", id: "07", type: ["Range", "Enclosed", "WallR"]),
          Enemy.new("Bone Archer", id: "08", type: ["Range", "Enclosed"]),
          Enemy.new("Spear Guard", id: "09", type: ["Challenger", "Enclosed", "WallR"]),
          Enemy.new("Spear Guard", id: "0A", type: ["Challenger", "Enclosed"]),
          Enemy.new("Spear Guard", id: "0B", type: ["Challenger", "Enclosed"]),
          ],
        "08-00-07", width: 4
        ),
      Rm.new("West Save", "Minera Prison Island", [
          Door.new(:left, "08-00-07"),
          ],
        "08-00-08", room_type: :save
        ),
      Rm.new("Priestess Room", "Minera Prison Island", [
          Door.new(:right, "08-00-0A"),
          Item.new("Priestess Ring"),
          ],
        "08-00-09"
        ),
      Rm.new("Northwest Descent", "Minera Prison Island", [
          Door.new(:left, "08-00-06", height: 3),
          Door.new(:left, "08-00-09", height: 2),
          Door.new(:right, "08-01-00"),
          Enemy.new("Bone Archer", id: "05", type: ["Range", "Platform"]),
          Enemy.new("Axe Knight", id: "06", type: ["Range", "Vanguard", "Enclosed"]),
          ],
        "08-00-0A", height: 3
        ),
      ],[
      Rm.new("Tower Loading", "Minera Prison Island", [
          Door.new(:left, "08-00-0A"),
          Door.new(:right, "08-01-03"),
          ],
        "08-01-00", room_type: :loading
        ),
      Rm.new("Tower Summit", "Minera Prison Island", [
          Door.new(:down, "08-01-02"),
          Item.new("Tower Ring", "highJump"),
          ],
        "08-01-01"
        ),
      Rm.new("Tower", "Minera Prison Island", [
          Door.new(:up, "08-01-01", "highJump"),
          Door.new(:down, "08-01-03"),
          Item.new("Anti-Venom"),
          Enemy.new("Winged Guard", id: "01", type: ["Persistent", "Air", "AirOnly", "Passthrough"]),
          ],
        "08-01-02", height: 5
        ),
      Rm.new("Southwest Descent", "Minera Prison Island", [
          Door.new(:up, "08-00-02"),
          Door.new(:left, "08-01-00", height: 3),
          Door.new(:left, "08-01-05"),
          Enemy.new("Axe Knight", id: "00", type: ["Range", "Platform"]),
          Enemy.new("Bone Archer", id: "01", type: ["Range", "Platform"]),
          Enemy.new("Spear Guard", id: "02", type: ["Vanguard", "Enclosed"]),
          ],
        "08-01-03", height: 3
        ),
      Rm.new("Tower Teleporter", "Minera Prison Island", [
          Door.new(:right, "08-01-06"),
          ],
        "08-01-04", room_type: :teleporter
        ),
      Rm.new("HP Room", "Minera Prison Island", [
          Door.new(:right, "08-01-03"),
          Door.new(:down, "08-01-06"),
          Item.new("HP Max Up"),
          Enemy.new("Invisible Man", id: "01", type: "Ambush"),
          Enemy.new("Spear Guard", id: "02", type: "Vanguard"),
          ],
        "08-01-05", width: 3
        ),
      Rm.new("Blade Room", "Minera Prison Island", [
          Door.new(:left, "08-01-04"),
          Door.new(:up, "08-01-05"),
          Door.new(:right, "08-01-07"),
          Item.new("HP Max Up"),
          Enemy.new("Spear Guard", id: "00", type: "Vanguard"),
          Enemy.new("Bone Archer", id: "01", type: "Range"),
          Enemy.new("Bone Archer", id: "02", type: ["Range", "Vanguard"]),
          ],
        "08-01-06", width: 3
        ),
      Rm.new("Albus Room", "Minera Prison Island", [
          Door.new(:left, "08-01-06"),
          Door.new(:right, "08-01-08"),
          Item.new("HP Max Up"),
          Enemy.new("The Creature", id: "02", type: ["Guard", "Vanguard"]),
          ],
        "08-01-07", width: 2
        ),
      Rm.new("Iron Maiden Room", "Minera Prison Island", [
          Door.new(:left, "08-01-07"),
          Door.new(:up, "08-01-0A", width: 3),
          Door.new(:right, "08-01-09"),
          Item.new("$500"),
          ],
        "08-01-08", width: 3
        ),
      Rm.new("Abram's Room", "Minera Prison Island", [
          Door.new(:left, "08-01-08"),
          ],
        "08-01-09", is_important: true
        ),
      Rm.new("Iron Maiden Room", "Minera Prison Island", [
          Door.new(:left, "08-01-0B"),
          Door.new(:down, "08-01-08", width: 3),
          Enemy.new("Invisible Man", id: "03", type: "Ambush"),
          Enemy.new("The Creature", id: "04", type: ["Guard", "Vanguard"]),
          ],
        "08-01-0A", width: 3
        ),
      Rm.new("Southeast Ascent", "Minera Prison Island", [
          Door.new(:right, "08-01-0C", height: 3),
          Door.new(:right, "08-01-0A"),
          Enemy.new("Bone Archer", id: "01", type: ["Range", "Vanguard", "Semi-Enclosed"]),
          Enemy.new("Bone Archer", id: "02", type: ["Range", "Vanguard", "Semi-Enclosed"]),
          Enemy.new("Bone Archer", id: "03", type: ["Range", "Platform", "Vanguard", "Enclosed"]),
          Enemy.new("Bone Archer", id: "04", type: ["Range", "Platform", "Semi-Enclosed"]),
          Enemy.new("Bone Archer", id: "05", type: ["Range", "Platform"]),
          ],
        "08-01-0B", height: 3
        ),
      Rm.new("East Loading", "Minera Prison Island", [
          Door.new(:left, "08-01-0B"),
          Door.new(:right, "08-02-00"),
          ],
        "08-01-0C", room_type: :loading
        ),
      ],[
      Rm.new("Northeast Ascent", "Minera Prison Island", [
          Door.new(:right, "08-02-01", "magnesFlight", height: 3),
          Door.new(:right, "08-02-02", height: 2),
          Door.new(:left, "08-01-0C"),
          Item.new("HEART Max Up", "magnesFlight"),
          Item.new("Konami Man", "magnesFlight"),
          Enemy.new("Spear Guard", id: "03", type: ["Vanguard", "Enclosed"]),
          ],
        "08-02-00", height: 3
        ),
      Rm.new("Northeast Cells", "Minera Prison Island", [
          Door.new(:left, "08-02-00"),
          Door.new(:right, "08-02-05"),
          Enemy.new("Demon", id: "01", type: ["Nuisance", "Enclosed", "WallR"]),
          Enemy.new("Spear Guard", id: "02", type: ["Vanguard", "Enclosed"]),
          Enemy.new("Spear Guard", id: "03", type: ["Vanguard", "Enclosed"]),
          Enemy.new("Spear Guard", id: "04", type: ["Challenger", "Enclosed"]),
          Enemy.new("Spear Guard", id: "05", type: ["Challenger", "Enclosed"]),
          Enemy.new("Spear Guard", id: "06", type: ["Vanguard", "Enclosed"]),
          Enemy.new("Spear Guard", id: "07", type: ["Vanguard", "Enclosed"]),
          Enemy.new("Spear Guard", id: "08", type: ["Vanguard", "Enclosed", "Wall"]),
          Enemy.new("Spear Guard", id: "09", type: ["Challenger", "Enclosed", "Wall"]),
          Enemy.new("Spear Guard", id: "0A", type: ["Challenger", "Enclosed", "Wall"]),
          Enemy.new("Spear Guard", id: "0B", type: ["Challenger", "Enclosed", "WallR"]),
          Enemy.new("Spear Guard", id: "0C", type: ["Challenger", "Enclosed", "WallR"]),
          Enemy.new("Spear Guard", id: "0D", type: ["Vanguard", "Enclosed", "WallR"]),
          ],
        "08-02-01", width: 4
        ),
      Rm.new("East Save", "Minera Prison Island", [
          Door.new(:left, "08-02-00"),
          ],
        "08-02-02", room_type: :save
        ),
      Rm.new("Electric Corridor", "Minera Prison Island", [
          Door.new(:right, "08-02-05"),
          Item.new("Vol Fulgur"),
          ],
        "08-02-03", width: 4
        ),
      Rm.new("East Teleporter", "Minera Prison Island", [
          Door.new(:right, "08-02-05"),
          ],
        "08-02-04", room_type: :teleporter
        ),
      Rm.new("East Lobby", "Minera Prison Island", [
          Door.new(:left, "08-02-01", "magnesFlight", height: 3),
          Door.new(:left, "08-02-04", height: 2),
          Door.new(:right, "08-02-06", height: 2),
          Door.new(:left, "08-02-03"),
          Item.new("Falcis"),
          Enemy.new("Bone Archer", id: "01", type: ["Range", "Platform", "Semi-Enclosed"]),
          Enemy.new("Bone Archer", id: "02", type: ["Range", "Vanguard", "Enclosed"]),
          ],
        "08-02-05", height: 3
        ),
      Rm.new("Robot Plaza", "Minera Prison Island", [
          Door.new(:left, "08-02-05"),
          Door.new(:right, "08-02-07"),
          Item.new("Strength Ring", "beatRobot"),
          Enemy.new("Tin Man", id: "01", type: ["Challenger", "Searchlight"]),
          Enemy.new("Demon", id: "02", type: ["Nuisance", "Vanguard"]),
          Enemy.new("Demon", id: "03", type: ["Nuisance", "Vanguard"]),
          ],
        "08-02-06", width: 5
        ),
      Rm.new("Exit", "Minera Prison Island", [
          Door.new(:left, "08-02-06"),
          Item.new("Glyph Sleeve"),
          ],
        "08-02-07", is_important: true
        ),
    ] ]
  end

  def self.manor_rooms
    manor_rooms = [ [
      Rm.new("Dark Room", "Mystery Manor", [
          Door.new(:right, "0E-00-01"),
          Item.new("Vol Umbra"),
          ],
        "0E-00-00", width: 4
        ),
      Rm.new("Albus Fork", "Mystery Manor", [
          Door.new(:left, "0E-00-00"),
          Door.new(:right, "0E-00-05"),
          Door.new(:up, "0E-00-03", subroom: "Bottom"),
          Enemy.new("White Fomor", id: "00", type: ["Nuisance", "Vanguard"]),
          Enemy.new("White Fomor", id: "01", type: ["Nuisance", "Vanguard"]),
          ],
        "0E-00-01", width: 2
        ),
      Rm.new("Schnitzel Room", "Mystery Manor", [
          Door.new(:right, "0E-00-03", subroom: "Top"),
          Item.new("Schnitzel"),
          Item.new("$2000"),
          Enemy.new("Flea Man", id: "03", type: ["Nuisance", "Floor", "Vanguard", "Platform", "Passthrough"]),
          Enemy.new("Flea Man", id: "04", type: ["Nuisance", "Floor", "Vanguard", "Platform", "Passthrough"]),
          Enemy.new("Flea Man", id: "05", type: ["Nuisance", "Floor", "Vanguard"]),
          ],
        "0E-00-02"
        ),
      Rm.new("West Stairs Top", "Mystery Manor", [
          Door.new(:left, "0E-00-02", "smallDistance"),
          Door.new(:right, "0E-00-04", "smallDistance"),
          Door.new(:down, "0E-00-03", subroom: "Bottom"),
          Enemy.new("Evil Force", id: "01", type: ["Seeker", "Platform", "Passthrough"])
          ],
        "0E-00-03", "West Stairs", width: 2
        ),
      Rm.new("West Stairs Bottom", "Mystery Manor", [
          Door.new(:right, "0E-00-08"),
          Door.new(:down, "0E-00-01"),
          Door.new(:up, "0E-00-03", "smallDistance", subroom: "Top"),
          Enemy.new("White Fomor", id: "02", type: ["Nuisance", "AirOnly", "Platform", "Passthrough"]),
          Enemy.new("White Fomor", id: "03", type: ["Nuisance", "Vanguard", "Platform", "Passthrough"]),
          Enemy.new("Mad Butcher", id: "04", type: ["Vanguard", "Enclosed"]),
          ],
        "0E-00-03", "West Stairs", width: 2
        ),
      Rm.new("North Connector", "Mystery Manor", [
          Door.new(:left, "0E-00-03", subroom: "Top"),
          Door.new(:right, "0E-00-06"),
          Enemy.new("White Fomor", id: "00", type: ["Nuisance", "Vanguard"]),
          Enemy.new("Evil Force", id: "01", type: ["Seeker", "Vanguard"])
          ],
        "0E-00-04", width: 2
        ),
      Rm.new("Boss Save", "Mystery Manor", [
          Door.new(:left, "0E-00-01"),
          Door.new(:right, "0E-00-09"),
          ],
        "0E-00-05", room_type: :save
        ),
      Rm.new("East Stairs Top", "Mystery Manor", [
          Door.new(:left, "0E-00-04", "smallDistance"),
          Door.new(:right, "0E-00-07", "smallDistance"),
          Door.new(:down, "0E-00-06", subroom: "Bottom"),
          ],
        "0E-00-06", "East Stairs", width: 2
        ),
      Rm.new("East Stairs Bottom", "Mystery Manor", [
          Door.new(:right, "0E-00-0A"),
          Door.new(:up, "0E-00-06", "smallDistance", subroom: "Top"),
          Enemy.new("Mad Butcher", id: "00", type: ["Vanguard", "Enclosed"]),
          Enemy.new("Mad Butcher", id: "01", type: "Vanguard"),
          Enemy.new("Mad Butcher", id: "02", type: ["Challenger", "Enclosed", "Platform"]),
          Enemy.new("Mad Butcher", id: "03", type: ["Challenger", "Enclosed", "Platform", "Separated"]),
          Enemy.new("Mimic", id: "04", type: ["Vangaurd", "Enclosed"]),
          ],
        "0E-00-06", "East Stairs", width: 2
        ),
      Rm.new("Flea Bank", "Mystery Manor", [
          Door.new(:left, "0E-00-06", subroom: "Top"),
          Item.new("$2000"),
          Enemy.new("Flea Man", id: "01", type: ["Nuisance", "Floor", "Vanguard", "Platform", "Passthrough"]),
          Enemy.new("Flea Man", id: "02", type: ["Nuisance", "Floor", "Vanguard"]),
          ],
        "0E-00-07"
        ),
      Rm.new("Interior Dead End", "Mystery Manor", [
          Door.new(:left, "0E-00-03", subroom: "Bottom"),
          Item.new("Gold Ore"),
          Enemy.new("White Fomor", id: "01", type: ["Nuisance", "Vanguard"]),
          Enemy.new("Evil Force", id: "02", type: ["Seeker", "Vanguard"]),
          Enemy.new("Evil Force", id: "03", type: "Seeker"),
          Enemy.new("Flea Man", id: "04", type: ["Nuisance", "Floor"]),
          ],
        "0E-00-08", width: 2
        ),
      Rm.new("Albus Room", "Mystery Manor", [
          Door.new(:left, "0E-00-05"),
          Item.new("Dominus Agony"),
          ],
        "0E-00-09", width: 2, room_req: "beatAlbus", is_important: true
        ),
      Rm.new("Entrance Connector", "Mystery Manor", [
          Door.new(:left, "0E-00-06", subroom: "Bottom"),
          Door.new(:right, "0E-00-0B"),
          Enemy.new("Flea Man", id: "00", type: ["Nuisance", "Floor", "Vanguard"]),
          ],
        "0E-00-0A"
        ),
      Rm.new("Front Door", "Mystery Manor", [
          Door.new(:left, "0E-00-0A"),
          Door.new(:right, "0E-00-0C"),
          Enemy.new("Mad Butcher", id: "00", type: "Vanguard"),
          Enemy.new("White Fomor", id: "01", type: ["Nuisance", "Vanguard"]),
          ],
        "0E-00-0B"
        ),
      Rm.new("Entrance", "Mystery Manor", [
          Door.new(:left, "0E-00-0B"),
          ],
        "0E-00-0C", room_type: :entrance, is_important: true
        ),
    ] ]
  end

  def self.tymeo_rooms
    tymeo_rooms = [ [
      Rm.new("Entrance", "Tymeo Mountains", [
          Door.new(:left, "0A-00-02"),
          Item.new("Blue Drops"),
          ],
        "0A-00-00", room_type: :entrance, is_important: true
        ),
      Rm.new("Entrance Save", "Tymeo Mountains", [
          Door.new(:left, "0A-00-02"),
          ],
        "0A-00-01", room_type: :save
        ),
      Rm.new("Entrance Climb", "Tymeo Mountains", [
          Door.new(:left, "0A-00-03", height: 3),
          Door.new(:right, "0A-00-01", height: 4),
          Door.new(:right, "0A-00-00"),
          Enemy.new("Black Crow", id: "00", type: ["Seeker", "Separated"]),
          Enemy.new("Black Crow", id: "01", type: ["Seeker", "Vanguard"]),
          Enemy.new("Black Crow", id: "02", type: ["Seeker", "Vanguard", "Semi-Enclosed"]),
          Enemy.new("Winged Guard", id: "03", type: ["Persistent", "Air", "Vanguard", "Semi-Enclosed"]),
          Enemy.new("Medusa Head", id: "07", type: ["Persistent", "Air", "Vanguard", "Semi-Enclosed", "Hardmode"]),
          ],
        "0A-00-02", height: 4
        ),
      Rm.new("Entrance Loading", "Tymeo Mountains", [
          Door.new(:left, "0A-01-00"),
          Door.new(:right, "0A-00-02")
          ],
        "0A-00-03", room_type: :loading
        ),
      Rm.new("Spikes Loading", "Tymeo Mountains", [
          Door.new(:left, "0A-01-02"),
          Door.new(:right, "0A-00-06")
          ],
        "0A-00-04", room_type: :loading
        ),
      Rm.new("Laura's Room", "Tymeo Mountains", [
          Door.new(:left, "0A-00-06"),
          ],
        "0A-00-05", is_important: true
        ),
      Rm.new("Post-Spikes Climb", "Tymeo Mountains", [
          Door.new(:left, "0A-00-07", height: 4),
          Door.new(:left, "0A-00-04"),
          Door.new(:right, "0A-00-05", height: 3),
          Door.new(:up, "0A-00-08"),
          Enemy.new("Winged Guard", id: "01", type: ["Persistent", "Air", "Ambush"]),
          Enemy.new("Rock Knight", id: "02", type: ["Guard", "Vanguard"]),
          Enemy.new("Black Crow", id: "03", type: ["Seeker", "Separated"]),
          Enemy.new("Black Crow", id: "04", type: ["Seeker", "Separated"]),
          Enemy.new("Black Crow", id: "05", type: ["Seeker", "Vanguard"]),
          Enemy.new("Black Crow", id: "06", type: ["Seeker", "Vanguard"]),
          Enemy.new("Medusa Head", id: "0D", type: ["Persistent", "Air", "Vanguard", "Hardmode"]),
          ],
        "0A-00-06", height: 4
        ),
      Rm.new("West Teleporter", "Tymeo Mountains", [
          Door.new(:right, "0A-00-06")
          ],
        "0A-00-07", room_type: :teleporter
        ),
      Rm.new("Northwest Hub", "Tymeo Mountains", [
          Door.new(:left, "0A-00-09", height: 2),
          Door.new(:right, "0A-00-0B", "tymeoJump", height: 2),
          Door.new(:down, "0A-00-06"),
          Enemy.new("Winged Guard", id: "00", type: ["Persistent", "Air", "Offscreen"]),
          ],
        "0A-00-08", height: 2
        ),
      Rm.new("Northwest Underground", "Tymeo Mountains", [
          Door.new(:left, "0A-00-0A", height: 2),
          Door.new(:right, "0A-00-08"),
          Item.new("MP Max Up"),
          Item.new("Fides Fio"),
          Enemy.new("Skull Spider", id: "02", type: ["Vanguard", "Enclosed"]),
          Enemy.new("Skull Spider", id: "03", type: ["Vanguard", "Enclosed"]),
          Enemy.new("Skull Spider", id: "04", type: ["Challenger", "Enclosed", "Separated"]),
          Enemy.new("Skull Spider", id: "05", type: ["Challenger", "Enclosed", "Separated"]),
          Enemy.new("Skull Spider", id: "06", type: ["Challenger", "Enclosed", "Separated"]),
          Enemy.new("Skull Spider", id: "07", type: ["Challenger", "Enclosed", "Separated"]),
          Enemy.new("Black Crow", id: "08", type: ["Seeker", "Platform", "Passthrough"]),
          Enemy.new("Black Crow", id: "09", type: ["Seeker", "Platform"]),
          Enemy.new("Cave Troll", id: "0F", type: ["Threat", "Vanguard", "Hardmode"]),
          ],
        "0A-00-09", width: 3, height: 2
        ),
      Rm.new("West Exit", "Tymeo Mountains", [
          Door.new(:right, "0A-00-09")
          ],
        "0A-00-0A", is_important: true
        ),
      Rm.new("East Fork Entry", "Tymeo Mountains", [
          Door.new(:left, "0A-00-08"),
          Door.new(:right, "0A-00-0C", subroom: "Left", height: 2),
          Enemy.new("Skull Spider", id: "01", type: ["Vanguard", "Enclosed", "Platform"]),
          Enemy.new("Skull Spider", id: "02", type: ["Vanguard", "Semi-Enclosed"]),
          Enemy.new("Skull Spider", id: "03", type: ["Challenger", "Enclosed"]),
          Enemy.new("Skull Spider", id: "04", type: ["Challenger", "Enclosed", "Separated"]),
          Enemy.new("Skull Spider", id: "05", type: ["Challenger", "Enclosed", "Separated"]),
          Enemy.new("Owl", id: "0B", type: ["Nuisance", "Vanguard", "Platform", "Passthrough", "Hardmode"]),
          ],
        "0A-00-0B", width: 3, height: 2
        ),
      Rm.new("Paries Underground Left", "Tymeo Mountains", [
          Door.new(:left, "0A-00-0B"),
          Door.new(:right, "0A-00-0C", subroom: "Top", height: 2),
          Door.new(:right, "0A-00-0C", false, subroom: "Bottom"),
          Enemy.new("Black Crow", id: "0C", type: ["Seeker", "Platform", "Passthrough"]),
          ],
        "0A-00-0C", "Paries Underground", height: 3
        ),
      Rm.new("Paries Underground Top", "Tymeo Mountains", [
          Door.new(:left, "0A-00-0C", subroom: "Left"),
          Door.new(:right, "0A-00-0D", height: 2),
          Door.new(:down, "0A-00-0C", false, subroom: "Bottom"),
          Enemy.new("Black Crow", id: "0C", type: ["Seeker", "Platform", "Passthrough"]),
          Enemy.new("Black Crow", id: "0D", type: ["Seeker", "Platform", "Passthrough", "Separated", "Semi-Enclosed"]),
          Enemy.new("Black Crow", id: "0E", type: ["Seeker", "Platform", "Passthrough", "Separated", "Semi-Enclosed"]),
          Enemy.new("Black Crow", id: "0F", type: ["Seeker", "Vanguard", "Platform", "Passthrough", "Semi-Enclosed"]),
          Enemy.new("Black Crow", id: "10", type: ["Seeker", "Vanguard", "Semi-Enclosed"]),
          Enemy.new("Black Crow", id: "11", type: ["Seeker", "Platform", "Passthrough", "Semi-Enclosed"]),
          Enemy.new("Black Crow", id: "12", type: ["Seeker", "Platform", "Passthrough", "Semi-Enclosed"]),
          Enemy.new("Scarecrow", id: "13", type: ["Nuisance", "Floor", "Semi-Enclosed"]),
          ],
        "0A-00-0C", "Paries Underground", width: 3, height: 2
        ),
      Rm.new("Paries Underground Bottom", "Tymeo Mountains", [
          Door.new(:left, "0A-00-0C", false, subroom: "Left"),
          Door.new(:up, "0A-00-0C", false, subroom: "Top"),
          Door.new(:right, "0A-00-0E"),
          Item.new("Devil Ring", "Paries"),
          Item.new("Moonwalkers", "Paries"),
          Item.new("Crimson Mask"),
          ],
        "0A-00-0C", "Paries Underground", width: 3
        ),
      Rm.new("North-Central Hub", "Tymeo Mountains", [
          Door.new(:left, "0A-00-0C", "smallDistance", subroom: "Top", height: 2),
          Door.new(:right, "0A-00-10", height: 2),
          Door.new(:down, "0A-00-0E"),
          Enemy.new("Rock Knight", id: "05", type: ["Range", "Vanguard"]),
          ],
        "0A-00-0D", height: 2
        ),
      Rm.new("Central Ladders", "Tymeo Mountains", [
          Door.new(:up, "0A-00-0D"),
          Door.new(:right, "0A-00-0F"),
          Door.new(:left, "0A-00-0C", subroom: "Bottom", height: 4),
          Enemy.new("Rock Knight", id: "06", type: ["Range", "Vanguard"]),
          Enemy.new("Yeti", id: "07", type: ["Nuisance", "Separated"]),
          Enemy.new("Rock Knight", id: "08", type: ["Range", "Separated"]),
          Enemy.new("Rock Knight", id: "09", type: ["Range", "Vanguard"]),
          ],
        "0A-00-0E", height: 4
        ),
      Rm.new("Central Loading", "Tymeo Mountains", [
          Door.new(:left, "0A-00-0E"),
          Door.new(:right, "0A-01-04")
          ],
        "0A-00-0F", room_type: :loading
        ),
      Rm.new("Demon Underground", "Tymeo Mountains", [
          Door.new(:left, "0A-00-0D"),
          Door.new(:right, "0A-00-11", height: 2),
          Item.new("HEART Max Up"),
          Enemy.new("Fire Demon", id: "01", type: ["Nuisance", "Vanguard", "Enclosed"]),
          Enemy.new("Bone Pillar", id: "02", type: ["Guard", "Enclosed", "Separated"]),
          Enemy.new("Skull Spider", id: "03", type: ["Challenger", "Enclosed", "Separated"]),
          Enemy.new("Skull Spider", id: "04", type: ["Challenger", "Enclosed"]),
          Enemy.new("Bat", id: "05", type: ["Nuisance", "Vanguard", "Enclosed"]),
          Enemy.new("Bat", id: "06", type: ["Nuisance", "Vanguard", "Enclosed"]),
          ],
        "0A-00-10", width: 3, height: 2
        ),
      Rm.new("Northeast Underground", "Tymeo Mountains", [
          Door.new(:left, "0A-00-10"),
          Door.new(:right, "0A-00-12", height: 3),
          Item.new("Emperor Ring"),
          Enemy.new("Cave Troll", id: "03", type: ["Threat", "Platform"]),
          Enemy.new("Scarecrow", id: "04", type: ["Nuisance", "Floor", "Vanguard", "Semi-Enclosed"]),
          Enemy.new("Scarecrow", id: "05", type: ["Nuisance", "Floor", "Semi-Enclosed"]),
          Enemy.new("Scarecrow", id: "06", type: ["Nuisance", "Floor", "Semi-Enclosed"]),
          Enemy.new("Skeleton Hero", id: "07", type: ["Range", "Semi-Enclosed"]),
          Enemy.new("Dullahan", id: "08", type: ["Challenger", "Enclosed"]),
          Enemy.new("Dullahan", id: "09", type: ["Challenger", "Enclosed"]),
          Enemy.new("Black Crow", id: "0A", type: ["Seeker", "Vanguard", "Platform", "Passthrough"]),
          Enemy.new("Black Crow", id: "0B", type: ["Seeker", "Platform", "Passthrough"]),
          Enemy.new("Black Crow", id: "0C", type: ["Seeker", "Platform", "Passthrough"]),
          Enemy.new("Black Crow", id: "0D", type: ["Seeker", "Platform", "Semi-Enclosed"]),
          Enemy.new("Black Crow", id: "0E", type: ["Seeker", "Platform", "Passthrough"]),
          Enemy.new("Bat", id: "0F", type: ["Nuisance", "Vanguard", "Enclosed"]),
          Enemy.new("Bat", id: "10", type: ["Nuisance", "Enclosed"]),
          ],
        "0A-00-11", width: 4, height: 3
        ),
      Rm.new("Northeast Hub", "Tymeo Mountains", [
          Door.new(:left, "0A-00-11", "highJump", height: 2),
          Door.new(:right, "0A-00-13", "highJump", height: 2),
          Door.new(:down, "0A-00-14"),
          Enemy.new("Black Crow", id: "02", type: ["Seeker", "Vanguard"]),
          ],
        "0A-00-12", height: 2
        ),
      Rm.new("East Exit", "Tymeo Mountains", [
          Door.new(:left, "0A-00-12"),
          ],
        "0A-00-13", is_important: true
        ),
      Rm.new("Northeast Ladders", "Tymeo Mountains", [
          Door.new(:up, "0A-00-12"),
          Door.new(:right, "0A-00-16"),
          Door.new(:left, "0A-00-15", height: 3),
          Enemy.new("Winged Guard", id: "02", type: ["Persistent", "Air", "Offscreen"]),
          ],
        "0A-00-14", height: 4
        ),
      Rm.new("East Save", "Tymeo Mountains", [
          Door.new(:right, "0A-00-14"),
          ],
        "0A-00-15", room_type: :save
        ),
      Rm.new("East Loading", "Tymeo Mountains", [
          Door.new(:left, "0A-00-14"),
          Door.new(:right, "0A-01-08"),
          ],
        "0A-00-16", room_type: :loading
        ),
      ],[
      Rm.new("Stalactite Room", "Tymeo Mountains", [
          Door.new(:up, "0A-01-01"),
          Door.new(:right, "0A-00-03"),
          Enemy.new("Rock Knight", id: "0B", type: ["Guard", "Vanguard"]),
          Enemy.new("Rock Knight", id: "0C", type: ["Guard", "Vanguard"]),
          Enemy.new("Nightmare", id: "0D", type: ["Nuisance", "Floor"]),
          ],
        "0A-01-00", width: 4
        ),
      Rm.new("Spider Ascent", "Tymeo Mountains", [
          Door.new(:left, "0A-01-03", height: 2),
          Door.new(:right, "0A-01-02", height: 3),
          Door.new(:down, "0A-01-00"),
          Item.new("Mushroom"),
          Enemy.new("Skull Spider", id: "02", type: ["Challenger", "Enclosed", "Separated", "Platform"]),
          Enemy.new("Skull Spider", id: "03", type: ["Challenger", "Enclosed", "Platform"]),
          ],
        "0A-01-01", height: 3
        ),
      Rm.new("Spike Room", "Tymeo Mountains", [
          Door.new(:left, "0A-01-01"),
          Door.new(:right, "0A-00-04"),
          Enemy.new("Medusa Head", id: "07", type: ["Persistent", "Air", "Offscreen", "Hardmode"]),
          ],
        "0A-01-02", room_req: "magnesFlight", width: 3
        ),
      Rm.new("Empress Room", "Tymeo Mountains", [
          Door.new(:right, "0A-01-01"),
          Item.new("Empress Ring"),
          ],
        "0A-01-03"
        ),
      Rm.new("West Cave Entry", "Tymeo Mountains", [
          Door.new(:left, "0A-00-0F"),
          Door.new(:right, "0A-01-05"),
          Door.new(:up, "0A-01-06", width: 4),
          Enemy.new("Nightmare", id: "09", type: ["Nuisance", "Floor"]),
          Enemy.new("Nightmare", id: "0A", type: ["Nuisance", "Floor", "Vanguard"]),
          Enemy.new("Fire Demon", id: "0B", type: "Nuisance"),
          ],
        "0A-01-04", width: 4
        ),
      Rm.new("East Teleporter", "Tymeo Mountains", [
          Door.new(:left, "0A-01-05"),
          ],
        "0A-01-05", room_type: :teleporter
        ),
      Rm.new("Pneuma Hub", "Tymeo Mountains", [
          Door.new(:left, "0A-01-09"),
          Door.new(:right, "0A-01-07"),
          Door.new(:down, "0A-01-04"),
          Enemy.new("Nightmare", id: "06", type: ["Nuisance", "Floor", "Vanguard"]),
          Enemy.new("Nightmare", id: "07", type: ["Nuisance", "Floor", "Vanguard"]),
          ],
        "0A-01-06", width: 3
        ),
      Rm.new("Demon Cave", "Tymeo Mountains", [
          Door.new(:left, "0A-01-06"),
          Door.new(:right, "0A-01-08"),
          Enemy.new("Fire Demon", id: "03", type: ["Nuisance", "Vanguard"]),
          Enemy.new("Fire Demon", id: "04", type: ["Nuisance", "Vanguard"]),
          ],
        "0A-01-07", width: 2
        ),
      Rm.new("Spider Descent", "Tymeo Mountains", [
          Door.new(:left, "0A-00-16", "highJump", height: 3),
          Door.new(:left, "0A-01-07"),
          Item.new("HP Max Up"),
          Item.new("Ruby"),
          Enemy.new("Skull Spider", id: "06", type: ["Challenger", "Enclosed", "Separated", "Platform"]),
          Enemy.new("Skull Spider", id: "07", type: ["Challenger", "Enclosed", "Separated", "Platform"]),
          ],
        "0A-01-08", height: 3
        ),
      Rm.new("Wind Room", "Tymeo Mountains", [
          Door.new(:right, "0A-01-06"),
          Item.new("Pneuma"),
          ],
        "0A-01-09", height: 3
        ),
    ] ]
  end

  def self.kalidus_rooms
    kalidus_rooms = [ [
      Rm.new("Upper Entrance", "Kalidus Channel", [
          Door.new(:right, "06-00-01"),
          ],
        "06-00-00", room_type: :entrance, is_important: true
        ),
      Rm.new("Shallows Far Left", "Tymeo Mountains", [
          Door.new(:left, "06-00-00", height: 2),
          Door.new(:right, "06-00-02", height: 2),
          Door.new(:right, "06-00-02", "underwater"),
          Item.new("HEART Max Up", "underwater"),
          Enemy.new("Needles", id: "0A", type: ["Guard", "Air", "Water"]),
          Enemy.new("Nominon", id: "0B", type: ["Nuisance", "Vanguard", "Platform", "Passthrough"]),
          Enemy.new("Killer Fish", id: "0C", type: "Nuisance"),
          ],
        "06-00-01", width: 2, height: 2
        ),
      Rm.new("Shallows Mid Left", "Tymeo Mountains", [
          Door.new(:left, "06-00-01", height: 2),
          Door.new(:left, "06-00-01", "underwater"),
          Door.new(:right, "06-00-03", height: 2),
          Door.new(:right, "06-00-03", "underwater"),
          Door.new(:down, "06-00-0C", false, width: 2),
          Item.new("Chamomile", "underwater"),
          Enemy.new("Needles", id: "0F", type: ["Guard", "Air", "Water", "Platform", "Vanguard"]),
          Enemy.new("Needles", id: "10", type: ["Guard", "Air", "Water", "Platform"]),
          Enemy.new("Needles", id: "11", type: ["Guard", "Air", "Water", "Platform"]),
          Enemy.new("Needles", id: "12", type: ["Guard", "Air", "Water"]),
          Enemy.new("Needles", id: "13", type: ["Guard", "Air", "Water"]),
          Enemy.new("Needles", id: "14", type: ["Guard", "Air", "Water", "Platform"]),
          Enemy.new("Needles", id: "15", type: ["Guard", "Air", "Water", "Platform"]),
          Enemy.new("Merman", id: "16", type: ["Challenger", "Air", "Water", "Platform"]),
          Enemy.new("Merman", id: "17", type: ["Challenger", "Air", "Water"]),
          Enemy.new("Merman", id: "18", type: ["Challenger", "Air", "Water", "Platform"]),
          ],
        "06-00-02", width: 3, height: 2
        ),
      Rm.new("Shallows Near Left", "Tymeo Mountains", [
          Door.new(:left, "06-00-02", height: 2),
          Door.new(:left, "06-00-02", "underwater"),
          Door.new(:right, "06-00-04", height: 2),
          Enemy.new("Needles", id: "0D", type: ["Guard", "Air", "Water", "Platform", "Vanguard"]),
          Enemy.new("Needles", id: "0E", type: ["Guard", "Air", "Water", "Platform", "Vanguard"]),
          Enemy.new("Needles", id: "0F", type: ["Guard", "Air", "Water", "Platform"]),
          Enemy.new("Needles", id: "10", type: ["Guard", "Air", "Water"]),
          Enemy.new("Needles", id: "11", type: ["Guard", "Air", "Water", "Platform"]),
          Enemy.new("Needles", id: "12", type: ["Guard", "Air", "Water"]),
          Enemy.new("Merman", id: "13", type: ["Challenger", "Air", "Water", "Platform"]),
          Enemy.new("Merman", id: "14", type: ["Challenger", "Air", "Water", "Platform"]),
          Enemy.new("Sea Stinger", id: "15", type: ["Persistent", "Air", "Water"]),
          Enemy.new("Merman", id: "16", type: ["Challenger", "Air", "Water"]),
          ],
        "06-00-03", width: 3, height: 2
        ),
      Rm.new("Jacob's Room", "Kalidus Channel", [
          Door.new(:left, "06-00-03"),
          Door.new(:right, "06-00-05"),
          ],
        "06-00-04", is_important: true
        ),
      Rm.new("Upper Save", "Kalidus Channel", [
          Door.new(:left, "06-00-04"),
          Door.new(:right, "06-00-06"),
          ],
        "06-00-05", room_type: :save
        ),
      Rm.new("East Dry Corridor", "Kalidus Channel", [
          Door.new(:left, "06-00-05"),
          Door.new(:right, "06-00-07"),
          ],
        "06-00-06"
        ),
      Rm.new("Shallows Near Right", "Tymeo Mountains", [
          Door.new(:left, "06-00-06", height: 2),
          Door.new(:right, "06-00-08", height: 2),
          Door.new(:right, "06-00-08", "underwater"),
          Item.new("MP Max Up", "underwater"),
          Enemy.new("Merman", id: "0E", type: ["Challenger", "Air", "Water"]),
          Enemy.new("Merman", id: "0F", type: ["Challenger", "Air", "Water", "Platform"]),
          Enemy.new("Sea Stinger", id: "10", type: ["Persistent", "Air", "Water", "Platform"]),
          Enemy.new("Merman", id: "11", type: ["Challenger", "Air", "Water"]),
          ],
        "06-00-07", width: 3, height: 2
        ),
      Rm.new("Shallows Mid Right", "Tymeo Mountains", [
          Door.new(:left, "06-00-07", height: 2),
          Door.new(:left, "06-00-07", "underwater"),
          Door.new(:right, "06-00-09", height: 2),
          Door.new(:right, "06-00-09", "underwater"),
          Door.new(:down, "06-00-14", false, width: 2),
          Enemy.new("Merman", id: "0B", type: ["Challenger", "Air", "Water", "Platform"]),
          Enemy.new("Merman", id: "0C", type: ["Challenger", "Air", "Water"]),
          Enemy.new("Sea Stinger", id: "0D", type: ["Persistent", "Air", "Water"]),
          Enemy.new("Merman", id: "0E", type: ["Challenger", "Air", "Water", "Platform"]),
          ],
        "06-00-08", width: 3, height: 2
        ),
      Rm.new("Shallows Far Right", "Tymeo Mountains", [
          Door.new(:left, "06-00-08", height: 2),
          Door.new(:left, "06-00-08", "underwater"),
          Door.new(:right, "06-00-0A", height: 2),
          Item.new("HP Max Up", "underwater"),
          Enemy.new("Merman", id: "06", type: ["Vanguard", "Air", "Water", "Platform"]),
          ],
        "06-00-09", width: 2, height: 2
        ),
      Rm.new("Upper Exit", "Kalidus Channel", [
          Door.new(:left, "06-00-09"),
          ],
        "06-00-0A", is_important: true
        ),
      Rm.new("West Teleporter", "Kalidus Channel", [
          Door.new(:right, "06-00-0C", "underwater"),
          ],
        "06-00-0B", room_type: :teleporter
        ),
      Rm.new("West Balloon", "Kalidus Channel", [
          Door.new(:left, "06-00-0B", height: 3),
          Door.new(:right, "06-00-0D"),
          Door.new(:up, "06-00-02"),
          Enemy.new("Gelso", id: "02", type: ["Persistent", "Air", "Offscreen"]),
          Enemy.new("Needles", id: "03", type: ["Guard", "Air", "Enclosed"]),
          Enemy.new("Needles", id: "04", type: ["Guard", "Air", "Vanguard", "Semi-Enclosed"]),
          Enemy.new("Needles", id: "05", type: ["Guard", "Air", "AirOnly"]),
          Enemy.new("Needles", id: "06", type: ["Guard", "Air", "AirOnly"]),
          ],
        "06-00-0C", room_req: "underwater", height: 3
        ),
      Rm.new("West Pre-Balloon", "Kalidus Channel", [
          Door.new(:left, "06-00-0C"),
          Door.new(:right, "06-00-0E", height: 3),
          Door.new(:right, "06-00-0E", height: 2),
          Door.new(:right, "06-00-0E"),
          Item.new("Fortis Fio"),
          Enemy.new("Merman", id: "02", type: "Range"),
          Enemy.new("Merman", id: "03", type: "Range"),
          Enemy.new("Merman", id: "04", type: "Range"),
          Enemy.new("Merman", id: "05", type: ["Range", "Vanguard"]),
          Enemy.new("Dark Octopus", id: "06", type: ["Guard", "Enclosed", "Separated"]),
          Enemy.new("Dark Octopus", id: "07", type: ["Guard", "Enclosed", "Separated"]),
          Enemy.new("Fishhead", id: "08", type: ["Guard", "Vanguard"]),
          Enemy.new("Needles", id: "09", type: ["Guard", "Air", "Semi-Enclosed", "Vanguard", "Platform"]),
          Enemy.new("Needles", id: "0A", type: ["Guard", "Air", "Enclosed", "Ambush"]),
          ],
        "06-00-0D", room_req: "underwater", width: 2, height: 3
        ),
      Rm.new("West Hub", "Kalidus Channel", [
          Door.new(:left, "06-00-0D", height: 3),
          Door.new(:left, "06-00-0D", height: 2),
          Door.new(:left, "06-00-0D"),
          Door.new(:right, "06-00-11"),
          Door.new(:down, "06-00-10"),
          Enemy.new("Gelso", id: "00", type: ["Seeker", "AirOnly"]),
          Enemy.new("Needles", id: "01", type: ["Guard", "Air", "Enclosed"]),
          ],
        "06-00-0E", room_req: "underwater", height: 3
        ),
      Rm.new("West Jellyfish", "Kalidus Channel", [
          Door.new(:left, "06-01-02"),
          Door.new(:right, "06-00-10"),
          Enemy.new("Forneus", id: "01", type: "Nuisance"),
          Enemy.new("Forneus", id: "02", type: ["Nuisance", "Vanguard", "Semi-Enclosed"]),
          Enemy.new("Fishhead", id: "03", type: ["Guard", "Enclosed"]),
          Enemy.new("Needles", id: "04", type: ["Guard", "Air", "Vanguard"]),
          Enemy.new("Needles", id: "05", type: ["Guard", "Air", "Enclosed"]),
          Enemy.new("Needles", id: "06", type: ["Guard", "Air", "Enclosed", "Ambush"]),
          Enemy.new("Gelso", id: "07", type: ["Seeker", "Platform"]),
          Enemy.new("Gelso", id: "08", type: ["Seeker", "Vanguard"]),
          ],
        "06-00-0F", room_req: "underwater", width: 3, height: 2
        ),
      Rm.new("Scutum Room", "Kalidus Channel", [
          Door.new(:left, "06-00-0F"),
          Door.new(:up, "06-00-0E"),
          Item.new("Scutum"),
          Enemy.new("Merman", id: "01", type: ["Range", "Platform"]),
          Enemy.new("Needles", id: "02", type: ["Guard", "Enclosed", "Separated"]),
          Enemy.new("Needles", id: "03", type: ["Guard", "Enclosed", "Separated"]),
          Enemy.new("Needles", id: "04", type: ["Guard", "Air", "Enclosed", "Separated"]),
          ],
        "06-00-10", room_req: "underwater", height: 2
        ),
      Rm.new("Lower Save", "Kalidus Channel", [
          Door.new(:left, "06-00-0E"),
          Door.new(:right, "06-00-12"),
          ],
        "06-00-11", room_type: :save, room_req: "underwater"
        ),
      Rm.new("Lower Connector", "Kalidus Channel", [
          Door.new(:left, "06-00-11"),
          Door.new(:right, "06-00-13"),
          Enemy.new("Gelso", id: "01", type: "Seeker"),
          Enemy.new("Gelso", id: "02", type: "Seeker"),
          Enemy.new("Forneus", id: "03", type: "Nuisance"),
          Enemy.new("Gelso", id: "04", type: "Seeker"),
          Enemy.new("Gelso", id: "05", type: "Seeker"),
          ],
        "06-00-12", room_req: "underwater", width: 4
        ),
      Rm.new("East Hub", "Kalidus Channel", [
          Door.new(:left, "06-00-14", height: 3),
          Door.new(:left, "06-00-16", height: 2),
          Door.new(:right, "06-00-13"),
          Enemy.new("Fishhead", id: "01", type: ["Range", "Enclosed", "Platform"]),
          Enemy.new("Dark Octopus", id: "02", type: ["Guard", "Enclosed", "Separated"]),
          Enemy.new("Dark Octopus", id: "03", type: ["Guard", "Enclosed", "Separated"]),
          Enemy.new("Needles", id: "04", type: ["Guard", "Air", "Enclosed", "Platform"]),
          Enemy.new("Needles", id: "05", type: ["Guard", "Air", "Vanguard", "AirOnly"]),
          ],
        "06-00-13", room_req: "underwater", height: 3
        ),
      Rm.new("East Balloon", "Kalidus Channel", [
          Door.new(:left, "06-00-13"),
          Door.new(:right, "06-00-15"),
          Door.new(:up, "06-00-08"),
          Enemy.new("Gelso", id: "00", type: ["Persistent", "Air"]),
          ],
        "06-00-14", room_req: "underwater", width: 3
        ),
      Rm.new("East Balloon Treasure", "Kalidus Channel", [
          Door.new(:left, "06-00-14"),
          Item.new("MP Max Up"),
          Item.new("HP Max Up"),
          Item.new("HEART Max Up"),
          ],
        "06-00-15", room_req: "underwater"
        ),
      Rm.new("Octopus Connector", "Kalidus Channel", [
          Door.new(:left, "06-00-13"),
          Door.new(:right, "06-00-17"),
          Enemy.new("Dark Octopus", id: "00", type: ["Guard", "Enclosed", "Separated"]),
          Enemy.new("Dark Octopus", id: "01", type: ["Guard", "Enclosed", "Separated"]),
          Enemy.new("Dark Octopus", id: "02", type: ["Guard", "Enclosed", "Separated"]),
          Enemy.new("Dark Octopus", id: "03", type: ["Guard", "Enclosed", "Separated"]),
          ],
        "06-00-16", room_req: "underwater", width: 3
        ),
      Rm.new("East Bone Tower", "Kalidus Channel", [
          Door.new(:left, "06-00-16", height: 3),
          Door.new(:left, "06-00-18", height: 2),
          Door.new(:left, "06-00-1A"),
          Enemy.new("Fishhead", id: "01", type: ["Range", "Vanguard"]),
          Enemy.new("Fishhead", id: "02", type: ["Range", "Platform"]),
          Enemy.new("Needles", id: "03", type: ["Guard", "Vanguard"]),
          Enemy.new("Gelso", id: "04", type: ["Seeker", "AirOnly", "Vanguard"]),
          Enemy.new("Gelso", id: "05", type: ["Seeker", "AirOnly", "Vanguard"]),
          ],
        "06-00-17", room_req: "underwater", height: 3
        ),
      Rm.new("East HP Room", "Kalidus Channel", [
          Door.new(:right, "06-00-17"),
          Item.new("HP Max Up"),
          Enemy.new("Sea Demon", id: "01", type: "Nuisance"),
          Enemy.new("Merman", id: "02", type: "Challenger"),
          Enemy.new("Fishhead", id: "03", type: ["Guard", "Semi-Enclosed"]),
          ],
        "06-00-18", room_req: "underwater", width: 3
        ),
      Rm.new("Southeast Bend", "Kalidus Channel", [
          Door.new(:right, "06-00-1A", height: 3),
          Door.new(:right, "06-01-06"),
          Enemy.new("Dark Octopus", id: "00", type: ["Guard", "Enclosed", "Separated"]),
          Enemy.new("Killer Fish", id: "01", type: ["Nuisance", "Vanguard"]),
          Enemy.new("Killer Fish", id: "02", type: ["Nuisance", "Platform"]),
          Enemy.new("Needles", id: "03", type: ["Guard", "Air", "Enclosed"]),
          ],
        "06-00-19", room_req: "underwater", height: 3
        ),
      Rm.new("Anti-Venom Room", "Kalidus Channel", [
          Door.new(:left, "06-00-19", height: 2),
          Door.new(:right, "06-00-17", height: 2),
          Door.new(:right, "06-00-1B"),
          Item.new("HEART Max Up"),
          Item.new("Anti-Venom"),
          Enemy.new("Needles", id: "03", type: ["Guard", "Air", "Semi-Enclosed"]),
          Enemy.new("Needles", id: "04", type: ["Guard", "Enclosed"]),
          Enemy.new("Needles", id: "05", type: ["Guard", "Enclosed"]),
          Enemy.new("Dark Octopus", id: "06", type: ["Guard", "Enclosed"]),
          Enemy.new("Dark Octopus", id: "07", type: ["Guard", "Enclosed"]),
          Enemy.new("Fishhead", id: "08", type: ["Guard", "Enclosed", "WallR"]),
          Enemy.new("Merman", id: "09", type: ["Vanguard", "Semi-Enclosed"]),
          Enemy.new("Merman", id: "0A", type: ["Vanguard", "Semi-Enclosed"]),
          Enemy.new("Killer Fish", id: "0B", type: ["Nuisance", "Platform"]),
          ],
        "06-00-1A", room_req: "underwater", width: 3, height: 2
        ),
      Rm.new("East Teleporter", "Kalidus Channel", [
          Door.new(:left, "06-00-1A"),
          ],
        "06-00-1B", room_type: :teleporter, room_req: "underwater"
        ),
      ],[
      Rm.new("Lower Exit", "Kalidus Channel", [
          Door.new(:right, "06-01-01"),
          ],
        "06-01-00", is_important: true, room_req: "underwater"
        ),
      Rm.new("Southwest Lobby", "Kalidus Channel", [
          Door.new(:left, "06-01-00"),
          Door.new(:right, "06-01-02", height: 2),
          Door.new(:right, "06-01-03"),
          Item.new("Iron Ore"),
          Enemy.new("Sea Demon", id: "01", type: ["Nuisance", "Platform", "AirOnly"]),
          Enemy.new("Sea Demon", id: "02", type: "Nuisance"),
          Enemy.new("Needles", id: "05", type: ["Guard", "Air", "Enclosed"]),
          Enemy.new("Gelso", id: "06", type: ["Seeker", "Vanguard"]),
          Enemy.new("Gelso", id: "07", type: ["Seeker", "AirOnly"]),
          ],
        "06-01-01", room_req: "underwater", width: 3, height: 2
        ),
      Rm.new("Southwest Loading", "Kalidus Channel", [
          Door.new(:left, "06-01-01"),
          Door.new(:right, "06-00-0F"),
          ],
        "06-01-02", room_type: :loading, room_req: "underwater"
        ),
      Rm.new("Southwest Octopi", "Kalidus Channel", [
          Door.new(:left, "06-01-01"),
          Door.new(:right, "06-01-04", subroom: "Top"),
          Enemy.new("Dark Octopus", id: "00", type: ["Guard", "Enclosed", "Vanguard"]),
          Enemy.new("Dark Octopus", id: "01", type: ["Guard", "Enclosed", "Vanguard"]),
          Enemy.new("Dark Octopus", id: "02", type: ["Guard", "Enclosed", "Vanguard"]),
          ],
        "06-01-03", room_req: "underwater", width: 2
        ),
      Rm.new("Ship Top", "Kalidus Channel", [
          Door.new(:left, "06-01-03"),
          Door.new(:down, "06-01-04", subroom: "Bottom", width: 4),
          Enemy.new("Killer Fish", id: "0A", type: ["Nuisance", "Floor", "Enclosed", "Separated"]),
          Enemy.new("Killer Fish", id: "0B", type: "Nuisance"),
          Enemy.new("Killer Fish", id: "0C", type: ["Nuisance", "Semi-Enclosed"]),
          Enemy.new("Needles", id: "0D", type: ["Guard", "Air", "Semi-Enclosed"]),
          ],
        "06-01-04", "Ship", room_req: "underwater", width: 4
        ),
      Rm.new("Ship Bottom", "Kalidus Channel", [
          Door.new(:up, "06-01-04", subroom: "Bottom", width: 4),
          Door.new(:right, "06-01-05"),
          Item.new("$1000"),
          Item.new("$1000"),
          Item.new("$1000"),
          Item.new("MP Max Up"),
          Item.new("Emerald"),
          Item.new("Magician Ring"),
          Enemy.new("Merman", id: "0E", type: ["Challenger", "Enclosed", "Separated", "Wall"]),
          Enemy.new("Merman", id: "0F", type: ["Challenger", "Enclosed", "Separated"]),
          Enemy.new("Skull Spider", id: "10", type: ["Challenger", "Enclosed"]),
          Enemy.new("Specter", id: "11", type: ["Nuisance", "Semi-Enclosed"]),
          ],
        "06-01-04", "Ship", width: 4, height: 2
        ),
      Rm.new("Monica's Room", "Kalidus Channel", [
          Door.new(:left, "06-01-04", subroom: "Bottom"),
          ],
        "06-01-05", is_important: true
        ),
      Rm.new("Southeast Loading", "Kalidus Channel", [
          Door.new(:left, "06-00-19"),
          Door.new(:right, "06-01-07"),
          ],
        "06-01-06", room_type: :loading, room_req: "underwater"
        ),
      Rm.new("Southeast Lobby", "Kalidus Channel", [
          Door.new(:left, "06-01-06", height: 2),
          Door.new(:right, "06-01-08", height: 2),
          Item.new("Potion"),
          Enemy.new("Merman", id: "01", type: ["Range", "Separated"]),
          Enemy.new("Merman", id: "02", type: ["Range", "Separated"]),
          Enemy.new("Merman", id: "03", type: ["Range", "Separated"]),
          Enemy.new("Merman", id: "04", type: ["Range", "Separated"]),
          Enemy.new("Needles", id: "05", type: ["Guard", "Semi-Enclosed"]),
          Enemy.new("Needles", id: "06", type: ["Guard", "Semi-Enclosed"]),
          Enemy.new("Needles", id: "07", type: ["Guard", "Semi-Enclosed", "Wall"]),
          Enemy.new("Needles", id: "08", type: ["Guard", "Air", "Enclosed", "Separated"]),
          Enemy.new("Needles", id: "09", type: ["Guard", "Enclosed", "Separated"]),
          Enemy.new("Needles", id: "0A", type: ["Guard", "Enclosed", "Separated"]),
          Enemy.new("Killer Fish", id: "0B", type: ["Nuisance", "Vanguard", "Platform"]),
          ],
        "06-01-07", room_req: "underwater", width: 3, height: 2
        ),
      Rm.new("Southeast Water Entry", "Kalidus Channel", [
          Door.new(:left, "06-01-07"),
          Door.new(:right, "06-01-09"),
          Enemy.new("Killer Fish", id: "01", type: ["Nuisance", "Enclosed", "Floor"]),
          ],
        "06-01-08", room_req: "underwater"
        ),
      Rm.new("Lower Entrance", "Kalidus Channel", [
          Door.new(:left, "06-01-08"),
          ],
        "06-01-09", is_important: true
        ),
    ] ]
  end

  def self.oblivion_rooms
    oblivion_rooms = [ [
      Rm.new("Church", "Oblivion Ridge", [
          Door.new(:right, "10-00-01"),
          ],
        "10-00-00", is_important: true, width: 2
        ),
      Rm.new("Church Door", "Oblivion Ridge", [
          Door.new(:left, "10-00-00"),
          Door.new(:right, "10-00-02"),
          ],
        "10-00-01", room_type: :loading, is_important: true
        ),
      ],[
      Rm.new("West Path", "Oblivion Ridge", [
          Door.new(:left, "10-00-01"),
          Door.new(:right, "10-01-01"),
          Enemy.new("Lizardman", id: "00", type: "Challenger"),
          Enemy.new("Werewolf", id: "01", type: "Challenger"),
          Enemy.new("Armored Beast", id: "02", type: "Guard"),
          Enemy.new("Werewolf", id: "03", type: ["Range", "Vanguard"]),
          Enemy.new("Werewolf", id: "04", type: ["Range", "Vanguard"]),
          ],
        "10-01-00", width: 4
        ),
      Rm.new("West Hill", "Oblivion Ridge", [
          Door.new(:left, "10-01-00", height: 2),
          Door.new(:right, "10-01-02"),
          Item.new("Diamond"),
          Item.new("Chamomile", "oblivionJump"),
          Enemy.new("Werewolf", id: "04", type: ["Range", "Vanguard"]),
          Enemy.new("Werewolf", id: "05", type: "Challenger"),
          Enemy.new("Lizardman", id: "06", type: "Vanguard"),
          Enemy.new("Stone Rose", id: "07", type: ["Range", "Vanguard"]),
          ],
        "10-01-01", width: 2, height: 2
        ),
      Rm.new("Boss Room", "Oblivion Ridge", [
          Door.new(:left, "10-00-01"),
          Door.new(:right, "10-00-03"),
          ],
        "10-00-02", is_important: true, room_req: "beatFish", width: 3
        ),
      Rm.new("East Hill", "Oblivion Ridge", [
          Door.new(:left, "10-01-02"),
          Door.new(:right, "10-01-04", height: 2),
          Door.new(:right, "10-01-05"),
          Item.new("Sapiens Fio", "oblivionJump"),
          Enemy.new("Altair", id: "02", type: ["Persistent", "Air", "Vanguard"]),
          ],
        "10-01-03", width: 2, height: 2
        ),
      Rm.new("East Path", "Oblivion Ridge", [
          Door.new(:left, "10-00-01"),
          Door.new(:right, "10-01-01"),
          Enemy.new("Werewolf", id: "00", type: "Challenger"),
          Enemy.new("Altair", id: "01", type: ["Persistent", "Vanguard"]),
          Enemy.new("Altair", id: "02", type: ["Persistent", "Vanguard"]),
          Enemy.new("Skeleton Beast", id: "03", type: "Guard"),
          Enemy.new("Lizardman", id: "04", type: "Vanguard"),
          Enemy.new("Lizardman", id: "05", type: "Vanguard"),
          ],
        "10-01-04", width: 4
        ),
      Rm.new("Boss Save", "Oblivion Ridge", [
          Door.new(:left, "10-00-03"),
          ],
        "10-00-05", room_type: :save
        ),
      Rm.new("Entrance", "Oblivion Ridge", [
          Door.new(:left, "10-00-04"),
          ],
        "10-00-06", room_type: :entrance, is_important: true
        ),
    ] ]
  end

  def self.somnus_rooms
    somnus_rooms = [ [
      Rm.new("West Entrance", "Somnus Reef", [
          Door.new(:right, "07-00-01")
          ],
        "07-00-00", room_type: :entrance, is_important: true
        ),
      Rm.new("West Shallows Beach", "Somnus Reef", [
          Door.new(:left, "07-00-00", height: 2),
          Door.new(:right, "07-00-02", height: 2),
          Door.new(:right, "07-00-02", "underwater"),
          Enemy.new("Merman", id: "05", type: ["Challenger", "Air", "Water", "Platform"]),
          Enemy.new("Merman", id: "06", type: ["Challenger", "Air", "Water", "Platform", "Vanguard"]),
          Enemy.new("Decarabia", id: "07", type: ["Guard", "Platform"]),
          Enemy.new("Balloon", id: "0A", type: ["Nuisance", "Water", "Hardmode"]),
          Enemy.new("Balloon", id: "0B", type: ["Nuisance", "Vanguard", "Hardmode"]),
          Enemy.new("Balloon", id: "0C", type: ["Nuisance", "Water", "Vanguard", "Hardmode"]),
          ],
        "07-00-01", width: 2, height: 2
        ),
      Rm.new("West Shallows Descent", "Somnus Reef", [
          Door.new(:left, "07-00-01", height: 2),
          Door.new(:left, "07-00-01", "underwater"),
          Door.new(:down, "07-00-04", "underwater", width: 3),
          Door.new(:right, "07-00-03", height: 2),
          Enemy.new("Merman", id: "01", type: ["Challenger", "Air", "Water", "Platform", "Vanguard"]),
          Enemy.new("Merman", id: "02", type: ["Challenger", "Air", "Water", "Platform"]),
          Enemy.new("Decarabia", id: "03", type: ["Guard", "Platform", "Vanguard"]),
          Enemy.new("Edimmu", id: "04", type: ["Seeker", "Platform"]),
          Enemy.new("Balloon", id: "0D", type: ["Nuisance", "Water", "Platform", "Vanguard", "Hardmode"]),
          Enemy.new("Balloon", id: "0E", type: ["Nuisance", "Water", "Platform", "Vanguard", "Hardmode"]),
          Enemy.new("Balloon", id: "0F", type: ["Nuisance", "Water", "Platform", "Vanguard", "Hardmode"]),
          Enemy.new("Balloon", id: "10", type: ["Nuisance", "Water", "Platform", "Vanguard", "Hardmode"]),
          Enemy.new("Balloon", id: "11", type: ["Nuisance", "Vanguard", "Platform", "Hardmode"]),
          Enemy.new("Balloon", id: "12", type: ["Nuisance", "Vanguard", "Platform", "Hardmode"]),
          Enemy.new("Balloon", id: "13", type: ["Nuisance", "Platform", "Hardmode"]),
          ],
        "07-00-02", width: 3, height: 2
        ),
      Rm.new("West Shallows Teleporter", "Somnus Reef", [
          Door.new(:left, "07-00-02")
          ],
        "07-00-03", room_type: :teleporter
        ),
      Rm.new("Entry Shaft", "Somnus Reef", [
          Door.new(:up, "07-00-02"),
          Item.new("$2000"),
          Door.new(:right, "07-00-05"),
          Enemy.new("Sea Demon", id: "03", type: ["Nuisance", "Enclosed", "Floor"]),
          Enemy.new("Sea Demon", id: "04", type: ["Nuisance", "Enclosed", "Floor", "Separated"]),
          Enemy.new("Needles", id: "05", type: ["Guard", "Semi-Enclosed", "Floor"]),
          Enemy.new("Needles", id: "06", type: ["Guard", "Enclosed", "Floor"]),
          ],
        "07-00-04", height: 3, room_req: "underwater"
        ),
      Rm.new("M-Shaped Room", "Somnus Reef", [
          Door.new(:left, "07-00-04"),
          Door.new(:down, "07-00-09", width: 3),
          Enemy.new("Edimmu", id: "01", type: ["Seeker", "AirOnly"]),
          Enemy.new("Merman", id: "02", type: ["Challenger", "Semi-Enclosed", "Separated"]),
          ],
        "07-00-05", width: 3, height: 2, room_req: "underwater"
        ),
      Rm.new("Anna's Room", "Somnus Reef", [
          Door.new(:right, "07-00-07"),
          ],
        "07-00-06", room_req: "underwater", is_important: true
        ),
      Rm.new("West Greater Starfish Room", "Somnus Reef", [
          Door.new(:left, "07-00-06", height: 2),
          Item.new("Reinforced Suit"),
          Door.new(:right, "07-00-08", height: 2),
          Enemy.new("Decarabia", id: "03", type: ["Guard", "Enclosed"]),
          Enemy.new("Decarabia", id: "04", type: ["Guard", "Air", "Wall"]),
          Enemy.new("Decarabia", id: "05", type: ["Guard", "Semi-Enclosed", "Platform"]),
          Enemy.new("Decarabia", id: "06", type: ["Guard", "Air", "Wall"]),
          ],
        "07-00-07", width: 3, height: 2, room_req: "underwater"
        ),
      Rm.new("West Lesser Starfish Room", "Somnus Reef", [
          Door.new(:left, "07-00-07", height: 3),
          Door.new(:left, "07-00-10"),
          Door.new(:right, "07-00-09"),
          Enemy.new("Decarabia", id: "00", type: ["Guard", "Vanguard"]),
          Enemy.new("Decarabia", id: "01", type: ["Guard", "Air"]),
          ],
        "07-00-08", height: 3, room_req: "underwater"
        ),
      Rm.new("Fish Tank", "Somnus Reef", [
          Door.new(:left, "07-00-08"),
          Door.new(:up, "07-00-05"),
          Item.new("MP Max Up"),
          Item.new("Vol Arcus"),
          Enemy.new("Lorelai", id: "04", type: ["Guard", "Air", "AirOnly"]),
          Enemy.new("Lorelai", id: "05", type: ["Guard", "Air", "AirOnly"]),
          Enemy.new("Lorelai", id: "06", type: ["Guard", "Air", "AirOnly"]), #Needs review
          Enemy.new("Fishhead", id: "07", type: ["Range", "Enclosed"]),
          Enemy.new("Fishhead", id: "08", type: ["Range", "Enclosed"]),
          ],
        "07-00-09", width: 2, height: 3, room_req: "underwater"
        ),
      Rm.new("Serge's Room", "Somnus Reef", [
          Item.new("Vic Viper"),
          Door.new(:right, "07-00-0B"),
          ],
        "07-00-0A", is_important: true
        ),
      Rm.new("East Shallows Ascent", "Somnus Reef", [
          Door.new(:left, "07-00-0A", height: 2),
          Door.new(:down, "07-00-0C", "underwater"),
          Door.new(:right, "07-00-0D", height: 2),
          Door.new(:right, "07-00-0D", "underwater"),
          Enemy.new("Edimmu", id: "01", type: ["Seeker", "Platform", "Vanguard"]),
          Enemy.new("Saint Elmo", id: "02", type: ["Persistent", "Air", "Water", "Platform", "Vanguard"]),
          ],
        "07-00-0B", width: 2, height: 2
        ),
      Rm.new("Northeast Starfish Shaft", "Somnus Reef", [
          Door.new(:up, "07-00-0B"),
          Door.new(:right, "07-00-15"),
          Enemy.new("Decarabia", id: "01", type: ["Guard", "Air", "Enclosed"]),
          Enemy.new("Decarabia", id: "02", type: ["Guard", "Air", "Vanguard"]),
          ],
        "07-00-0C", height: 3, room_req: "underwater"
        ),
      Rm.new("East Shallows Beach", "Somnus Reef", [
          Door.new(:left, "07-00-0C", height: 2),
          Door.new(:left, "07-00-0C", "underwater"),
          Item.new("Vol Ascia"),
          Door.new(:right, "07-00-0E", height: 2),
          Enemy.new("Edimmu", id: "02", type: ["Seeker", "Platform", "Vanguard"]),
          Enemy.new("Saint Elmo", id: "03", type: ["Persistent", "Air", "Water", "Platform", "Vanguard"]),
          ],
        "07-00-0D", width: 2, height: 2, room_req: "underwater"
        ),
      Rm.new("East Exit", "Somnus Reef", [
          Door.new(:left, "07-00-0D")
          ],
        "07-00-0E", is_important: true
        ),
      Rm.new("Southwest Descent", "Somnus Reef", [
          Door.new(:down, "07-00-12"),
          Door.new(:right, "07-00-10", height: 2),
          Enemy.new("Saint Elmo", id: "01", type: ["Persistent", "Air", "Offscreen"]),
          ],
        "07-00-0F", height: 2, room_req: "underwater"
        ),
      Rm.new("Lorelai Chamber", "Somnus Reef", [
          Door.new(:left, "07-00-0F"),
          Door.new(:right, "07-00-08"),
          Enemy.new("Lorelai", id: "01", type: ["Guard", "Air", "Vanguard"]),
          ],
        "07-00-10", room_req: "underwater"
        ),
      Rm.new("Southwest Teleporter", "Somnus Reef", [
          Door.new(:right, "07-00-12"),
          ],
        "07-00-11", room_req: "underwater", room_type: :teleporter
        ),
      Rm.new("Southwest Ghost Room", "Somnus Reef", [
          Door.new(:left, "07-00-11", height: 2),
          Door.new(:up, "07-00-0F"),
          Item.new("HEART Max Up"),
          Door.new(:right, "07-01-00", height: 2),
          Enemy.new("Saint Elmo", id: "03", type: ["Persistent", "Air"]),
          ],
        "07-00-12", width: 3, height: 2, room_req: "underwater"
        ),
      Rm.new("Southeast Ghost Room", "Somnus Reef", [
          Door.new(:left, "07-01-04"),
          Door.new(:up, "07-00-16", width: 3),
          Door.new(:right, "07-00-14", height: 2),
          Enemy.new("Lorelai", id: "02", type: ["Guard", "Air", "Semi-Enclosed"]),
          Enemy.new("Edimmu", id: "03", type: "Seeker"),
          Enemy.new("Saint Elmo", id: "04", type: ["Persistent", "Air"]),
          ],
        "07-00-13", width: 3, height: 2, room_req: "underwater"
        ),
      Rm.new("East HP Room", "Somnus Reef", [
          Door.new(:left, "07-00-13"),
          Item.new("HP Max Up")
          ],
        "07-00-14", room_req: "underwater"
        ),
      Rm.new("Fish Chamber", "Somnus Reef", [
          Door.new(:left, "07-00-0C"),
          Door.new(:right, "07-00-16"),
          Enemy.new("Edimmu", id: "00", type: ["Seeker", "Vanguard"]),
          ],
        "07-00-15", room_req: "underwater"
        ),
      Rm.new("Southeast Starfish Shaft", "Somnus Reef", [
          Door.new(:left, "07-00-15", height: 4),
          Door.new(:down, "07-00-13"),
          Enemy.new("Decarabia", id: "01", type: ["Guard", "Vanguard"]),
          Enemy.new("Decarabia", id: "02", type: ["Guard", "Ambush", "Platform"]),
          Enemy.new("Decarabia", id: "03", type: ["Guard", "Platform"]),
          ],
        "07-00-16", room_req: "underwater"
        ),
      ],[
      Rm.new("West Rusalka Loading", "Somnus Reef", [
          Door.new(:left, "07-00-12"),
          Door.new(:right, "07-01-01"),
          ],
        "07-01-00", room_req: "underwater", room_type: :loading
        ),
      Rm.new("Rusalka Save", "Somnus Reef", [
          Door.new(:left, "07-01-00"),
          Door.new(:right, "07-01-02"),
          ],
        "07-01-01", room_req: "underwater", room_type: :save
        ),
      Rm.new("Rusalka Boss Room", "Somnus Reef", [
          Door.new(:left, "07-01-01"),
          Door.new(:right, "07-01-03"),
          ],
        "07-01-02", width: 2, room_req: "beatRusalka", is_important: true
        ),
      Rm.new("Rusalka Exit", "Somnus Reef", [
          Door.new(:left, "07-01-02"),
          Door.new(:right, "07-01-04"),
          ],
        "07-01-03", room_req: "underwater"
        ),
      Rm.new("East Rusalka Loading", "Somnus Reef", [
          Door.new(:left, "07-01-03"),
          Door.new(:right, "07-00-13"),
          ],
        "07-01-04", room_req: "underwater", room_type: :loading
        ),
    ] ]
  end

  def self.giants_rooms
    giants_rooms = [ [
      Rm.new("Entrance", "Giant's Dwelling", [
          Door.new(:right, "0D-00-01"),
          ],
        "0D-00-00", room_type: :entrance, is_important: true
        ),
      Rm.new("West Gate", "Giant's Dwelling", [
          Door.new(:left, "0D-00-01"),
          Door.new(:right, "0D-00-02"),
          Enemy.new("Skeleton Beast", id: "00", type: ["Guard", "Vanguard"]),
          Enemy.new("Ectoplasm", id: "01", type: ["Seeker", "Vanguard"]),
          Enemy.new("Ectoplasm", id: "02", type: ["Seeker", "Vanguard"]),
          ],
        "0D-00-01", width: 2
        ),
      Rm.new("West Save", "Giant's Dwelling", [
          Door.new(:right, "0D-00-04", subroom: "Top"),
          ],
        "0D-00-02"
        ),
      Rm.new("West Building Entrance", "Giant's Dwelling", [
          Door.new(:left, "0D-00-01"),
          Door.new(:right, "0D-00-04", subroom: "Bottom"),
          Item.new("Temperance Ring"),
          Enemy.new("Ladycat", id: "02", type: "Vanguard"),
          ],
        "0D-00-03"
        ),
      Rm.new("West Building Lobby Top", "Giant's Dwelling", [
          Door.new(:left, "0D-00-02", "smallDistance"),
          Door.new(:right, "0D-00-05", "smallDistance"),
          Door.new(:down, "0D-00-04", subroom: "Bottom"),
          Enemy.new("Automaton ZX26", id: "02", type: ["Guard", "Vanguard"]),
          Enemy.new("Ectoplasm", id: "03", type: ["Nuisance", "Platform", "Enclosed"]),
          Enemy.new("Ectoplasm", id: "04", type: ["Nuisance", "Platform", "Enclosed", "CollisionIssue"]),
          Enemy.new("Miss Murder", id: "05", type: ["Nuisance", "Platform", "Passthrough"]),
          Enemy.new("Miss Murder", id: "06", type: ["Nuisance", "Platform", "Passthrough"]),
          ],
        "0D-00-04", "West Building Lobby", width: 2
        ),
      Rm.new("West Building Lobby Bottom", "Giant's Dwelling", [
          Door.new(:left, "0D-00-03"),
          Door.new(:right, "0D-00-0A"),
          Door.new(:up, "0D-00-04", subroom: "Top"),
          Enemy.new("Ladycat", id: "01", type: ["Vanguard", "Semi-Enclosed"]),
          ],
        "0D-00-04", "West Building Lobby", room_req: "highJump", width: 2
        ),
      Rm.new("Daniela's Room", "Giant's Dwelling", [
          Door.new(:left, "0D-00-04", subroom: "Top"),
          ],
        "0D-00-05", is_important: true
        ),
      Rm.new("Vol Secare Room", "Giant's Dwelling", [
          Door.new(:left, "0D-00-13"),
          Item.new("Vol Secare"),
          ],
        "0D-00-06"
        ),
      Rm.new("Boss Room", "Giant's Dwelling", [
          Door.new(:left, "0D-00-14"),
          Door.new(:right, "0D-00-08"),
          ],
        "0D-00-07", is_important: true, width: 2
        ),
      Rm.new("Albus Room", "Giant's Dwelling", [
          Door.new(:left, "0D-00-07"),
          Door.new(:right, "0D-00-09"),
          Item.new("Dominus Anger")
          ],
        "0D-00-08", width: 2
        ),
      Rm.new("Exit", "Giant's Dwelling", [
          Door.new(:left, "0D-00-08"),
          ],
        "0D-00-09", is_important: true
        ),
      Rm.new("West Building Exit", "Giant's Dwelling", [
          Door.new(:left, "0D-00-04", subroom: "Bottom"),
          Door.new(:right, "0D-00-0B"),
          Enemy.new("Curse Diva", id: "00", type: ["Seeker", "Vanguard"]),
          ],
        "0D-00-0A"
        ),
      Rm.new("West Graves", "Giant's Dwelling", [
          Door.new(:left, "0D-00-0A", subroom: "Bottom"),
          Door.new(:right, "0D-00-0C"),
          Enemy.new("Curse Diva", id: "00", type: ["Seeker", "Vanguard"]),
          Enemy.new("Zombie", id: "01", type: "Guard"),
          Enemy.new("Zombie", id: "02", type: "Guard"),
          Enemy.new("Zombie", id: "03", type: "Guard"),
          Enemy.new("Zombie", id: "04", type: ["Guard", "Ambush"]),
          Enemy.new("Zombie", id: "05", type: ["Guard", "Ambush"]),
          Enemy.new("Zombie", id: "06", type: ["Guard", "Ambush"]),
          Enemy.new("Ladycat", id: "07", type: ["Vanguard", "Platform"]),
          ],
        "0D-00-0B", width: 2
        ),
      Rm.new("East Graves", "Giant's Dwelling", [
          Door.new(:left, "0D-00-0B", subroom: "Bottom"),
          Door.new(:right, "0D-00-0D"),
          Item.new("Black Drops", "highJump"),
          Enemy.new("Zombie", id: "01", type: ["Guard", "Ambush"]),
          Enemy.new("Zombie", id: "02", type: ["Guard", "Ambush"]),
          Enemy.new("Zombie", id: "03", type: ["Guard", "Ambush"]),
          Enemy.new("Skeleton Frisky", id: "04", type: ["Nuisance", "Floor"]),
          Enemy.new("Skeleton Frisky", id: "05", type: ["Nuisance", "Floor"]),
          Enemy.new("Skeleton", id: "06", type: "Range"),
          Enemy.new("Skeleton", id: "07", type: "Range"),
          Enemy.new("Skeleton", id: "08", type: "Range"),
          ],
        "0D-00-0C", width: 2
        ),
      Rm.new("East Building Entrance", "Giant's Dwelling", [
          Door.new(:left, "0D-00-0C"),
          Door.new(:right, "0D-00-10", subroom: "Bottom"),
          Enemy.new("Automaton ZX26", id: "00", type: ["Guard", "Vanguard"]),
          ],
        "0D-00-0D"
        ),
      Rm.new("Ectoplasm Ascent", "Giant's Dwelling", [
          Door.new(:up, "0D-00-0F"),
          Door.new(:right, "0D-00-10", subroom: "Top"),
          Enemy.new("Ectoplasm", id: "00", type: ["Nuisance", "Vanguard", "Platform"]),
          ],
        "0D-00-0E"
        ),
      Rm.new("Pre-Boss Corner", "Giant's Dwelling", [
          Door.new(:down, "0D-00-0E"),
          Door.new(:right, "0D-00-14"),
          ],
        "0D-00-0F"
        ),
      Rm.new("East Building Lobby Top", "Giant's Dwelling", [
          Door.new(:left, "0D-00-0E"),
          Door.new(:down, "0D-00-10", false, subroom: "Bottom"),
          Door.new(:right, "0D-00-11"),
          Enemy.new("Automaton ZX26", id: "03", type: ["Guard", "Vanguard", "Semi-Enclosed", "CollisionIssue"]),
          Enemy.new("Miss Murder", id: "04", type: ["Nuisance", "Enclosed"]),
          Enemy.new("Curse Diva", id: "07", type: ["Seeker", "Vanguard", "Semi-Enclosed"]),
          ],
        "0D-00-10", "East Building Lobby", width: 2
        ),
      Rm.new("East Building Lobby Bottom", "Giant's Dwelling", [
          Door.new(:left, "0D-00-0D"),
          Door.new(:up, "0D-00-10", false, subroom: "Top"),
          Door.new(:right, "0D-00-12"),
          Enemy.new("Ladycat", id: "05", type: ["Challenger", "Platform", "Enclosed", "CollisionIssue"]),
          Enemy.new("Ladycat", id: "06", type: "Vanguard"),
          Enemy.new("Curse Diva", id: "08", type: ["Seeker", "Vanguard", "Platform", "Passthrough"]),
          ],
        "0D-00-10", "East Building Lobby", width: 2
        ),
      Rm.new("Ectoplasm Hallway", "Giant's Dwelling", [
          Door.new(:left, "0D-00-10", subroom: "Top"),
          Door.new(:right, "0D-00-13"),
          Enemy.new("Ectoplasm", id: "00", type: ["Nuisance", "Vanguard"]),
          Enemy.new("Ectoplasm", id: "01", type: ["Nuisance", "Vanguard"]),
          Enemy.new("Ectoplasm", id: "02", type: ["Nuisance", "Vanguard"]),
          Enemy.new("Ectoplasm", id: "03", type: ["Nuisance", "Vanguard"]),
          Enemy.new("Ectoplasm", id: "04", type: ["Nuisance", "Vanguard"]),
          ],
        "0D-00-11", width: 2
        ),
      Rm.new("Skeleton Hallway", "Giant's Dwelling", [
          Door.new(:left, "0D-00-10", subroom: "Bottom"),
          Door.new(:right, "0D-00-13"),
          Enemy.new("Skeleton Beast", id: "02", type: ["Guard", "Vanguard"]),
          ],
        "0D-00-12", width: 2
        ),
      Rm.new("East Building Stairs", "Giant's Dwelling", [
          Door.new(:left, "0D-00-11", height: 2),
          Door.new(:left, "0D-00-12"),
          Door.new(:right, "0D-00-06"),
          Enemy.new("Ladycat", id: "00", type: ["Vanguard", "Enclosed"]),
          Enemy.new("Ladycat", id: "01", type: ["Vanguard", "Platform", "Semi-Enclosed", "CollisionIssue"]),
          Enemy.new("Ladycat", id: "02", type: ["Challenger", "Enclosed", "CollisionIssue"]),
          Enemy.new("Ladycat", id: "03", type: ["Vanguard", "Semi-Enclosed", "CollisionIssue"]),
          Enemy.new("Ladycat", id: "04", type: ["Challenger", "Enclosed", "CollisionIssue"]),
          Enemy.new("Miss Murder", id: "05", type: ["Nuisance", "Enclosed"]),
          Enemy.new("Miss Murder", id: "06", type: ["Nuisance", "Semi-Enclosed"]),
          Enemy.new("Curse Diva", id: "07", type: ["Seeker", "Vanguard", "Platform", "Passthrough"]),
          ],
        "0D-00-13", width: 2, height: 2
        ),
      Rm.new("Boss Save", "Giant's Dwelling", [
          Door.new(:left, "0D-00-0F"),
          Door.new(:right, "0D-00-07"),
          Enemy.new("Skeleton Beast", id: "02", type: ["Guard", "Vanguard"]),
          ],
        "0D-00-14"
        ),
    ] ]
  end

  def self.tristis_rooms
    tristis_rooms = [ [
      Rm.new("Entrance", "Tristis Pass", [
          Door.new(:left, "0B-00-01"),
          ],
        "0B-00-00", room_type: :entrance, is_important: true
        ),
      Rm.new("East Underground", "Tristis Pass", [
          Door.new(:left, "0B-00-02", height: 2),
          Door.new(:right, "0B-00-00"),
          Enemy.new("Balloon", id: "01", type: ["Nuisance", "Semi-Enclosed"]),
          Enemy.new("Arachne", id: "02", type: ["Guard", "Enclosed", "Vanguard"]),
          Enemy.new("Arachne", id: "03", type: ["Range", "Enclosed"]),
          ],
        "0B-00-01", width: 3, height: 2
        ),
      Rm.new("Descent Top", "Tristis Pass", [
          Door.new(:left, "0B-00-03", height: 2),
          Door.new(:right, "0B-00-01", height: 2),
          Door.new(:down, "0B-00-04"),
          Enemy.new("Balloon", id: "00", type: ["Nuisance", "Vanguard"]),
          ],
        "0B-00-02", height: 2
        ),
      Rm.new("East Teleporter", "Tristis Pass", [
          Door.new(:right, "0B-00-02"),
          ],
        "0B-00-03", room_type: :teleporter
        ),
      Rm.new("Descent Ladders", "Tristis Pass", [
          Door.new(:left, "0B-00-06"),
          Door.new(:right, "0B-00-05", height: 3),
          Door.new(:up, "0B-00-02"),
          Enemy.new("Lizardman", id: "00", type: "Challenger"),
          Enemy.new("Balloon", id: "01", type: ["Nuisance", "Separated"]),
          Enemy.new("Balloon", id: "02", type: ["Nuisance", "Vanguard"]),
          ],
        "0B-00-04", height: 4
        ),
      Rm.new("East Save", "Tristis Pass", [
          Door.new(:left, "0B-00-04"),
          ],
        "0B-00-05", room_type: :save
        ),
      Rm.new("East Loading", "Tristis Pass", [
          Door.new(:left, "0B-01-00"),
          Door.new(:right, "0B-00-04"),
          ],
        "0B-00-06", room_type: :loading
        ),
      Rm.new("West Loading", "Tristis Pass", [
          Door.new(:left, "0B-00-08"),
          Door.new(:right, "0B-01-07"),
          ],
        "0B-00-07", room_type: :loading
        ),
      Rm.new("Ascent Ladders", "Tristis Pass", [
          Door.new(:left, "0B-00-09", height: 3),
          Door.new(:right, "0B-00-07"),
          Door.new(:up, "0B-00-0B"),
          Enemy.new("Lizardman", id: "01", type: "Vanguard"),
          Enemy.new("Lizardman", id: "02", type: ["Challenger", "Separated"]),
          Enemy.new("Lizardman", id: "03", type: "Vanguard"),
          Enemy.new("White Dragon", id: "04", type: ["Range", "WallR", "MustMove"]),
          Enemy.new("Altair", id: "05", type: ["Persistent", "Air", "Offscreen"]),
          ],
        "0B-00-08", height: 4
        ),
      Rm.new("West Save", "Tristis Pass", [
          Door.new(:right, "0B-00-08"),
          ],
        "0B-00-09", room_type: :save
        ),
      Rm.new("West Teleporter", "Tristis Pass", [
          Door.new(:left, "0B-00-0B"),
          ],
        "0B-00-0A", room_type: :teleporter
        ),
      Rm.new("Ascent Top", "Tristis Pass", [
          Door.new(:left, "0B-00-0C", "highJump", height: 2),
          Door.new(:right, "0B-00-0A", "highJump", height: 2),
          Door.new(:down, "0B-00-08"),
          Enemy.new("Arachne", id: "00", type: ["Range", "Vanguard"]),
          Enemy.new("Arachne", id: "01", type: ["Range", "Vanguard"]),
          Enemy.new("Altair", id: "02", type: ["Persistent", "Air", "Offscreen"]),
          ],
        "0B-00-0B", height: 2
        ),
      Rm.new("Slope Far Right", "Tristis Pass", [
          Door.new(:left, "0B-00-0D", height: 2),
          Door.new(:right, "0B-00-0B"),
          Enemy.new("Balloon", id: "02", type: ["Nuisance", "Vanguard"]),
          Enemy.new("Lizardman", id: "03", type: ["Challenger", "Semi-Enclosed"]),
          Enemy.new("Arachne", id: "04", type: ["Range", "Enclosed", "Separated"]),
          Enemy.new("Arachne", id: "05", type: ["Guard", "Enclosed"]),
          Enemy.new("Owl", id: "06", type: ["Seeker", "Enclosed", "Platform"]),
          Enemy.new("Owl", id: "07", type: ["Seeker", "Platform", "Passthrough"]),
          ],
        "0B-00-0C", width: 3, height: 2
        ),
      Rm.new("Slope Mid Right", "Tristis Pass", [
          Door.new(:left, "0B-00-0E", height: 3),
          Door.new(:right, "0B-00-0C"),
          Item.new("Vol Hasta"),
          Item.new("Chariot Ring"),
          Enemy.new("Thunder Demon", id: "04", type: "Nuisance"),
          Enemy.new("Thunder Demon", id: "05", type: ["Nuisance", "Platform", "Passthrough"]),
          Enemy.new("Owl", id: "06", type: ["Seeker", "Platform", "Passthrough"]),
          Enemy.new("Owl", id: "07", type: ["Seeker", "Platform", "Passthrough"]),
          Enemy.new("Owl", id: "08", type: ["Seeker", "Platform", "Passthrough"]),
          Enemy.new("Owl", id: "09", type: ["Seeker", "Platform", "Passthrough"]),
          Enemy.new("Owl", id: "0A", type: ["Seeker", "Platform", "Passthrough"]),
          ],
        "0B-00-0D", width: 4, height: 3
        ),
      Rm.new("Slope Mid Left", "Tristis Pass", [
          Door.new(:left, "0B-00-0F", height: 2),
          Door.new(:right, "0B-00-0D"),
          Enemy.new("Owl", id: "02", type: ["Seeker", "Platform", "Passthrough"]),
          Enemy.new("Owl", id: "03", type: ["Seeker", "Platform", "Passthrough"]),
          Enemy.new("Owl", id: "04", type: ["Seeker", "Platform", "Enclosed"]),
          Enemy.new("Thunder Demon", id: "05", type: ["Nuisance", "Enclosed", "Vanguard"]),
          Enemy.new("Arachne", id: "06", type: ["Range", "Enclosed", "Separated"]),
          Enemy.new("Arachne", id: "07", type: ["Guard", "Enclosed"]),
          ],
        "0B-00-0E", width: 3, height: 2
        ),
      Rm.new("Slope Far Left", "Tristis Pass", [
          Door.new(:left, "0B-00-10", height: 3),
          Door.new(:right, "0B-00-0E"),
          Item.new("MP Max Up"),
          Item.new("Inire Pecunia"),
          Item.new("Body Suit"),
          Enemy.new("Owl", id: "04", type: ["Seeker", "Platform", "Passthrough"]),
          Enemy.new("Owl", id: "05", type: ["Seeker", "Platform", "Passthrough"]),
          Enemy.new("Owl", id: "06", type: ["Seeker", "Platform", "Passthrough"]),
          Enemy.new("Owl", id: "07", type: ["Seeker", "Platform", "Passthrough"]),
          Enemy.new("Owl", id: "08", type: ["Seeker", "Platform", "Passthrough"]),
          Enemy.new("Owl", id: "09", type: ["Seeker", "Platform", "Passthrough"]),
          Enemy.new("Lizardman", id: "0A", type: ["Challenger", "Enclosed"]),
          Enemy.new("Lizardman", id: "0B", type: ["Challenger", "Enclosed"]),
          Enemy.new("Lizardman", id: "0C", type: ["Challenger", "Semi-Enclosed"]),
          Enemy.new("Lizardman", id: "0D", type: ["Vanguard", "Enclosed"]),
          ],
        "0B-00-0F", width: 4, height: 3
        ),
      Rm.new("Exit", "Tristis Pass", [
          Door.new(:right, "0B-00-0F"),
          ],
        "0B-00-10", is_important: :true
        ),
      ],[
      Rm.new("Skeleton Corridor", "Tristis Pass", [
          Door.new(:left, "0B-01-02"),
          Door.new(:right, "0B-00-06"),
          Enemy.new("Giant Skeleton", id: "00", type: "Guard"),
          Enemy.new("Giant Skeleton", id: "01", type: "Guard"),
          Enemy.new("Mimic", id: "02", type: "Challenger"),
          ],
        "0B-01-00", width: 4
        ),
      Rm.new("Waterfall Top", "Tristis Pass", [
          Door.new(:down, "0B-01-02", width: 2),
          Item.new("Vol Grando", "hasMagnes"),
          ],
        "0B-01-01", width: 2, height: 2
        ),
      Rm.new("Waterfall Bottom", "Tristis Pass", [
          Door.new(:left, "0B-01-03", "waterfall", height: 3),
          Door.new(:left, "0B-01-04", "waterfall"),
          Door.new(:right, "0B-01-00", "waterfall"),
          Door.new(:up, "0B-01-01", "highJump"),
          Item.new("HEART Max Up", "waterfall"),
          Item.new("Amanita", "waterfall"),
          Item.new("Lovers Ring", "waterfall"),
          ],
        "0B-01-02", height: 4
        ),
      Rm.new("Irina's Room", "Tristis Pass", [
          Door.new(:right, "0B-01-02"),
          ],
        "0B-01-03", is_important: :true
        ),
      Rm.new("Spike Corridor", "Tristis Pass", [
          Door.new(:up, "0B-01-06"),
          Door.new(:right, "0B-01-02"),
          Enemy.new("Bat", id: "07", type: ["Persistent", "Air", "Offscreen"]),
          Enemy.new("Medusa Head", id: "09", type: ["Persistent", "Air", "Offscreen", "Hardmode"]),
          ],
        "0B-01-04", width: 4
        ),
      Rm.new("HP Room", "Tristis Pass", [
          Door.new(:right, "0B-01-06"),
          Item.new("HP Max Up"),
          Enemy.new("White Dragon", id: "01", type: ["Range", "Wall", "MustMove"]),
          ],
        "0B-01-05"
        ),
      Rm.new("Lion Hub", "Tristis Pass", [
          Door.new(:left, "0B-01-05"),
          Door.new(:right, "0B-01-07"),
          Door.new(:down, "0B-01-04", width: 2),
          Enemy.new("Armored Beast", id: "00", type: "Vanguard"),
          ],
        "0B-01-06", width: 2
        ),
      Rm.new("Ectoplasm Stairs", "Tristis Pass", [
          Door.new(:left, "0B-00-07", "highJump", height: 4),
          Door.new(:left, "0B-01-06"),
          Item.new("Onyx"),
          Enemy.new("Ectoplasm", id: "02", type: ["Seeker", "Platform"]),
          Enemy.new("Ectoplasm", id: "03", type: ["Seeker", "Platform", "Separated"]),
          Enemy.new("Ectoplasm", id: "04", type: ["Seeker", "Platform", "Passthrough", "Vanguard"]),
          ],
        "0B-01-07", height: 4
        ),
    ] ]
  end

  def self.argila_rooms
    argila_rooms = [ [
      Rm.new("Exit", "Argila Swamp", [
          Door.new(:right, "05-00-01"),
          ],
        "05-00-00", is_important: true
        ),
      Rm.new("West Swamp", "Argila Swamp", [
          Door.new(:left, "05-00-00"),
          Door.new(:right, "05-00-04"),
          Enemy.new("Owl Knight", id: "01", type: ["Range", "Vanguard"]),
          Enemy.new("Mandragora", id: "02", type: "Guard"),
          Enemy.new("Mandragora", id: "03", type: "Guard"),
          Enemy.new("Mandragora", id: "04", type: "Guard"),
          Enemy.new("Owl Knight", id: "05", type: "Range"),
          Enemy.new("Chosen Une", id: "06", type: "Challenger"),
          Enemy.new("Owl Knight", id: "07", type: "Range"),
          Enemy.new("Jersey Devil", id: "08", type: ["Nuisance", "Floor"]),
          Enemy.new("Stone Rose", id: "09", type: "Guard"),
          Enemy.new("Stone Rose", id: "0A", type: "Guard"),
          Enemy.new("Stone Rose", id: "0B", type: "Guard"),
          Enemy.new("Stone Rose", id: "0C", type: "Guard"),
          Enemy.new("Owl Knight", id: "0D", type: ["Range", "Vanguard"]),
          ],
        "05-00-01", width: 8
        ),
      Rm.new("East Swamp", "Argila Swamp", [
          Door.new(:left, "05-00-04"),
          Door.new(:right, "05-00-03"),
          Enemy.new("Jersey Devil", id: "01", type: ["Nuisance", "Floor", "Vanguard"]),
          Enemy.new("Jersey Devil", id: "02", type: ["Nuisance", "Floor"]),
          Enemy.new("Jersey Devil", id: "03", type: ["Nuisance", "Floor"]),
          Enemy.new("Chosen Une", id: "04", type: "Challenger"),
          Enemy.new("Chosen Une", id: "05", type: "Challenger"),
          Enemy.new("Jersey Devil", id: "06", type: ["Nuisance", "Floor", "Semi-Enclosed"]),
          Enemy.new("Chosen Une", id: "07", type: "Challenger"),
          Enemy.new("Chosen Une", id: "08", type: "Challenger"),
          Enemy.new("Mandragora", id: "09", type: "Guard"),
          Enemy.new("Chosen Une", id: "0A", type: "Challenger"),
          Enemy.new("Chosen Une", id: "0B", type: "Challenger"),
          Enemy.new("Mandragora", id: "0C", type: "Guard"),
          Enemy.new("Chosen Une", id: "0D", type: "Challenger"),
          Enemy.new("Mandragora", id: "0E", type: "Guard"),
          Enemy.new("Chosen Une", id: "0F", type: "Challenger"),
          ],
        "05-00-02", width: 8
        ),
      Rm.new("Entrance", "Argila Swamp", [
          Door.new(:left, "05-00-02"),
          ],
        "05-00-03", room_type: :entrance, is_important: true
        ),
      Rm.new("Central Island", "Argila Swamp", [
          Door.new(:left, "05-00-01"),
          Door.new(:right, "05-00-02"),
          Enemy.new("Chosen Une", id: "02", type: "Vanguard"),
          Enemy.new("Chosen Une", id: "03", type: "Vanguard"),
          Enemy.new("Chosen Une", id: "04", type: "Challenger"),
          Enemy.new("Stone Rose", id: "05", type: "Guard"),
          Enemy.new("Owl Knight", id: "06", type: ["Range", "Vanguard"]),
          Enemy.new("Stone Rose", id: "07", type: ["Guard", "Vanguard"]),
          ],
        "05-00-04", width: 4
        ),
    ] ]
  end

  self.castle_rooms
  self.training_hall_rooms
  self.forest_rooms
  self.monastery_rooms
  self.skeleton_cave_rooms
  self.misty_rooms
  self.minera_rooms
  self.manor_rooms
  self.tymeo_rooms
  self.kalidus_rooms
  self.oblivion_rooms
  self.somnus_rooms
  self.giants_rooms
  self.tristis_rooms
  self.argila_rooms
end
