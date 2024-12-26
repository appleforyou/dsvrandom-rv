class MusicRandomizer
  BGM_RANDO_AVAILABLE_SONG_INDEXES = [
    0x0E, # An Empty Tome
    0x0E, # An Empty Tome
    0x10, # Malak's Labyrinth
    0x0E, # An Empty Tome
    0x0E, # An Empty Tome
    0x0F, # Ebony Wings
    0x12, # Tower of Dolls
    0x12, # Tower of Dolls
    0x0F, # Ebony Wings
    #0x0D, # Ambience
    0x13, # The Colossus
    0x13, # The Colossus
    0x0E, # An Empty Tome
    0x03, # Serenade of the Hearth
    0x01, # A Prologue
    0x2E, # Riddle
    0x04, # Emerald Mist
    0x04, # Emerald Mist
    0x05, # A Clashing of Waves
    0x0A, # Wandering the Crystal Blue
    0x06, # Rhapsody of the Forsaken
    0x06, # Rhapsody of the Forsaken
    0x07, # Jaws of a Scorched Earth
    0x0B, # Edge of the Sky
    0x2E, # Riddle
    0x0C, # Hard Won Nobility
    0x0C, # Hard Won Nobility
    0x08, # Tragedy's Pulse
    0x08, # Tragedy's Pulse
    0x09, # Unholy Vespers
    0x02, # Chapel Hidden in Smoke
    0x2D, # Lone Challenger
    0x35, # Vampire Killer
    0x36, # Stalker
    0x37, # Wicked Child
    0x38, # Walking on the Edge
    0x39, # Heart of Fire
    0x3A, # Out of Time
    0x3B, # Nothing to Lose
    0x3C, # Black Night
  ]

  def initialize(rng, game)
    @rng = rng
    @dra03 = game.dra03
    @castle_music_list_start_offset = 0x2c0970
    @area_music_list_start_offset = 0x2c08d0
    randomize_bgm()
  end

  def randomize_bgm
    remaining_song_indexes = BGM_RANDO_AVAILABLE_SONG_INDEXES.dup
    remaining_song_indexes.shuffle!(random: @rng)

    (0..0xc).each do |sector_index|
      new_song_index = remaining_song_indexes.pop()
      write_song_index_by_area_and_sector(new_song_index, 0, sector_index)
    end
    (1..0x13).each do |area_index|
      new_song_index = remaining_song_indexes.pop()
      write_song_index_by_area_and_sector(new_song_index, area_index, 0)
    end
  end

  def write_song_index_by_area_and_sector(song_index, area_index, sector_index)
    list_entry_length = 4

    if area_index == 0
      pointer = @castle_music_list_start_offset + sector_index*list_entry_length
    else
      pointer = @area_music_list_start_offset + area_index*list_entry_length
    end

    @dra03[pointer] = song_index
  end
end