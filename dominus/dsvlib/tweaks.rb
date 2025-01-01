require_relative '../dsvrandom/rv/ooe_locations.rb'
require_relative '../dsvrandom/rv/ooe_items.rb'

class Tweaks
  def initialize(game)
    @game = game
    @alldata = game.alldata
    @dra03 = game.dra03
    @options = game.options
    @freestart = 0x28e4d0
    @other_dominus = 0
    @nops = {
      1 => [0x90],
      2 => [0x66,0x90],
      3 => [0x0f,0x1f,0x00],
      4 => [0x0f,0x1f,0x40,0x00],
      5 => [0x0f,0x1f,0x44,0x00,0x00],
      6 => [0x66,0x0f,0x1f,0x44,0x00,0x00],
      7 => [0x0f,0x1f,0x80,0x00,0x00,0x00,0x00],
      8 => [0x0f,0x1f,0x84,0x00,0x00,0x00,0x00,0x00]
    }
  end

  def nop(n)
    if n > 15
      raise "NOP too large. This shouldn't happen"
    elsif n > 8
      a = Array.new(n-8, 0x66)
      return a + @nops[8]
    else
      return @nops[n]
    end
  end

  def modify_wallman_glyph(new_glyph)
    @dra03[0x2d8c8c] = new_glyph
  end

  def modify_hardcoded_glyph_event(subtype, new_glyph)
    #We can't properly edit the code unless we have both Hatred and Anger glyph IDs.
    if [0x69, 0x6F].include?(subtype) #Dominus Hatred/Anger
      if @other_dominus == 0
        @other_dominus = new_glyph
      else
        if subtype == 0x69
          modify_dominus_event_glyphs(new_glyph, @other_dominus)
        else
          modify_dominus_event_glyphs(@other_dominus, new_glyph)
        end
      end
    elsif subtype == 0x63 #Confodere
      @dra03[0x16a76f] = new_glyph
      #The compiler is depending on the value of this for the value of something else, and to fix that we need more room.
      @dra03[0x16a781] = [0xeb,0x21] #size 2. JMP 0x18016b3a4
      @dra03[0x16a7a4] = [0xb9,0x02,0x00,0x00,0x00,0xeb,0xd8] #size 7. MOV ECX 0x2; JMP 0x18016b383
    elsif subtype == 0x76 #Dominus Agony
      @dra03[0x26bbc8] = new_glyph
      @dra03[0x26bbcb] = 1 - new_glyph
    elsif subtype == 0x40 #Cubus
      @dra03[0x1cfe98] = new_glyph
      @dra03[0x1cfe91] = new_glyph + 1
    elsif subtype == 0x3e #Strength Ring
      @dra03[0x103e16, 2] = new_glyph
    elsif [0x2f,0x3b,0x44,0x47,0x4c,0x52,0x53,0x54].include?(subtype)
      modify_other_event_glyph(subtype, new_glyph)
    end
  end

  def modify_dominus_event_glyphs(hatred_glyph, anger_glyph)
    #Modifying Dominus Hatred cutscene glyph
    #unskipped cutscene version uses shared code for both, which adds 1 to Dominus Hatred's glyph id if you are in the Anger cutscene.
    @dra03[0x149855] = hatred_glyph
    #jumping to unused memory to calculate this differently
    @dra03[0x149844] = jump(0x149844,@freestart+0x30) + nop(1) #size 6. CALL 0x18028f100; NOP
    @dra03[@freestart+0x30] = [0x8d,0x50,0x1f,0x74,0x03,0x8d,0x58,anger_glyph-hatred_glyph,0xc3] #size 9. LEA EDX,[RAX + 0x1f]; JE 0x18028f108; LEA EBX,[RAX+(anger_glyph-hatred_glyph)]; RET

    #skipped cutscene version has separate code per glyph
    [0x69,0x6F].each do |subtype|
      if subtype == 0x69
        skipped_ptr_1 = 0x2699b8
        skipped_ptr_2 = 0x2699c1
        new_glyph = hatred_glyph
      else
        skipped_ptr_1 = 0x26abb5
        skipped_ptr_2 = 0x26abbe
        new_glyph = anger_glyph
      end
      #skipped cutscene version uses evil compiler optimizations that rely on the glyph id being 0x40 or lower. We need to reorder them to allow higher glyph IDs (or just jump to empty space, but this works)
      @dra03[skipped_ptr_1] = [0xb9,0x01,0x00,0x00,0x00] #size 5. MOV ECX,0x1
      @dra03[skipped_ptr_2] = [0x8d,0x51,new_glyph-1] + [0x44,0x8d,0x49,0xbf] + [0x44,0x8d,0x41,0xe7] #size 11. LEA EDX,[RCX + (new_glyph-1)]; LEA R9D,[RCX + -0x41]; LEA r8D,[RCX + -0x19]
    end
  end

  def modify_other_event_glyph(subtype, new_glyph)
    case subtype
    when 0x2f #Luminatio
      glyph_code = 0x3a205
      flag_setter = 0x3a22c
      flag_checker = 0x3a1d2
      base_offset = [0x54,0x42,0x89,0x00]
      tests_byte = false
    when 0x3b #Pneuma
      glyph_code = 0x134d1a
      flag_setter = 0x134d13
      flag_checker = 0x134c16
      base_offset = [0x13,0x98,0x79,0x00]
      tests_byte = true
    when 0x44 #Lapiste
      glyph_code = 0x1d3421
      flag_setter = 0x1d3413
      flag_checker = 0x1d331b
      base_offset = [0x0e,0xb1,0x6f,0x00]
      tests_byte = true
    when 0x47 #Vol Grando
      glyph_code = 0x11d316
      flag_setter = 0x11d30f
      flag_checker = 0x11d96e
      base_offset = [0xbb,0x0a,0x7b,0x00]
      tests_byte = true
    when 0x4c #Vol Fulgur
      glyph_code = 0x15cc07
      flag_setter = 0x15cbf9
      flag_checker = 0x15caeb
      base_offset = [0x3b,0x19,0x77,0x00]
      tests_byte = false
    when 0x52 #Vol Ignis
      glyph_code = 0x1d969d
      flag_setter = 0x1d9696
      flag_checker = 0x1d9659
      base_offset = [0xd0,0x4d,0x6f,0x00]
      tests_byte = true
    when 0x53 #Morbus
      glyph_code = 0x18ad72
      flag_setter = 0x18ad6b
      flag_checker = 0x18ad3b
      base_offset = [0xeb,0x36,0x74,0x00]
      tests_byte = false
    when 0x54 #Vol Umbra
      glyph_code = 0x1be87e
      flag_setter = 0x1be8b5
      flag_checker = 0x1be869
      base_offset = [0xbd,0xfb,0x70,0x00]
      tests_byte = false
    end

    #Determines which glyph is spawned
    @dra03[glyph_code] = new_glyph
    #Determines the pickup flag for the event (the glyph's id + 2)
    pickup_flag = new_glyph + 1
    @dra03[flag_setter] = pickup_flag
    #The code that checks whether the flag is set when you enter the room is inflexible. To avoid using extra free space, we'll calculate the flag location the same way the game does when it sets the flag.
    target_4byte_offset = 4 * (pickup_flag >> 5) #effectively 4 * (pickup_flag / 0x20)
    value_to_test = 1 << (pickup_flag & 0x1f) #counts which bit within a 4-byte sequence this is. (& 0x1f) is effectively (% 0x20)
    if tests_byte
      #That produced an offset within a 4-byte address, but in dominus version the code sometimes wants to test a single byte. let's just use strings to find which byte it is
      extra_offset = (value_to_test.to_s(16).size - 1) / 2
      bit_to_test = value_to_test.to_s(16)[0..-(extra_offset*2+1)].to_i(16)
      final_offset = relative_address(flag_checker,0x8cf030+target_4byte_offset+extra_offset,7)
      @dra03[flag_checker] = [0xf6,0x05] + final_offset + [bit_to_test] #size 7
      #Pneuma also has another check for the wind effect
      if subtype == 0x3b
        @dra03[0x1349c6] = [0xf6,0x05] + relative_address(0x1349c6,0x8cf030+target_4byte_offset+extra_offset,7) + [bit_to_test]
      end
    else
      #Some events still test the whole 4-byte value
      final_offset = relative_address(flag_checker,0x8cf030+target_4byte_offset,10)
      @dra03[flag_checker] = [0xf7,0x05] + final_offset + [value_to_test].pack("V").unpack("CCCC") #size 10
    end
  end

  def create_super_drop(drop_name)
    drop_table = {
      "Red Drops" => [0, 0x230f1ea6, "RED"],
      "Blue Drops" => [1, 0x230f1ebc, "BLUE"],
      "Green Drops" => [2, 0x230f1ed4, "GREEN"],
      "White Drops" => [3, 0x230f1eee, "WHITE"],
      "Black Drops" => [4, 0x230f1f08, "BLACK"]
    }
    drop_ptr = 0x2d9cd4 + 12*drop_table[drop_name][0]
    @dra03[drop_ptr+0xa, 2] = 0x1388 #5000 AP per use
    text_start = drop_table[drop_name][1]
    replace_text(text_start, drop_table[drop_name][2])
  end

  def replace_text(start_ptr, text)
    if text.class.method_defined?(:unpack)
      text = text.unpack("C*")
    end
    text.each_with_index do |c, i|
      @alldata[start_ptr+i*2] = c - 0x20
    end
  end

  def relative_address(source, dest, source_size)
    #The file offset doesn't line up with a clean 180000000. In order to avoid having to subtract 0xc00 from every memory address, the program will do it.
    #That means that the source and dest are using different schemes, but this is easier for my head.
    #Calculation will also be necessary to handle version differences in memory locations.
    dra03_offset = 0xc00
    version_offset = @options[:version] == "1.03" ? -0x30 : 0x0
    offset = [dest+version_offset-source-source_size-dra03_offset].pack("V").unpack("CCCC")
    return offset
  end

  def jump(source, dest, asm_opcode = :CALL)
    size = 5
    case asm_opcode
    when :CALL
      opcode = [0xe8]
    when :JMP
      opcode = [0xe9]
    when :JNE
      opcode = [0x0f,0x85]
      size = 6
    when :JE
      opcode = [0x0f,0x84]
      size = 6
    when :JB
      opcode = [0x0f,0x82]
      size = 6
    when :JAE
      opcode = [0x0f,0x83]
      size = 6
    else
      raise "Invalid jump opcode"
    end
    offset = [dest-source-size].pack("V").unpack("CCCC")
    return opcode + offset
  end

  def general_game_tweaks()
    #Add the seed to the New Game screen. For now we clip this to 17 characters.
    if @options[:seed].size > 18
      seed_text = @options[:seed][0..14] + "..."
    else
      seed_text = @options[:seed].unpack("C*") + [0x0a]
    end
    replace_text(0x230ffab6, seed_text)

    #Make changes to progression code depending on options.
    #Open world map is temporarily required until I finish adding other features.
    openworldmap = [0x83,0x0d] + relative_address(0x11f76a,0x8cf064,7) + [0xff] + \
                   [0x83,0x0d] + relative_address(0x11f76a+7,0x8cf068,7) + [0xff] #size 14. OR dword ptr [0x1808cf064],0xffffffff; OR dword ptr [0x1808cf068],0xffffffff

    unlockalbus = [0x81,0x0c,0x32,0x00,0x20,0x00,0x02] #size 7. OR dword ptr [RDX + RSI*0x1],0x2002000
    unlockvillagers = [0x81,0x0d] + relative_address(@freestart+7,0x8cf024,10) + [0x00,0x24,0x04,0x11] + \
                      [0x81,0x0d] + relative_address(@freestart+17,0x8cf028,10) + [0x81,0x88,0x88,0x00] #size 20. OR dword ptr [0x1808cf024],0x11042400; OR dword ptr [0x1808cf028],0x888881
    finishvillagers = [0xb8,0x01,0x00,0x00,0x00,0xc3] #size 6. MOV EAX,0x1; RET
    albusmemories = [0x81,0x25] + relative_address(@freestart+0x50,0x8cf020,10) + [0xff,0xff,0xff,0xfd] + \
                    @dra03[0x26c11d,1,6] + jump(@freestart+0x50+16,0x26c123,:JMP) #size 21. AND dword ptr [0x1808cf020],0x-02000000; (original code); JMP 0x18026cd23
    cerberus = @options[:rv_unlock_cerberus] ? ([0x83,0x0d] + relative_address(0x11f76a+14,0x8cf010,7) + [0x40]) : ([0xeb,0x09] + nop(5)) #size 7. OR dword ptr [0x1808cf010],0x40 --- Alternately jump to next code

    #open the world map
    @dra03[0x11f76a] = openworldmap + cerberus + nop(4) #size 25

    if @options[:rv_unlock_albus]
      @dra03[0x215a47] = jump(0x215a47,@freestart) #size 5. CALL 0x18028f0d0
      @dra03[@freestart] = unlockalbus + unlockvillagers + finishvillagers + nop(1) #size 34

      #fix flashbang on defeating albus
      @dra03[0x26c11d] = jump(0x26c11d,@freestart+0x50, :JMP) + nop(1) #size 5 (6 total). JMP 0x18028f120
      @dra03[@freestart+0x50] = albusmemories + nop(1) #size 22
    end

    #make Nikolai always spawn in Wygol Village even if you haven't gone to Monastery
    if @options[:rv_unlock_albus]
      #We won't run into the nastier problems with this solution because event flags are already set, so we can avoid jumping.
      @dra03[0x1976e6] = nop(6) #size 6
      @dra03[0x21532b] = nop(2) #size 2
    else
      #There may be an easier way to handle this, but we have to temporarily turn on the event flag for Monastery Albus and then restore the original flag state, which uses free space.
      @dra03[0x1976e4] = [0x50] + [0x83,0x0d] + relative_address(0x1976e4+1,0x8cf020,7) + [0x40] #size 8. PUSH RAX; OR dword ptr [0x1808cf020],0x40
      @dra03[0x197702] = jump(0x197702, @freestart, :JMP) #size 5. JMP 0x18028f0d0
      @dra03[@freestart] = jump(@freestart, 0x215230) + [0x5b] + [0x89,0x1d] + relative_address(@freestart+6,0x8cf020,6) + jump(@freestart+12,0x197707, :JMP) + nop(1) #size 17 (total 18.) CALL 0x180215e30; POP RBX;
                                                                                                                                                                        # MOV dword ptr [0x1808cf020],EBX; JMP 0x180198307
    end

    #make tickets usable before meeting Nikolai
    @dra03[0x23c1d3] = nop(2) #size 2

    #Move Irina to the left so that Ink can be talked to easier, since they start out overlapped and Irina takes precedence.
    @dra03[0x2be458] = 0x36

    #If you exit the lighthouse lower exit, which unlocks kalidus lower entrance, while never having gone to Kalidus, and then enter kalidus, the game crashes.
    #Fix that by marking the upper entrance explored in addition to the lower one.
    @dra03[0x27ac7] = [0x80,0x4a,0x01,0x0c,0x80,0x4a,0xe6,0x03] + nop(3) #size 8 (11 total.) OR byte ptr [RDX + 0x1],0xc; OR byte ptr [RDX + -0x1a],0x3
    #There will still be a hand icon which will select a nonexistent entrance, which you have to avoid by selecting a different one. Prevent this by just not spawning the hand.
    @dra03[0x2075d0] = nop(10)

    #Setting a number of events to have their conditions set to zero (no conditions, can be accessed whenever you want without doing something else first)
    #Albus in Minera
    @alldata[0x21a1e35a] = 0
    #End of Lighthouse cutscene
    @alldata[0x21a1e8f2] = 0
    #Albus in Skeleton Cave
    @alldata[0x21a21646] = 0
    #George in Skeleton Cave
    @alldata[0x21a21652] = 0
    #Albus in Giant's Dwelling
    @alldata[0x21a2053a] = 0
    #Pre-Albus in Oblivion Ridge
    @alldata[0x21a210d6] = 0
    #Albus in Oblivion Ridge
    @alldata[0x21a2108a] = 0
    #Beginning of Mystery Manor cutscene
    @alldata[0x21a20d76] = 0
    #Shanoa entering Dracula's Castle panning image
    @alldata[0x21a21f0a] = 0
    #Shanoa encountering Dracula
    @alldata[0x21a24df2] = 0

    #Changing the order of branches in Barlowe-related events so that the boss fight triggers before other events. Needs testing to be sure this is 100% done
    @dra03[0x110d18] = jump(0x110d18,0x111089,:JNE) #size 6. JNE 180111c89
    @dra03[0x110d21] = jump(0x110d21,0x111089,:JE) #size 6. JE 180111c89
    @dra03[0x110fec] = jump(0x110fec,0x111373,:JB) #size 6. JB 180111f73
    @dra03[0x110ff6] = jump(0x110ff6,0x111373,:JAE) #size 6. JAE 180111f73
    @dra03[0x1112b1] = jump(0x1112b1,0x110ea6,:JAE) #size 6. JAE 180111aa6

    #Removing the need for headgear that reveals hidden items
    if @options[:reveal_breakable_walls]
      @dra03[0x9e5a0] = nop(2)
    end
    if @options[:always_dowsing]
      @dra03[0x16cd31] = nop(2)
    end

    #Relics autoequip from breakable walls
    @dra03[0x3ccbc] = 0x50
  end

  def post_read_tweaks()
    if @options[:remove_area_names]
      @game.rooms.each do |room|
        room.entities.each do |entity|
          if entity.is_special_object? && entity.subtype == 0x55
            entity.type = 0
          end
        end
      end
    end

    albus_event = @game.get_entity_by_id("11-00-08_01")
    albus_event.type = 0
    if @options[:rv_unlock_albus]
      george_event = @game.get_entity_by_id("11-00-08_02")
      george_event.type = 0
    end
  end

  def change_cat_hint(cat, item, location, transformation)
    pickup_vague_area = ""
    if ["Dracula's Castle", "Mystery Manor", "Argila Swamp", "Large Cavern"].include?(location[:zone])
      pickup_vague_area = "northwest"
    elsif ["Training Hall", "Ecclesia", "Skeleton Cave", "Misty Forest Road", "Wygol Village", "Tymeo Mountains"].include?(location[:zone])
      pickup_vague_area = "southwest"
    elsif ["Oblivion Ridge", "Tristis Pass", "Giant's Dwelling", "Monastery"].include?(location[:zone])
      pickup_vague_area = "northeast"
    elsif ["Somnus Reef", "Minera Prison Island", "Lighthouse", "Kalidus Channel", "Ruvas Forest"].include?(location[:zone])
      pickup_vague_area = "southeast"
    end
    pickup_specific_area = location[:zone] == "Dracula's Castle" ? location[:subzone] : location[:zone]

    text_vague = "I hear #{item}".unpack("C*") + [0x06] + "is somewhere in the #{pickup_vague_area}!".unpack("C*") + [0x06,0x05,0x04,0x0a]
    text_specific = "My friends said #{item}".unpack("C*") + [0x06] + "is somewhere in #{pickup_specific_area}!".unpack("C*") + [0x06,0x05,0x04,0x0a]

    cat_text = {
      "Ink" => [0x2312b50a, 0x2312b5ac],
      "SoybeanFlour" => [0x2312b68a, 0x2312b766],
      "Tofu" => [0x2312b848, 0x2312b93c]
    }

    replace_text(cat_text[cat][0], text_vague)
    replace_text(cat_text[cat][1], text_specific)
  end

  def set_chosen_transformation(transformation)
    transformation_numbers = {
      "Arma Felix" => 1,
      "Arma Chiroptera" => 2,
      "Arma Machina" => 3
    }

    if @options[:rv_unlock_cerberus]
      #changing the transformation that can talk to cats
      @dra03[0x15d79c] = [0x80,0x3d] + relative_address(0x15d79c,0x8cf42a,7) + [transformation_numbers[transformation]] #size 7. CMP byte ptr [0x1808cf42a],transformation_numbers[transformation]
    else
      #When Cerberus is locked hints are less effective so we'll give all transformations catspeak. Check that the player number isn't 0 (Shanoa)
      @dra03[0x15d79c] = [0x80,0x3d] + relative_address(0x15d79c,0x8cf42a,7) + [0] #size 7. CMP byte ptr [0x1808cf42a],0
      @dra03[0x15d7a3] = [0x74,0x17] #size 2. JE 0x18015e3bc
    end

    #changing the text description to indicate this
    descriptions = {
      "Arma Felix" => [0x230f42ea, "Cat form.".unpack("C*") + [0x06] + "Speaks with cats.".unpack("C*") + [0x06,0x0a]],
      "Arma Chiroptera" => [0x230f4324, "Bat form.".unpack("C*") + [0x06] + "Speaks with cats.".unpack("C*") + [0x06,0x0a]],
      "Arma Machina" => [0x230f435e, "Automaton form.".unpack("C*") + [0x06] + "Speaks with cats.".unpack("C*") + [0x0a]],
    }

    if @options[:rv_unlock_cerberus]
      offset, desc = descriptions[transformation]
      replace_text(offset, desc)
    else
      descriptions.each do |key, value|
        offset, desc = value
        replace_text(offset, desc)
      end
    end
  end

  def owned_item_byte(item_id)
    # 1808cf081 is where the list of owned items starts. Add the item id to get owned item data.
    return 0x8cf081 + item_id
  end

  def change_hardcoded_shop_pools(item_ids)
    #It's needless, but this is used to squeeze nicely into the existing operation sizes. Could just nop everything, however, as the calculations that keep writing into rcx are unnecessary after shop is randomized.
    reset_cl = [0xb1,0x20] #size 2. MOV CL,0x20
    #This function will receive the actual item id+1, so we start from 0x8cf080, not 0x8cf081

    #Pool 0 (default shop)
    @dra03[0x2229f9] = reset_cl
    @dra03[0x222a02] = [0x08,0x0d] + relative_address(0x222a02, 0x8cf080+item_ids[0][0], 6) #size 6. OR byte ptr [0x1808cf080+item_id],CL
    @dra03[0x222a1d] = reset_cl + nop(1)
    @dra03[0x222a23] = [0x08,0x0d] + relative_address(0x222a23, 0x8cf080+item_ids[0][1], 6) #size 6. OR byte ptr [0x1808cf080+item_id],CL
    @dra03[0x222a4c] = reset_cl
    @dra03[0x222a4e] = [0x08,0x0d] + relative_address(0x222a4e, 0x8cf080+item_ids[0][2], 6) + nop(1) #size 6 (7 in total.) OR byte ptr [0x1808cf080+item_id],CL; NOP
    @dra03[0x222a5b] = [0x08,0x0d] + relative_address(0x222a5b, 0x8cf080+item_ids[0][3], 6) #size 6. OR byte ptr [0x1808cf080+item_id],CL
    @dra03[0x222a74] = reset_cl
    @dra03[0x222a7f] = [0x08,0x0d] + relative_address(0x222a7f, 0x8cf080+item_ids[0][4], 6) #size 6. OR byte ptr [0x1808cf080+item_id],CL
    @dra03[0x222aa2] = [0x08,0x0d] + relative_address(0x222aa2, 0x8cf080+item_ids[0][5], 6) + nop(1) #size 6 (7 in total.) OR byte ptr [0x1808cf080+item_id],CL; NOP
    @dra03[0x222aac] = [0x08,0x0d] + relative_address(0x222aac, 0x8cf080+item_ids[0][6], 6) #size 6. OR byte ptr [0x1808cf080+item_id],CL

    #Pool 1 (Unlocked with Maneater)
    @dra03[0x222af4] = reset_cl + nop(1)
    @dra03[0x222af7] = [0x08,0x0d] + relative_address(0x222af7, 0x8cf080+item_ids[1][0], 6) #size 6. OR byte ptr [0x1808cf080+item_id],CL
    @dra03[0x222afd] = [0x08,0x0d] + relative_address(0x222afd, 0x8cf080+item_ids[1][1], 6) #size 6. OR byte ptr [0x1808cf080+item_id],CL
    @dra03[0x222b03] = [0x08,0x0d] + relative_address(0x222b03, 0x8cf080+item_ids[1][2], 6) #size 6. OR byte ptr [0x1808cf080+item_id],CL

    #Pool 2 (Unlocked with Goliath)
    @dra03[0x222b31] = reset_cl
    @dra03[0x222b33] = [0x08,0x0d] + relative_address(0x222b33, 0x8cf080+item_ids[2][0], 6) #size 6. OR byte ptr [0x1808cf080+item_id],CL
    @dra03[0x222b45] = reset_cl + nop(1)
    @dra03[0x222b4b] = [0x08,0x0d] + relative_address(0x222b4b, 0x8cf080+item_ids[2][1], 6) #size 6. OR byte ptr [0x1808cf080+item_id],CL
    @dra03[0x222b61] = reset_cl + nop(1)
    @dra03[0x222b64] = [0x08,0x0d] + relative_address(0x222b64, 0x8cf080+item_ids[2][2], 6) #size 6. OR byte ptr [0x1808cf080+item_id],CL
  end

  def set_price(item, price)
    #The items aren't in the data in ID order so we have to sort it out
    if OoEItems.consumables.has_key?(item[:name]) or OoEItems.materials.has_key?(item[:name])
      offset = item[:id] - 0x75
      consumable_ptr = 0x2d9b00 #Potion data
      @dra03[consumable_ptr + 12*offset + 4, 4] = price
    else #equipment
      if item[:type] == "Ring"
        offset = item[:id] - 0x13a #Protect Ring data
        equipment_ptr = 0x2da054
      elsif item[:type] == "Body"
        offset = item[:id] - 0xe6 #Casual Clothes data
        equipment_ptr = 0x2da364
      elsif item[:type] == "Head"
        offset = item[:id] - 0x101 #Eye for Decay data
        equipment_ptr = 0x2d9844
      else #Boots
        offset = item[:id] - 0x125 #Moonwalkers data
        equipment_ptr = 0x2d9644
      end
      @dra03[equipment_ptr + 20*offset + 4, 4] = price
    end
  end
end
