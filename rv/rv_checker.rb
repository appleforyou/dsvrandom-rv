class RVChecker
require_relative 'ooe_items'
require_relative 'ooe_locations'
require_relative 'ooe_logic'

  attr_reader :current_items,
              :all_progression_pickups,
              :no_progression_locations,
              :event_locations,
              :easter_egg_locations,
              :enemy_locations,
              :no_glyph_locations,
              :hidden_locations,
              :villager_locations,
              :preferences,
              :game_beatable,
              :logic,
              :progression_locations
              
  attr_writer :progression_locations

  def initialize(options)
    @logic = OoELogic.new(self, options)
    Locations.set_logic(@logic)
    Locations.locs.delete_if {|loc| loc[:type].include?("Villager")}
    @current_items = []
    @progression_locations = []
    @all_progression_pickups = OoEItems.items.select {|key, item| item[:progression]}
    if !options[:rv_puzzle_progression]
      @all_progression_pickups.delete("Fulgur")
      @all_progression_pickups.delete("Vol Fulgur")
    end
    if options[:rv_difficulty] == "Do Your Worst"
      @all_progression_pickups.delete("Arma Machina")
    end
    @no_progression_locations = Locations.locs.select {|loc| loc[:type].include?("No Progression")}
    @enemy_locations = Locations.locs.select {|loc| loc[:container] == "Spell"}
    @event_locations = Locations.locs.select {|loc| loc[:type].include?("Event")}
    @easter_egg_locations = []
    @no_glyph_locations = Locations.locs.select {|loc| loc[:type].include?("No Glyphs")}
    @hidden_locations = Locations.locs.select {|loc| loc[:container] == "Wall"}
    @villager_locations = Locations.locs.select {|loc| loc[:type].include?("Villager")}
    @preferences =   {
      "Cat Tackle": 0.1,
      "Arma Felix": 0.1,
      "Moonwalkers": 0.1,
      "Mercury Boots": 0.1,
      "Winged Boots": 0.1,
      "Rapidus Fio": 0.001
    }
  end
  
  def logic
    @logic
  end
  
  def add_item(item_name)
    #current_items << OoEItems.get_item(item_name)
    @current_items << item_name
  end
  
  def get_accessible_locations
    accessible_locations = []
    
    Locations.locs.each do |loc|
      if loc[:available][]
        accessible_locations << loc
      end
    end
    
    return accessible_locations
  end
  
  def pickups_by_current_num_locations_they_access
    orig_current_items = @current_items
    
    possibly_useful_pickups = @all_progression_pickups.reject {|key , item| @current_items.include?(item[:name])}
    
    # Subtract no_progression_locations since we don't want those messing up the numbers.
    currently_accessible_locations = get_accessible_locations().reject {|loc| loc[:type].include?("No Progression")}
    
    pickups_by_locations = {}
    
    possibly_useful_pickups.each do |key, item|
      @current_items = orig_current_items + [item[:name]]
      new_accessible_locations = get_accessible_locations().reject {|loc| loc[:type].include?("No Progression")}
      next_accessible_pickups = new_accessible_locations.reject {|new_loc| currently_accessible_locations.any? {|cur_loc| cur_loc[:id] == new_loc[:id]} }
      
      pickups_by_locations[item[:name]] = next_accessible_pickups.length
    end
    
    return pickups_by_locations
  ensure
    @current_items = orig_current_items
  end
  
  def game_beatable?
    @logic.beatDracula()
  end
 
end
