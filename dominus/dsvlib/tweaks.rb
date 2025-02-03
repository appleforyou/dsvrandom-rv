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
    #jumping nearby to calculate this differently
    @dra03[0x149844] = jump(0x149844,0x1498e5) + nop(1) #size 6. CALL 0x18014a4e5; NOP
    @dra03[0x1498e5] = [0x8d,0x50,0x1f,0x74,0x03,0x8d,0x58,anger_glyph-hatred_glyph,0xc3] + nop(1) #size 9. LEA EDX,[RAX + 0x1f]; JE 0x18028f108; LEA EBX,[RAX+(anger_glyph-hatred_glyph)]; RET

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
    finishvillagers = [0x31,0xc0,0xff,0xc0,0xc3] #size 5. XOR EAX,EAX; INC EAX; RET
    albusmemories = [0x81,0x25] + relative_address(@freestart+0x20,0x8cf020,10) + [0xff,0xff,0xff,0xfd] + \
                    @dra03[0x26c11d,1,6] + jump(@freestart+0x20+16,0x26c123,:JMP) #size 21. AND dword ptr [0x1808cf020],0x-02000000; (original code); JMP 0x18026cd23
    cerberus = @options[:rv_unlock_cerberus] ? ([0x83,0x0d] + relative_address(0x11f76a+14,0x8cf010,7) + [0x40]) : ([0xeb,0x09] + nop(5)) #size 7. OR dword ptr [0x1808cf010],0x40 --- Alternately jump to next code

    #open the world map
    @dra03[0x11f76a] = openworldmap + cerberus + nop(4) #size 25

    if @options[:rv_unlock_albus]
      @dra03[0x215a47] = jump(0x215a47,@freestart) #size 5. CALL 0x18028f0d0
      @dra03[@freestart] = unlockalbus + unlockvillagers + finishvillagers #size 32

      #fix flashbang on defeating albus
      @dra03[0x26c11d] = jump(0x26c11d,@freestart+0x20, :JMP) + nop(1) #size 5 (6 total). JMP 0x18028f120
      @dra03[@freestart+0x20] = albusmemories + nop(1) #size 22
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

    if @options[:reveal_enemy_info]
      reveal_bestiary()
    end
  end

  def normalize_glyph_sleeve()
    #Make Glyph Sleeve unnecessary.
    #Some aspects of this change require nulling out two lines, one for having the item and one for it being equipped.
    #In-battle glyph swapping
    @dra03[0xec853] = nop(6)
    @dra03[0xec85c] = nop(6)
    #In-battle glyph page icons
    @dra03[0xa5229] = nop(6)
    #Second screen glyph page icons
    @dra03[0x21971d] = nop(2)
    @dra03[0x219722] = nop(2)
    #Glyph menu (paused)
    #Swap pages in glyph menu
    @dra03[0x1e5cf3] = nop(2)
    #Glyph menu icons
    @dra03[0x1e64e2] = nop(6)
    @dra03[0x1e64eb] = nop(6)
    @dra03[0x1e6525] = nop(6)
    @dra03[0x1e652e] = nop(6)
    #Glyph menu button icons next to glyph names
    @dra03[0x6610e] = nop(6)
    @dra03[0x66117] = nop(2)
    @dra03[0x1e66ee] = nop(6)
    @dra03[0x1e6700] = nop(6)
    @dra03[0x1e517b] = nop(6)
    @dra03[0x1e5184] = nop(6)
  end

  def drain_sleeve
    #Check for whether the Glyph Sleeve relic is owned and equipped. Will be called from various places. Leaves the result in the zero flag.
    @sleeveteststart = @freestart + 0x40
    sleevetest = [0x50] + [0x8a,0x05] + relative_address(@sleeveteststart+1,0x8cf0f4,6) + \
                 [0xa8,0x0f] + [0x74,0x02] + [0x24,0x40] + [0x58,0xc3] + nop(1)           #size 15 (16 in total.) PUSH RAX; MOV AL,byte ptr [0x1808cf0f4]; TEST AL,0xf; JE (+2); AND AL,0x40; POP RAX; RET
    @dra03[@sleeveteststart] = sleevetest

    #Applies curse to yourself on page B or poison on page C.
    @sleevestart = @freestart + 0x50
    @dra03[0x218e88] = jump(0x218e88, @sleevestart, :JMP) + nop(3)
    #Rewriting the check for Glyph Sleeve to not pop RAX among other things, for convenience
    precheck = [0x50] + [0x8a,0x05] + relative_address(@sleevestart+1,0x8cf0f4,6) + \
                 [0xa8,0x0f] + [0x74,0x28] + [0x24,0x40] + [0x74,0x24]                      #size 15. PUSH RAX; MOV AL,byte ptr [0x1808cf0f4]; TEST AL,0xf; JE (exit_ptr); AND AL,0x40; JE (exit_ptr)
    @dra03[@sleevestart] = precheck
    n = precheck.size
    #Test which glyph page you are on
    poisonpagetest = [0x8a,0x05] + relative_address(@sleevestart+n,0x8cefac,6) + [0x41,0x83,0xfb,0x02] + [0x73,0x3a] #size 12. MOV AL,byte ptr [0x1808cefac]; CMP R11D,0x2; JAE (applypoison)
    @dra03[@sleevestart+n] = poisonpagetest
    n += poisonpagetest.size

    cursepagetest = [0x41,0x83,0xe3,0x01] + [0x75,0x18] #size 6. AND R11D,0x1; JNE (applypoison)
    @dra03[@sleevestart+n] = cursepagetest
    n += cursepagetest.size

    #If on page A, clear all status effects
    normalpage = [0x66,0xb8,0x01,0x00] + [0x66,0x89,0x05] + relative_address(@sleevestart+n+4,0x8cefae,7) + \
                 [0x66,0x89,0x05] + relative_address(@sleevestart+n+11,0x8cefb0,7) #size 18. MOV AX,0x1; MOV word ptr [0x1808cefae],AX; MOV word ptr [0x1808cefb0],AX
    @dra03[@sleevestart+n] = normalpage
    n += normalpage.size

    #Exit the function
    exitsleeve = [0x58] + jump(@sleevestart+n,0x218e90,:JMP) #size 6. POP RAX; JMP 0x180219a90
    @dra03[@sleevestart+n] = exitsleeve
    @exit_ptr = @sleevestart+n
    n += exitsleeve.size
    @cursestart = @sleevestart+n

    #Actually apply the curse
    applycurse1 = [0x8a,0x05] + relative_address(@sleevestart+n,0x8cefac, 6) + [0x24,0x02] + [0x75,@exit_ptr-(@sleevestart+n+10)] #size 10. MOV AL,byte ptr [0x1808cefac]; AND AL,0x2; JNE (exitptr)
    n += applycurse1.size
    applycurse2 = [0xc6,0x05] + relative_address(@sleevestart+n,0x8cefac, 7) + [0x02] #size 7. MOV byte ptr [0x1808cefac],0x2
    n += applycurse2.size
    applycurse3 = [0x66,0xc7,0x05] + relative_address(@sleevestart+n,0x8cefb0,9) + [0xb0,0x04] #size 9. MOV word ptr [0x1808cefb0],0x4b0
    n += applycurse3.size
    applycurse4 = [0xeb,@exit_ptr-(@sleevestart+n+2)] #size 2. JMP (exit_ptr)
    n += applycurse4.size
    applycurse = applycurse1 + applycurse2 + applycurse3 + applycurse4
    @dra03[@cursestart] = applycurse
    @poisonstart = @cursestart + applycurse.size

    #Actually apply the poison
    applypoison1 = [0x8a,0x05] + relative_address(@sleevestart+n,0x8cefac, 6) + [0x24,0x01] + [0x75,@exit_ptr-(@sleevestart+n+10)] #size 10. MOV AL,byte ptr [0x1808cefac]; AND AL,0x1; JNE (exitptr)
    n += applypoison1.size
    applypoison2 = [0xc6,0x05] + relative_address(@sleevestart+n,0x8cefac, 7) + [0x01] #size 7. MOV byte ptr [0x1808cefac],0x1
    n += applypoison2.size
    applypoison3 = [0x66,0xc7,0x05] + relative_address(@sleevestart+n,0x8cefae,9) + [0x00,0x04] #size 9. MOV word ptr [0x1808cefae],0x400
    n += applypoison3.size
    applypoison4 = [0xeb,@exit_ptr-(@sleevestart+n+2)] #size 2. JMP (exit_ptr)
    n += applypoison4.size
    @dra03[@poisonstart] = applypoison1 + applypoison2 + applypoison3 + applypoison4

    #Buff INT and MIND by 10 while poisoned instead of reducing them
    poisonbufftest = jump(@sleevestart+n,@sleeveteststart) + [0x74,0x06]  #size 7. CALL (@sleeveteststart) JE (poisondebuff)
    @dra03[@sleevestart+n] = poisonbufftest
    @dra03[0x177296] = jump(0x177296, @sleevestart+n)
    @dra03[0x1772a7] = jump(0x1772a7, @sleevestart+n)
    n += poisonbufftest.size
    poisonbuff = [0x03,0xc2] + [0x83,0xc0,0x0a] + [0xc3] #size 6. ADD EAX,EDX; ADD EAX,0xa; RET
    poisondebuff = [0x03,0xc2] + [0xc1,0xf8,0x02] + [0xc3] #size 6. ADD EAX,EDX; SAR EAX,0x2; RET
    @dra03[@sleevestart+n] = poisonbuff + poisondebuff
    n += poisonbuff.size + poisondebuff.size

    #Do not change STR while poisoned
    poisonnulltest = jump(@sleevestart+n,@sleeveteststart) + [0x74,0x06]  #size 7. CALL (@sleeveteststart) JE (+2)
    @dra03[@sleevestart+n] = poisonnulltest
    @dra03[0x177274] = jump(0x177274, @sleevestart+n)
    n += poisonnulltest.size
    poisonnull = [0xeb,0x05] + [0x03,0xc2] + [0xc1,0xf8,0x02] + [0xc3] #size 8. JMP (+5); ADD EAX,EDX; SAR EAX,0x2; RET
    @dra03[@sleevestart+n] = poisonnull
    n += poisonnull.size

    #While cursed, gain 1 heart when damaging enemies
    @dra03[0x139a5b] = jump(0x139a5b,@sleevestart+n)
    cursebuff1test = jump(@sleevestart+n,@sleeveteststart) + [0x74,0x2a] + [0xf6,0x05] + \
        relative_address(@sleevestart+n+7,0x8cefda,7) + [0x1] + [0x74,0x21]             #size 18. CALL (sleevetest); JE (+42); TEST byte ptr [0x1808cefda],0x1; JE (+33)
    @dra03[@sleevestart+n] = cursebuff1test
    n += cursebuff1test.size
    cursebuff1 = [0x66,0x8b,0x05] + relative_address(@sleevestart+n,0x8cef54,7) + [0x66,0x05,0x01,0x00] + \
                 [0x66,0x3b,0x05] + relative_address(@sleevestart+n+11,0x8cef56,7) + \
                 [0x66,0x0f,0x4f,0x05] + relative_address(@sleevestart+n+18,0x8cef56,8) + \
                 [0x66,0x89,0x05] + relative_address(@sleevestart+n+26,0x8cef54,7) + [0xc3] #size 34. MOV AX,word ptr [0x1808cef54]; ADD AX,0x1; CMP AX,word ptr [0x1808cef56];
                                                                                                     #CMOVG AX,word ptr [0x1808cef56]; MOV word ptr [0x1808cef54],AX
    @dra03[@sleevestart+n] = cursebuff1
    n += cursebuff1.size

    #Also halve MP costs while cursed
    @dra03[0x20f0e9] = jump(0x20f0e9,@sleevestart+n) + [0xeb,0x13] + nop(1) #size 7 (8 in total.) CALL (cursebuff2); JMP 0x18020fd03; NOP
    @dra03[0x20f103] = [0x66,0x44,0x29,0x0d] + relative_address(0x20f103,0x8cef50,8) + [0xeb,0xe4] #size 10. SUB word ptr [0x1808cef50],R9W; JMP 0x18020fcf1
    cursebuff2 = jump(@sleevestart+n,@sleeveteststart) + [0x74,0x0c] + [0xf6,0x05] + relative_address(@sleevestart+n+7,0x8cefda,7) + [0x1] + \
        [0x74,0x03] + [0x41,0xd1,0xe9] + [0xc3] #size 20. CALL (sleevetest); JE (+12); TEST byte ptr [0x1808cefda],0x1; JE (+3); RET
    @dra03[@sleevestart+n] = cursebuff2
    n += cursebuff2.size

    #Free space instructions must end on an odd byte or else the program will interpret the rest of the free space wrong and crash.
    if n % 2 != 0
      @dra03[@sleevestart+n] = nop(1)
    end

    #Make Volaticus not get canceled by these debuffs
    @dra03[0x1ba01a] = jump(0x1ba01a,0x1b9ce4,:JNE)
    @dra03[0x1b9ce4] = jump(0x1b9ce4,@sleeveteststart) + jump(0x1b9ce9,0x1bb163,:JMP) #size 10. CALL (sleevetest); JMP 0x1801bbd63
    @dra03[0x1bb163] = jump(0x1bb163,0x1ba138,:JE) + jump(0x1bb169,0x1ba020,:JMP) #size 11. JE 0x1801ba3d8, JMP 1801bac20

    #name
    replace_text(0x230f1ac2, "Drain".unpack("C*"))
    desc = "B: Drain Hearts.".unpack("C*") + [0x06] + "C: Buff INT/MND.".unpack("C*") + [0x0a]
    replace_text(0x230f4f0a, desc)
  end

  def shift_sleeve
    #Check for whether the Glyph Sleeve relic is owned and equipped. Will be called from various places. Leaves the result in the zero flag.
    @sleeveteststart = @freestart + 0x40
    sleevetest = [0x50] + [0x8a,0x05] + relative_address(@sleeveteststart+1,0x8cf0f4,6) + \
                 [0xa8,0x0f] + [0x74,0x02] + [0x24,0x40] + [0x58,0xc3] + nop(1)           #size 15 (16 in total.) PUSH RAX; MOV AL,byte ptr [0x1808cf0f4]; TEST AL,0xf; JE (+2); AND AL,0x40; POP RAX; RET
    @dra03[@sleeveteststart] = sleevetest

    @sleevestart = @freestart + 0x50
    @dra03[0xea87e] = [0x0f,0x95,0xc0] + jump(0xea87e+3,@sleevestart)
    frontdash1 = jump(@sleevestart,@sleeveteststart) + [0x74,0x16] + [0x80,0x3d] + relative_address(@sleevestart+7,0x8cefda,7) + [0x0] + [0x75,0x0d] #size 16. CALL (sleevetest); JE (+22);
                                                                                                                                                              #CMP byte ptr [0x1808cefda],0; jne (+13)
    #This will always be a negative number, so it will always turn positive. Might need to handle the sign more carefully if I change that somewhere else someday.
    frontdash2 = [0x48,0x63,0xbc,0x29,0x7c,0xc8,0x2b,0x00] + [0x48,0xf7,0xdf] + [0xeb,0x08] + \
        @dra03[0xea87e,1,8] + [0x85,0xc0] + [0xc3] #size 24. MOVSXD RDI,dword ptr [RCX+RBP+0x2bc87c]; NEG RDI; JMP (+8); (original code); TEST EAX,EAX; RET
    @dra03[@sleevestart] = frontdash1 + frontdash2
    n = frontdash1.size + frontdash2.size

    @dra03[0xe96ca] = jump(0xe96ca,@sleevestart+n) + nop(2) #size 7. CALL (superjump); nop(2)
    superjump = jump(@sleevestart+n,@sleeveteststart) + [0x74,0x11] + [0x66,0x83,0x3d] + relative_address(@sleevestart+n+7,0x8cef5c,8) + [0x3] + \
        [0x75,0x07] + [0x0f,0x94,0xc0] + [0x85,0xc0] + [0xeb,0x07] + @dra03[0xe96ca,1,7] + [0xc3] #size 32. CALL (sleevetest); JE (+17); CMP word ptr [0x1808cef5c],0x3;
                                                                                                                            #JNE (+7); SETE AL; TEST EAX,EAX; JMP (+7); (original code); RET
    @dra03[@sleevestart+n] = superjump
    n += superjump.size
    #Free space instructions must end on an odd byte or else the program will interpret the rest of the free space wrong and crash.
    if n % 2 != 0
      @dra03[@sleevestart+n] = nop(1)
    end

    #name
    replace_text(0x230f1ac2, "Shift".unpack("C*"))
    desc = "Volaticus page: ".unpack("C*") + [0x13] + " + ".unpack("C*") + [0x0b] + [0x06] + "A: Dash ahead.".unpack("C*") + [0x0a]
    replace_text(0x230f4f0a, desc)
  end

  def tooth_sleeve
    #Unlike most relevant memory addresses which have a consistent offset between 1.01 and 1.03, the RNG address is completely different.
    if @options[:version] == "1.03"
      rng_address = 0x8f50b4
    else
      rng_address = 0x8fc604
    end

    #todo: compress this someday, free space is tight and it'd be nice to add more effects too

    #Check for whether the Glyph Sleeve relic is owned and equipped. Will be called from various places. This time all effects are in page C so check that too. Leaves the result in the zero flag.
    @sleeveteststart = @freestart + 0x38
    sleevetest = [0x50] + [0x8a,0x05] + relative_address(@sleeveteststart+1,0x8cf0f4,6) + \
                 [0xa8,0x0f] + [0x74,0x0b] + [0x24,0x40] + [0x74,0x07] + [0xf6,0x05] + relative_address(@sleeveteststart+15,0x8cefda,7) + [0x02] + \
                 [0x58,0xc3]           #size 24. PUSH RAX; MOV AL,byte ptr [0x1808cf0f4]; TEST AL,0xf; JE (+11); AND AL,0x40; JE (+7); TEST byte ptr [0x1808cefda],0x2; POP RAX; RET
    @dra03[@sleeveteststart] = sleevetest

    @rngstart = @sleeveteststart+sleevetest.size
    advance_rng = [0x8b,0x05] + relative_address(@rngstart,rng_address,6) + @dra03[0x1fe54a,1,14] + \
        [0x89,0x05] + relative_address(@rngstart+20,rng_address,6) + [0xc3] #size 27. MOV EAX,dword ptr [0x1808fc604]; (original code); MOV dword ptr [0x1808fc604],EAX
    @dra03[@rngstart] = advance_rng

    @sleevestart = @rngstart+advance_rng.size
    @dra03[0x3b71a] = jump(0x3b71a,@sleevestart)
    eattest = [0x0f,0x95,0xc2] + jump(@sleevestart+3,@sleeveteststart) + [0x74,0x0d] #size 10. SETNE DL; CALL (sleevetest); JE (+13)
    @dra03[@sleevestart] = eattest
    n = eattest.size

    eat = jump(@sleevestart+n,@rngstart) + [0x83,0xe0,0x7f] + [0x84,0xd2] + [0x8b,0xd0] + [0xc3] + [0x84,0xd2] + @dra03[0x3b71a,1,5] + [0xc3] #size 21. CALL (advance_rng); AND EAX,0x7f; TEST DL,DL;
                                                                                                                                                      # MOV EDX,EAX; RET; TEST DL,DL; (original code); RET
    @dra03[@sleevestart+n] = eat
    n += eat.size

    @dra03[0x3b85c] = jump(0x3b85c,@sleevestart+n)
    spoiled = [0x50] + jump(@sleevestart+n+1,@sleeveteststart) + [0x74,0x0f] + jump(@sleevestart+n+8,@rngstart) + \
        [0x83,0xe0,0x7f] + [0x8b,0xd0] + [0x58] + [0x66,0x29,0xd0] + [0xc3] + [0x58] + @dra03[0x3b85c,1,5] + [0xc3] #size 30. PUSH RAX; CALL (sleevetest); JE (+15); CALL (advance_rng);
                                                                                                                            # AND EAX,0x7f; MOV EDX,EAX; POP RAX; SUB AX,DX; RET; POP RAX; (original code); RET
    @dra03[@sleevestart+n] = spoiled
    n += spoiled.size

    @dra03[0x3b7c2] = jump(0x3b7c2,@sleevestart+n)
    hearts = [0x50] + jump(@sleevestart+n+1,@sleeveteststart) + [0x74,0x0f] + jump(@sleevestart+n+8,@rngstart) + \
        [0x83,0xe0,0x0f] + [0x8b,0xd0] + [0x58] + [0x66,0x01,0xd0] + [0xc3] + [0x58] + @dra03[0x3b7c2,1,5] + [0xc3] #size 30. PUSH RAX; CALL (sleevetest); JE (+15); CALL (advance_rng);
                                                                                                                            # AND EAX,0x0f; MOV EDX,EAX; POP RAX; ADD AX,DX; RET; POP RAX; (original code); RET
    @dra03[@sleevestart+n] = hearts
    n += hearts.size

    @dra03[0x3b6d8] = jump(0x3b6d8,@sleevestart+n) + nop(2)
    choosetype = jump(@sleevestart+n,@sleeveteststart) + [0x74,0x21] + jump(@sleevestart+n+7,@rngstart) + [0x83,0xe0,0x07] + [0x75,0x07] + [0xb8,0x02,0x00,0x00,0x00] + [0xeb,0x14] + [0x83,0xe8,0x04] + [0x7e,0x07] + \
        [0xb8,0x07,0x00,0x00,0x00] + [0xeb,0x08] + [0x31,0xc0] + [0xeb,0x04] + @dra03[0x3b6d8,1,7] + [0xc3] #size 48. CALL (sleevetest); JE (+33); CALL (advance_rng); AND EAX,0x7; JNE (+7); MOV EAX,0x2;
                                                                                                                    # JMP (+20); SUB EAX,0x4; JLE (+7); MOV EAX,0x7; JMP (+8); XOR EAX,EAX; JMP (+4); (original code); RET
    @dra03[@sleevestart+n] = choosetype
    n += choosetype.size

    @dra03[0x23c181] = jump(0x23c181,@sleevestart+n)
    skipchecks1 = jump(@sleevestart+n,@sleeveteststart) + [0x74,0x03] + [0x31,0xc0] + [0xc3] + @dra03[0x23c181,1,5] + [0xc3] #size 16. CALL (sleevetest); JE (+3); XOR EAX,EAX; RET; (original code); RET
    @dra03[@sleevestart+n] = skipchecks1
    n += skipchecks1.size

    @dra03[0x23b352] = jump(0x23b352,@sleevestart+n,:JMP) + nop(2)
    skipchecks2 = jump(@sleevestart+n,@sleeveteststart) + [0x74,0x05] + jump(@sleevestart+n+7,0x23b373,:JMP) + @dra03[0x23b352,1,7] + jump(@sleevestart+n+19,0x23b359,:JMP)
    @dra03[@sleevestart+n] = skipchecks2
    n += skipchecks2.size

    #Free space instructions must end on an odd byte or else the program will interpret the rest of the free space wrong and crash.
    if (@sleevestart+n) % 2 != 0
      @dra03[@sleevestart+n] = nop(1)
    end

    #name
    replace_text(0x230f1ac2, "Tooth".unpack("C*"))
    desc = "C: Eat ANY item".unpack("C*") + [0x06] + "for random effects.".unpack("C*") + [0x0a]
    replace_text(0x230f4f0a, desc)
  end

  def slide_sleeve()
    #Check for whether the Glyph Sleeve relic is owned and equipped. Will be called from various places. Leaves the result in the zero flag.
    @sleeveteststart = @freestart + 0x40
    sleevetest = [0x50] + [0x8a,0x05] + relative_address(@sleeveteststart+1,0x8cf0f4,6) + \
                 [0xa8,0x0f] + [0x74,0x02] + [0x24,0x40] + [0x58,0xc3] + nop(1)           #size 15 (16 in total.) PUSH RAX; MOV AL,byte ptr [0x1808cf0f4]; TEST AL,0xf; JE (+2); AND AL,0x40; POP RAX; RET
    @dra03[@sleeveteststart] = sleevetest

    @sleevestart = @freestart + 0x50
    @dra03[0xeaabc] = jump(0xeaabc,@sleevestart)
    slidebuff1 = jump(@sleevestart,@sleeveteststart) + [0x74,0x17] + [0x80,0x0d] + relative_address(@sleevestart+7,0x8fcec0,7) + [0x10] + \
        [0x66,0x83,0x3d] + relative_address(@sleevestart+14,0x8cef5c,8) + [0x4] + [0x75,0x06] + [0x81,0xc3,0x00,0x14,0x00,0x00] + @dra03[0xeaabc, 1, 5] + [0xc3] #size 36. CALL (sleevetest); JE (+23);
                                                                                        # OR byte ptr [0x1808fcec0],0x10; CMP word ptr [0x1808cef5c],0x4; JNE (+6); ADD EBX,0x1400; (original code); RET
    @dra03[@sleevestart] = slidebuff1
    n = slidebuff1.size

    #Free space instructions must end on an odd byte or else the program will interpret the rest of the free space wrong and crash.
    if (@sleevestart+n) % 2 != 0
      @dra03[@sleevestart+n] = nop(1)
    end

    #name
    replace_text(0x230f1ac2, "Slide".unpack("C*"))
    desc = "Slide past foes.".unpack("C*") + [0x06] + "Rapidus page: +range.".unpack("C*") + [0x0a]
    replace_text(0x230f4f0a, desc)
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
      if @options[:rv_hint_cat_locations] == "Randomized Among Villager Locations"
        george_event.x_pos = 0x50
        george_event.y_pos = 0xa0
      end
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

  def reveal_bestiary()
    #Skip checking for whether you've killed an enemy for top screen hp/exp
    #@dra03[0x2192e1] = nop(2)
    #Skip checking for top screen hp
    @dra03[0x219163] = [0x8b,0xd1] + nop(1) #size 2 (3 in total.) MOV EDX,ECX; NOP
    #Skip checking for top screen exp
    @dra03[0x21919f] = [0x8b,0xd1] + nop(1) #size 2 (3 in total.) MOV EDX,ECX; NOP
    #Skip checking for weaknesses/resistances
    @dra03[0x2198ad] = nop(2)
    #Skip checking for item 1 having been acquired
    #@dra03[0x2191f3] = jump(0x2191f3,0x2192a6,:JMP) + nop(1) #size 5 (6 in total.) JMP 0x180219ea6; NOP
    #(Alternately, not also) check for whether you have Book of Spirits
    #Overwrite some unnecessary code to check for Book of Spirits. This will be used as an isolated code space to jump to.
    @dra03[0x2192d4] = [0x8b,0x05] + relative_address(0x2192d4,0x8cf0f4,6) #size 6. MOV EAX,[0x1808cf0f4]
    @dra03[0x2192da] = [0x0f,0xba,0xe0,0x0e] #size 4. BT EAX,0xe
    @dra03[0x2192de] = [0x73,0xca] #size 2. JAE 0x180219eaa
    @dra03[0x2192e0] = [0xeb,0xc4] + nop(1) #size 2 (3 in total.) JMP 0x180219ea6; NOP
    #The standard code will jump over our custom code from the previous instruction. It will only be accessed by a jump.
    @dra03[0x2192d2] = [0xeb,0x0f] #size 2. JMP 0x180219ee3
    #Jump to custom Book of Spirits code when enemy drop 1 hasn't been seen
    @dra03[0x2191f3] = jump(0x2191f3,0x2192d4,:JAE) #size 6. JAE 0x180219ed4
    #Skip checking for item 2 having been acquired
    #@dra03[0x219247] = [0xeb,0x5d] #size 2. JMP 0x180219ea6
    #(Alternately, not also) check for whether you have Book of Spirits
    #No code space for a full jump, so do an intermediate jump to the item 1 code when enemy drop 2 hasn't been seen.
    @dra03[0x219247] = [0x73,0xaa] #size 2. JAE 0x180219df3
    #Skip checking for glyph having been acquired
    #@dra03[0x2192a4] = nop(2)
    #(Alternately, not also) check for whether you have Book of Spirits
    #Jump to custom Book of Spirits code when enemy glyph hasn't been seen
    @dra03[0x2192a4] = [0x74,0x2e] #size 2. JE 0x180219ed4
  end

  def fix_bossrush_arthroverta()
    #Arthroverta's Revenge makes bossrush strange by deleting the original boss.
    #This is a rough bandaid fix that auto-unlocks the bossrush teleporter until I have time to check how to change the boss rush room
    #Doesn't actually work for real use as it also unlocks the boss door in arthroverta's new room. Needs more research
    #@dra03[0x10f333] = jump(0x10f333,0x10f4e7,:JMP)
    #@dra03[0x10f4e7] = [0x83,0xf9,0x01] + jump(0x10f4ea,0x10f644,:JMP)
    #@dra03[0x10f644] = jump(0x10f644,0x10f338,:JE) + jump(0x10f64a,0x10fd03,:JMP)
    #@dra03[0x10fd03] = [0x0f,0xa3,0xc8] + jump(0x10fd06,0x110184,:JMP)
    #@dra03[0x110184] = jump(0x110184,0x10f348,:JAE) + jump(0x11018a,0x10f338,:JMP)

    #Instead just make Arthroverta already dead in boss rush for now
    @dra03[0x9c425] = 0x2
  end

  def change_item_text_for_static_requirement(item_name, new_text)
    case item_name
    when "Cotton Thread"
      text_ptr = 0x230f21be
    when "Silk Thread"
      text_ptr = 0x230f21dc
    when "Cashmere Thread"
      text_ptr = 0x230f21f6
    when "Mandrake Root"
      text_ptr = 0x230f2244
    when "Merman Meat"
      text_ptr = 0x230f2262
    when "Iron Ore"
      text_ptr = 0x230f2344
    when "Silver Ore"
      text_ptr = 0x230f2358
    when "Gold Ore"
      text_ptr = 0x230f2370
    end
    new_text = new_text.unpack("C*") + [0x0a]
    replace_text(text_ptr, new_text)
  end
end
