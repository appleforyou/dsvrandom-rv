=begin
** Form generated from reading ui file 'randomizer.ui'
**
** Created: Tue Feb 19 13:05:55 2019
**      by: Qt User Interface Compiler version 4.8.6
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_Randomizer
    attr_reader :verticalLayout
    attr_reader :tabWidget
    attr_reader :tab
    attr_reader :verticalLayout_2
    attr_reader :gridLayout
    attr_reader :clean_rom
    attr_reader :label_2
    attr_reader :label
    attr_reader :label_3
    attr_reader :output_folder
    attr_reader :seed
    attr_reader :clean_rom_browse_button
    attr_reader :output_folder_browse_button
    attr_reader :generate_seed_button
    attr_reader :groupBox_7
    attr_reader :verticalLayout_6
    attr_reader :horizontalLayout
    attr_reader :randomize_pickups
    attr_reader :randomize_boss_souls
    attr_reader :randomize_red_walls
    attr_reader :horizontalLayout_15
    attr_reader :randomize_portraits
    attr_reader :randomize_villagers
    attr_reader :widget
    attr_reader :horizontalLayout_2
    attr_reader :randomize_enemies
    attr_reader :randomize_enemy_drops
    attr_reader :randomize_enemy_stats
    attr_reader :horizontalLayout_12
    attr_reader :randomize_enemy_anim_speed
    attr_reader :randomize_enemy_tolerances
    attr_reader :widget_2
    attr_reader :horizontalLayout_11
    attr_reader :randomize_consumable_behavior
    attr_reader :randomize_weapon_behavior
    attr_reader :randomize_skill_behavior
    attr_reader :horizontalLayout_5
    attr_reader :randomize_equipment_stats
    attr_reader :randomize_skill_stats
    attr_reader :randomize_weapon_and_skill_elements
    attr_reader :horizontalLayout_13
    attr_reader :randomize_shop
    attr_reader :randomize_wooden_chests
    attr_reader :randomize_weapon_synths
    attr_reader :horizontalLayout_4
    attr_reader :randomize_rooms_map_friendly
    attr_reader :randomize_starting_room
    attr_reader :widget_3
    attr_reader :horizontalLayout_17
    attr_reader :randomize_room_connections
    attr_reader :randomize_area_connections
    attr_reader :experimental_options_enabled
    attr_reader :verticalLayout_3
    attr_reader :horizontalLayout_9
    attr_reader :randomize_players
    attr_reader :randomize_bosses
    attr_reader :randomize_world_map_exits
    attr_reader :horizontalLayout_8
    attr_reader :randomize_enemy_ai
    attr_reader :randomize_enemy_sprites
    attr_reader :randomize_boss_sprites
    attr_reader :tab_3
    attr_reader :verticalLayout_7
    attr_reader :horizontalLayout_16
    attr_reader :label_4
    attr_reader :difficulty_level
    attr_reader :horizontalLayout_14
    attr_reader :enable_glitch_reqs
    attr_reader :bonus_starting_items
    attr_reader :horizontalLayout_7
    attr_reader :rebalance_enemies_in_room_rando
    attr_reader :line
    attr_reader :label_5
    attr_reader :scrollArea
    attr_reader :scrollAreaWidgetContents
    attr_reader :formLayout_5
    attr_reader :tab_2
    attr_reader :verticalLayout_4
    attr_reader :groupBox_4
    attr_reader :gridLayout_2
    attr_reader :reveal_bestiary
    attr_reader :name_unnamed_skills
    attr_reader :unlock_all_modes
    attr_reader :scavenger_mode
    attr_reader :reveal_breakable_walls
    attr_reader :remove_area_names
    attr_reader :revise_item_descriptions
    attr_reader :groupBox
    attr_reader :gridLayout_3
    attr_reader :fix_luck
    attr_reader :no_touch_screen
    attr_reader :remove_slot_machines
    attr_reader :always_start_with_rare_ring
    attr_reader :unlock_boss_doors
    attr_reader :add_magical_tickets
    attr_reader :menace_to_somacula
    attr_reader :dos_new_style_map
    attr_reader :groupBox_2
    attr_reader :gridLayout_4
    attr_reader :fix_infinite_quest_rewards
    attr_reader :always_show_drop_percentages
    attr_reader :dont_randomize_change_cube
    attr_reader :por_short_mode
    attr_reader :skip_emblem_drawing
    attr_reader :por_nerf_enemy_resistances
    attr_reader :allow_mastering_charlottes_skills
    attr_reader :groupBox_3
    attr_reader :gridLayout_5
    attr_reader :summons_gain_extra_exp
    attr_reader :gain_extra_attribute_points
    attr_reader :always_dowsing
    attr_reader :open_world_map
    attr_reader :tab_5
    attr_reader :verticalLayout_8
    attr_reader :groupBox_5
    attr_reader :verticalLayout_9
    attr_reader :horizontalLayout_19
    attr_reader :randomize_bgm
    attr_reader :randomize_dialogue
    attr_reader :horizontalLayout_10
    attr_reader :randomize_player_sprites
    attr_reader :randomize_skill_sprites
    attr_reader :verticalSpacer
    attr_reader :tab_4
    attr_reader :verticalLayout_5
    attr_reader :label_6
    attr_reader :label_7
    attr_reader :paste_seed_info_field
    attr_reader :horizontalLayout_6
    attr_reader :horizontalSpacer_2
    attr_reader :read_seed_info_button
    attr_reader :option_description
    attr_reader :horizontalLayout_3
    attr_reader :about_button
    attr_reader :horizontalSpacer
    attr_reader :label_8
    attr_reader :num_seeds_to_create
    attr_reader :horizontalSpacer_3
    attr_reader :randomize_button
    #RV
    attr_reader :enable_rv
    attr_reader :rv_difficulty
    attr_reader :rv_open_castle
    attr_reader :rv_unlock_albus
    attr_reader :rv_split_pools
    attr_reader :rv_puzzle_progression

    def setupUi(randomizer)
    if randomizer.objectName.nil?
        randomizer.objectName = "randomizer"
    end
    randomizer.resize(725, 649)
    icon = Qt::Icon.new
    icon.addPixmap(Qt::Pixmap.new("dsvrandom/images/dsvrandom_icon.png"), Qt::Icon::Normal, Qt::Icon::Off)
    randomizer.windowIcon = icon
    @verticalLayout = Qt::VBoxLayout.new(randomizer)
    @verticalLayout.objectName = "verticalLayout"
    @tabWidget = Qt::TabWidget.new(randomizer)
    @tabWidget.objectName = "tabWidget"
    @tab = Qt::Widget.new()
    @tab.objectName = "tab"
    @verticalLayout_2 = Qt::VBoxLayout.new(@tab)
    @verticalLayout_2.objectName = "verticalLayout_2"
    @gridLayout = Qt::GridLayout.new()
    @gridLayout.objectName = "gridLayout"
    @clean_rom = Qt::LineEdit.new(@tab)
    @clean_rom.objectName = "clean_rom"

    @gridLayout.addWidget(@clean_rom, 0, 1, 1, 1)

    @label_2 = Qt::Label.new(@tab)
    @label_2.objectName = "label_2"

    @gridLayout.addWidget(@label_2, 0, 0, 1, 1)

    @label = Qt::Label.new(@tab)
    @label.objectName = "label"

    @gridLayout.addWidget(@label, 2, 0, 1, 1)

    @label_3 = Qt::Label.new(@tab)
    @label_3.objectName = "label_3"

    @gridLayout.addWidget(@label_3, 1, 0, 1, 1)

    @output_folder = Qt::LineEdit.new(@tab)
    @output_folder.objectName = "output_folder"

    @gridLayout.addWidget(@output_folder, 1, 1, 1, 1)

    @seed = Qt::LineEdit.new(@tab)
    @seed.objectName = "seed"

    @gridLayout.addWidget(@seed, 2, 1, 1, 1)

    @clean_rom_browse_button = Qt::PushButton.new(@tab)
    @clean_rom_browse_button.objectName = "clean_rom_browse_button"

    @gridLayout.addWidget(@clean_rom_browse_button, 0, 2, 1, 1)

    @output_folder_browse_button = Qt::PushButton.new(@tab)
    @output_folder_browse_button.objectName = "output_folder_browse_button"

    @gridLayout.addWidget(@output_folder_browse_button, 1, 2, 1, 1)

    @generate_seed_button = Qt::PushButton.new(@tab)
    @generate_seed_button.objectName = "generate_seed_button"

    @gridLayout.addWidget(@generate_seed_button, 2, 2, 1, 1)


    @verticalLayout_2.addLayout(@gridLayout)
    
    @groupBox_7 = Qt::GroupBox.new(@tab)
    @groupBox_7.objectName = "groupBox_7"
    @verticalLayout_6 = Qt::VBoxLayout.new(@groupBox_7)
    @verticalLayout_6.objectName = "verticalLayout_6"
    @horizontalLayout_rv = Qt::HBoxLayout.new()
    @horizontalLayout_rv.objectName = "horizontalLayout_rv"
    @enable_rv = Qt::CheckBox.new(@groupBox_7)
    @enable_rv.objectName = "enable_rv"
    @enable_rv.checked = true

    @horizontalLayout_rv.addWidget(@enable_rv)
    @verticalLayout_6.addLayout(@horizontalLayout_rv)
    
    @horizontalLayout = Qt::HBoxLayout.new()
    @horizontalLayout.objectName = "horizontalLayout"
    @randomize_pickups = Qt::CheckBox.new(@groupBox_7)
    @randomize_pickups.objectName = "randomize_pickups"
    @randomize_pickups.checked = true

    @horizontalLayout.addWidget(@randomize_pickups)

    @randomize_boss_souls = Qt::CheckBox.new(@groupBox_7)
    @randomize_boss_souls.objectName = "randomize_boss_souls"
    @randomize_boss_souls.checked = true

    @horizontalLayout.addWidget(@randomize_boss_souls)
    
    @randomize_red_walls = Qt::CheckBox.new(@groupBox_7)
    @randomize_red_walls.objectName = "randomize_red_walls"

    @horizontalLayout.addWidget(@randomize_red_walls)


    @verticalLayout_6.addLayout(@horizontalLayout)

    @horizontalLayout_15 = Qt::HBoxLayout.new()
    @horizontalLayout_15.objectName = "horizontalLayout_15"
    @randomize_portraits = Qt::CheckBox.new(@groupBox_7)
    @randomize_portraits.objectName = "randomize_portraits"

    @horizontalLayout_15.addWidget(@randomize_portraits)

    @randomize_villagers = Qt::CheckBox.new(@groupBox_7)
    @randomize_villagers.objectName = "randomize_villagers"

    @horizontalLayout_15.addWidget(@randomize_villagers)

    @widget = Qt::Widget.new(@groupBox_7)
    @widget.objectName = "widget"

    @horizontalLayout_15.addWidget(@widget)


    @verticalLayout_6.addLayout(@horizontalLayout_15)

    @horizontalLayout_2 = Qt::HBoxLayout.new()
    @horizontalLayout_2.objectName = "horizontalLayout_2"
    @randomize_enemies = Qt::CheckBox.new(@groupBox_7)
    @randomize_enemies.objectName = "randomize_enemies"

    @horizontalLayout_2.addWidget(@randomize_enemies)

    @randomize_enemy_drops = Qt::CheckBox.new(@groupBox_7)
    @randomize_enemy_drops.objectName = "randomize_enemy_drops"
    @randomize_enemy_drops.checked = true

    @horizontalLayout_2.addWidget(@randomize_enemy_drops)

    @randomize_enemy_stats = Qt::CheckBox.new(@groupBox_7)
    @randomize_enemy_stats.objectName = "randomize_enemy_stats"

    @horizontalLayout_2.addWidget(@randomize_enemy_stats)


    @verticalLayout_6.addLayout(@horizontalLayout_2)

    @horizontalLayout_12 = Qt::HBoxLayout.new()
    @horizontalLayout_12.objectName = "horizontalLayout_12"
    @randomize_enemy_anim_speed = Qt::CheckBox.new(@groupBox_7)
    @randomize_enemy_anim_speed.objectName = "randomize_enemy_anim_speed"

    @horizontalLayout_12.addWidget(@randomize_enemy_anim_speed)

    @randomize_enemy_tolerances = Qt::CheckBox.new(@groupBox_7)
    @randomize_enemy_tolerances.objectName = "randomize_enemy_tolerances"

    @horizontalLayout_12.addWidget(@randomize_enemy_tolerances)

    @widget_2 = Qt::Widget.new(@groupBox_7)
    @widget_2.objectName = "widget_2"

    @horizontalLayout_12.addWidget(@widget_2)


    @verticalLayout_6.addLayout(@horizontalLayout_12)

    @horizontalLayout_11 = Qt::HBoxLayout.new()
    @horizontalLayout_11.objectName = "horizontalLayout_11"
    @randomize_consumable_behavior = Qt::CheckBox.new(@groupBox_7)
    @randomize_consumable_behavior.objectName = "randomize_consumable_behavior"

    @horizontalLayout_11.addWidget(@randomize_consumable_behavior)

    @randomize_weapon_behavior = Qt::CheckBox.new(@groupBox_7)
    @randomize_weapon_behavior.objectName = "randomize_weapon_behavior"

    @horizontalLayout_11.addWidget(@randomize_weapon_behavior)

    @randomize_skill_behavior = Qt::CheckBox.new(@groupBox_7)
    @randomize_skill_behavior.objectName = "randomize_skill_behavior"

    @horizontalLayout_11.addWidget(@randomize_skill_behavior)


    @verticalLayout_6.addLayout(@horizontalLayout_11)

    @horizontalLayout_5 = Qt::HBoxLayout.new()
    @horizontalLayout_5.objectName = "horizontalLayout_5"
    @randomize_equipment_stats = Qt::CheckBox.new(@groupBox_7)
    @randomize_equipment_stats.objectName = "randomize_equipment_stats"

    @horizontalLayout_5.addWidget(@randomize_equipment_stats)

    @randomize_skill_stats = Qt::CheckBox.new(@groupBox_7)
    @randomize_skill_stats.objectName = "randomize_skill_stats"

    @horizontalLayout_5.addWidget(@randomize_skill_stats)

    @randomize_weapon_and_skill_elements = Qt::CheckBox.new(@groupBox_7)
    @randomize_weapon_and_skill_elements.objectName = "randomize_weapon_and_skill_elements"

    @horizontalLayout_5.addWidget(@randomize_weapon_and_skill_elements)


    @verticalLayout_6.addLayout(@horizontalLayout_5)

    @horizontalLayout_13 = Qt::HBoxLayout.new()
    @horizontalLayout_13.objectName = "horizontalLayout_13"
    @randomize_shop = Qt::CheckBox.new(@groupBox_7)
    @randomize_shop.objectName = "randomize_shop"
    @randomize_shop.checked = true

    @horizontalLayout_13.addWidget(@randomize_shop)

    @randomize_wooden_chests = Qt::CheckBox.new(@groupBox_7)
    @randomize_wooden_chests.objectName = "randomize_wooden_chests"
    @randomize_wooden_chests.checked = true

    @horizontalLayout_13.addWidget(@randomize_wooden_chests)

    @randomize_weapon_synths = Qt::CheckBox.new(@groupBox_7)
    @randomize_weapon_synths.objectName = "randomize_weapon_synths"

    @horizontalLayout_13.addWidget(@randomize_weapon_synths)


    @verticalLayout_6.addLayout(@horizontalLayout_13)

    @horizontalLayout_4 = Qt::HBoxLayout.new()
    @horizontalLayout_4.objectName = "horizontalLayout_4"
    @randomize_rooms_map_friendly = Qt::CheckBox.new(@groupBox_7)
    @randomize_rooms_map_friendly.objectName = "randomize_rooms_map_friendly"

    @horizontalLayout_4.addWidget(@randomize_rooms_map_friendly)

    @randomize_starting_room = Qt::CheckBox.new(@groupBox_7)
    @randomize_starting_room.objectName = "randomize_starting_room"

    @horizontalLayout_4.addWidget(@randomize_starting_room)

    @widget_3 = Qt::Widget.new(@groupBox_7)
    @widget_3.objectName = "widget_3"

    @horizontalLayout_4.addWidget(@widget_3)


    @verticalLayout_6.addLayout(@horizontalLayout_4)

    @horizontalLayout_17 = Qt::HBoxLayout.new()
    @horizontalLayout_17.objectName = "horizontalLayout_17"
    @randomize_room_connections = Qt::CheckBox.new(@groupBox_7)
    @randomize_room_connections.objectName = "randomize_room_connections"

    @horizontalLayout_17.addWidget(@randomize_room_connections)

    @randomize_area_connections = Qt::CheckBox.new(@groupBox_7)
    @randomize_area_connections.objectName = "randomize_area_connections"

    @horizontalLayout_17.addWidget(@randomize_area_connections)


    @verticalLayout_6.addLayout(@horizontalLayout_17)


    @verticalLayout_2.addWidget(@groupBox_7)

    @experimental_options_enabled = Qt::GroupBox.new(@tab)
    @experimental_options_enabled.objectName = "experimental_options_enabled"
    @experimental_options_enabled.checkable = true
    @experimental_options_enabled.checked = false
    @verticalLayout_3 = Qt::VBoxLayout.new(@experimental_options_enabled)
    @verticalLayout_3.objectName = "verticalLayout_3"
    @horizontalLayout_9 = Qt::HBoxLayout.new()
    @horizontalLayout_9.objectName = "horizontalLayout_9"
    @randomize_players = Qt::CheckBox.new(@experimental_options_enabled)
    @randomize_players.objectName = "randomize_players"

    @horizontalLayout_9.addWidget(@randomize_players)

    @randomize_bosses = Qt::CheckBox.new(@experimental_options_enabled)
    @randomize_bosses.objectName = "randomize_bosses"

    @horizontalLayout_9.addWidget(@randomize_bosses)

    @randomize_world_map_exits = Qt::CheckBox.new(@experimental_options_enabled)
    @randomize_world_map_exits.objectName = "randomize_world_map_exits"

    @horizontalLayout_9.addWidget(@randomize_world_map_exits)


    @verticalLayout_3.addLayout(@horizontalLayout_9)

    @horizontalLayout_8 = Qt::HBoxLayout.new()
    @horizontalLayout_8.objectName = "horizontalLayout_8"
    @randomize_enemy_ai = Qt::CheckBox.new(@experimental_options_enabled)
    @randomize_enemy_ai.objectName = "randomize_enemy_ai"

    @horizontalLayout_8.addWidget(@randomize_enemy_ai)

    @randomize_enemy_sprites = Qt::CheckBox.new(@experimental_options_enabled)
    @randomize_enemy_sprites.objectName = "randomize_enemy_sprites"

    @horizontalLayout_8.addWidget(@randomize_enemy_sprites)

    @randomize_boss_sprites = Qt::CheckBox.new(@experimental_options_enabled)
    @randomize_boss_sprites.objectName = "randomize_boss_sprites"

    @horizontalLayout_8.addWidget(@randomize_boss_sprites)


    @verticalLayout_3.addLayout(@horizontalLayout_8)


    @verticalLayout_2.addWidget(@experimental_options_enabled)

    @tabWidget.addTab(@tab, Qt::Application.translate("Randomizer", "Randomizer Settings", nil, Qt::Application::UnicodeUTF8))
    
    #RV tab
    @tab_rv = Qt::Widget.new()
    @tab_rv.objectName = "tab_rv"
    
    @verticalLayout_rv = Qt::VBoxLayout.new(@tab_rv)
    @verticalLayout_rv.objectName = "verticalLayout_7"
    @horizontalLayout_rv_1 = Qt::HBoxLayout.new()
    @horizontalLayout_rv_1.objectName = "horizontalLayout_rv_1"
    
    @label_rv_1 = Qt::Label.new(@tab_rv)
    @label_rv_1.objectName = "label_rv_1"
    @horizontalLayout_rv_1.addWidget(@label_rv_1)

    @rv_difficulty = Qt::ComboBox.new(@tab_rv)
    @rv_difficulty.objectName = "rv_difficulty"
    @horizontalLayout_rv_1.addWidget(@rv_difficulty)
    
    @verticalLayout_rv.addLayout(@horizontalLayout_rv_1)
    
    @horizontalLayout_rv_2 = Qt::HBoxLayout.new()
    @horizontalLayout_rv_2.objectName = "horizontalLayout_rv_2"
    
    @rv_open_castle = Qt::CheckBox.new(@tab_rv)
    @rv_open_castle.objectName = "rv_open_castle"
    @rv_open_castle.checked = true
    @rv_open_castle.enabled = false
    @horizontalLayout_rv_2.addWidget(@rv_open_castle)
    
    @rv_unlock_albus = Qt::CheckBox.new(@tab_rv)
    @rv_unlock_albus.objectName = "rv_unlock_albus"
    @rv_unlock_albus.checked = true
    @horizontalLayout_rv_2.addWidget(@rv_unlock_albus)
    
    @verticalLayout_rv.addLayout(@horizontalLayout_rv_2)
    
    @horizontalLayout_rv_3 = Qt::HBoxLayout.new()
    @horizontalLayout_rv_3.objectName = "horizontalLayout_rv_3"
    
    @rv_split_pools = Qt::CheckBox.new(@tab_rv)
    @rv_split_pools.objectName = "rv_split_pools"
    @rv_split_pools.checked = true
    @horizontalLayout_rv_3.addWidget(@rv_split_pools)
    
    @rv_puzzle_progression = Qt::CheckBox.new(@tab_rv)
    @rv_puzzle_progression.objectName = "rv_puzzle_progression"
    @rv_puzzle_progression.checked = true
    @horizontalLayout_rv_3.addWidget(@rv_puzzle_progression)
    
    @verticalLayout_rv.addLayout(@horizontalLayout_rv_3)
    
    @line_rv = Qt::Frame.new(@tab_rv)
    @line_rv.objectName = "line_rv"
    @line_rv.setFrameShape(Qt::Frame::HLine)
    @line_rv.setFrameShadow(Qt::Frame::Sunken)

    @verticalLayout_rv.addWidget(@line_rv)
    
    @label_rv_2 = Qt::Label.new(@tab_2)
    @label_rv_2.objectName = "label_rv_2"

    @verticalLayout_rv.addWidget(@label_rv_2)
    
    @verticalSpacer_rv = Qt::SpacerItem.new(20, 40, Qt::SizePolicy::Minimum, Qt::SizePolicy::Expanding)

    @verticalLayout_rv.addItem(@verticalSpacer_rv)

    
    
    @tabWidget.addTab(@tab_rv, Qt::Application.translate("Randomizer", "RV Settings", nil, Qt::Application::UnicodeUTF8))
    @tab_3 = Qt::Widget.new()
    @tab_3.objectName = "tab_3"
    @verticalLayout_7 = Qt::VBoxLayout.new(@tab_3)
    @verticalLayout_7.objectName = "verticalLayout_7"
    @horizontalLayout_16 = Qt::HBoxLayout.new()
    @horizontalLayout_16.objectName = "horizontalLayout_16"
    @label_4 = Qt::Label.new(@tab_3)
    @label_4.objectName = "label_4"

    @horizontalLayout_16.addWidget(@label_4)

    @difficulty_level = Qt::ComboBox.new(@tab_3)
    @difficulty_level.objectName = "difficulty_level"

    @horizontalLayout_16.addWidget(@difficulty_level)


    @verticalLayout_7.addLayout(@horizontalLayout_16)

    @horizontalLayout_14 = Qt::HBoxLayout.new()
    @horizontalLayout_14.objectName = "horizontalLayout_14"
    @enable_glitch_reqs = Qt::CheckBox.new(@tab_3)
    @enable_glitch_reqs.objectName = "enable_glitch_reqs"

    @horizontalLayout_14.addWidget(@enable_glitch_reqs)

    @bonus_starting_items = Qt::CheckBox.new(@tab_3)
    @bonus_starting_items.objectName = "bonus_starting_items"

    @horizontalLayout_14.addWidget(@bonus_starting_items)


    @verticalLayout_7.addLayout(@horizontalLayout_14)

    @horizontalLayout_7 = Qt::HBoxLayout.new()
    @horizontalLayout_7.objectName = "horizontalLayout_7"
    @rebalance_enemies_in_room_rando = Qt::CheckBox.new(@tab_3)
    @rebalance_enemies_in_room_rando.objectName = "rebalance_enemies_in_room_rando"

    @horizontalLayout_7.addWidget(@rebalance_enemies_in_room_rando)


    @verticalLayout_7.addLayout(@horizontalLayout_7)

    @line = Qt::Frame.new(@tab_3)
    @line.objectName = "line"
    @line.setFrameShape(Qt::Frame::HLine)
    @line.setFrameShadow(Qt::Frame::Sunken)

    @verticalLayout_7.addWidget(@line)

    @label_5 = Qt::Label.new(@tab_3)
    @label_5.objectName = "label_5"

    @verticalLayout_7.addWidget(@label_5)

    @scrollArea = Qt::ScrollArea.new(@tab_3)
    @scrollArea.objectName = "scrollArea"
    @scrollArea.frameShape = Qt::Frame::NoFrame
    @scrollArea.widgetResizable = true
    @scrollAreaWidgetContents = Qt::Widget.new()
    @scrollAreaWidgetContents.objectName = "scrollAreaWidgetContents"
    @scrollAreaWidgetContents.geometry = Qt::Rect.new(0, 0, 675, 378)
    @formLayout_5 = Qt::FormLayout.new(@scrollAreaWidgetContents)
    @formLayout_5.objectName = "formLayout_5"
    @formLayout_5.fieldGrowthPolicy = Qt::FormLayout::AllNonFixedFieldsGrow
    @scrollArea.setWidget(@scrollAreaWidgetContents)

    @verticalLayout_7.addWidget(@scrollArea)

    @tabWidget.addTab(@tab_3, Qt::Application.translate("Randomizer", "Difficulty Settings", nil, Qt::Application::UnicodeUTF8))
    @tab_2 = Qt::Widget.new()
    @tab_2.objectName = "tab_2"
    @verticalLayout_4 = Qt::VBoxLayout.new(@tab_2)
    @verticalLayout_4.objectName = "verticalLayout_4"
    @groupBox_4 = Qt::GroupBox.new(@tab_2)
    @groupBox_4.objectName = "groupBox_4"
    @gridLayout_2 = Qt::GridLayout.new(@groupBox_4)
    @gridLayout_2.objectName = "gridLayout_2"
    @reveal_bestiary = Qt::CheckBox.new(@groupBox_4)
    @reveal_bestiary.objectName = "reveal_bestiary"

    @gridLayout_2.addWidget(@reveal_bestiary, 1, 1, 1, 1)

    @name_unnamed_skills = Qt::CheckBox.new(@groupBox_4)
    @name_unnamed_skills.objectName = "name_unnamed_skills"
    @name_unnamed_skills.checked = true

    @gridLayout_2.addWidget(@name_unnamed_skills, 0, 1, 1, 1)

    @unlock_all_modes = Qt::CheckBox.new(@groupBox_4)
    @unlock_all_modes.objectName = "unlock_all_modes"
    @unlock_all_modes.checked = true

    @gridLayout_2.addWidget(@unlock_all_modes, 0, 2, 1, 1)

    @scavenger_mode = Qt::CheckBox.new(@groupBox_4)
    @scavenger_mode.objectName = "scavenger_mode"

    @gridLayout_2.addWidget(@scavenger_mode, 0, 0, 1, 1)

    @reveal_breakable_walls = Qt::CheckBox.new(@groupBox_4)
    @reveal_breakable_walls.objectName = "reveal_breakable_walls"

    @gridLayout_2.addWidget(@reveal_breakable_walls, 1, 0, 1, 1)

    @remove_area_names = Qt::CheckBox.new(@groupBox_4)
    @remove_area_names.objectName = "remove_area_names"
    @remove_area_names.checked = true

    @gridLayout_2.addWidget(@remove_area_names, 1, 2, 1, 1)

    @revise_item_descriptions = Qt::CheckBox.new(@groupBox_4)
    @revise_item_descriptions.objectName = "revise_item_descriptions"
    @revise_item_descriptions.checked = true

    @gridLayout_2.addWidget(@revise_item_descriptions, 2, 0, 1, 1)


    @verticalLayout_4.addWidget(@groupBox_4)

    @groupBox = Qt::GroupBox.new(@tab_2)
    @groupBox.objectName = "groupBox"
    @gridLayout_3 = Qt::GridLayout.new(@groupBox)
    @gridLayout_3.objectName = "gridLayout_3"
    @fix_luck = Qt::CheckBox.new(@groupBox)
    @fix_luck.objectName = "fix_luck"
    @fix_luck.checked = true

    @gridLayout_3.addWidget(@fix_luck, 0, 0, 1, 1)

    @no_touch_screen = Qt::CheckBox.new(@groupBox)
    @no_touch_screen.objectName = "no_touch_screen"
    @no_touch_screen.checked = true

    @gridLayout_3.addWidget(@no_touch_screen, 0, 1, 1, 1)

    @remove_slot_machines = Qt::CheckBox.new(@groupBox)
    @remove_slot_machines.objectName = "remove_slot_machines"

    @gridLayout_3.addWidget(@remove_slot_machines, 1, 0, 1, 1)

    @always_start_with_rare_ring = Qt::CheckBox.new(@groupBox)
    @always_start_with_rare_ring.objectName = "always_start_with_rare_ring"

    @gridLayout_3.addWidget(@always_start_with_rare_ring, 1, 2, 1, 1)

    @unlock_boss_doors = Qt::CheckBox.new(@groupBox)
    @unlock_boss_doors.objectName = "unlock_boss_doors"
    @unlock_boss_doors.checked = true

    @gridLayout_3.addWidget(@unlock_boss_doors, 0, 2, 1, 1)

    @add_magical_tickets = Qt::CheckBox.new(@groupBox)
    @add_magical_tickets.objectName = "add_magical_tickets"
    @add_magical_tickets.checked = true

    @gridLayout_3.addWidget(@add_magical_tickets, 1, 1, 1, 1)

    @menace_to_somacula = Qt::CheckBox.new(@groupBox)
    @menace_to_somacula.objectName = "menace_to_somacula"

    @gridLayout_3.addWidget(@menace_to_somacula, 2, 0, 1, 1)

    @dos_new_style_map = Qt::CheckBox.new(@groupBox)
    @dos_new_style_map.objectName = "dos_new_style_map"

    @gridLayout_3.addWidget(@dos_new_style_map, 2, 1, 1, 1)


    @verticalLayout_4.addWidget(@groupBox)

    @groupBox_2 = Qt::GroupBox.new(@tab_2)
    @groupBox_2.objectName = "groupBox_2"
    @gridLayout_4 = Qt::GridLayout.new(@groupBox_2)
    @gridLayout_4.objectName = "gridLayout_4"
    @fix_infinite_quest_rewards = Qt::CheckBox.new(@groupBox_2)
    @fix_infinite_quest_rewards.objectName = "fix_infinite_quest_rewards"
    @fix_infinite_quest_rewards.checked = true

    @gridLayout_4.addWidget(@fix_infinite_quest_rewards, 1, 1, 1, 1)

    @always_show_drop_percentages = Qt::CheckBox.new(@groupBox_2)
    @always_show_drop_percentages.objectName = "always_show_drop_percentages"

    @gridLayout_4.addWidget(@always_show_drop_percentages, 1, 2, 1, 1)

    @dont_randomize_change_cube = Qt::CheckBox.new(@groupBox_2)
    @dont_randomize_change_cube.objectName = "dont_randomize_change_cube"
    @dont_randomize_change_cube.checked = true

    @gridLayout_4.addWidget(@dont_randomize_change_cube, 0, 1, 1, 1)

    @por_short_mode = Qt::CheckBox.new(@groupBox_2)
    @por_short_mode.objectName = "por_short_mode"

    @gridLayout_4.addWidget(@por_short_mode, 0, 0, 1, 1)

    @skip_emblem_drawing = Qt::CheckBox.new(@groupBox_2)
    @skip_emblem_drawing.objectName = "skip_emblem_drawing"
    @skip_emblem_drawing.checked = true

    @gridLayout_4.addWidget(@skip_emblem_drawing, 1, 0, 1, 1)

    @por_nerf_enemy_resistances = Qt::CheckBox.new(@groupBox_2)
    @por_nerf_enemy_resistances.objectName = "por_nerf_enemy_resistances"
    @por_nerf_enemy_resistances.checked = true

    @gridLayout_4.addWidget(@por_nerf_enemy_resistances, 0, 2, 1, 1)

    @allow_mastering_charlottes_skills = Qt::CheckBox.new(@groupBox_2)
    @allow_mastering_charlottes_skills.objectName = "allow_mastering_charlottes_skills"
    @allow_mastering_charlottes_skills.checked = true

    @gridLayout_4.addWidget(@allow_mastering_charlottes_skills, 2, 0, 1, 1)


    @verticalLayout_4.addWidget(@groupBox_2)

    @groupBox_3 = Qt::GroupBox.new(@tab_2)
    @groupBox_3.objectName = "groupBox_3"
    @gridLayout_5 = Qt::GridLayout.new(@groupBox_3)
    @gridLayout_5.objectName = "gridLayout_5"
    @summons_gain_extra_exp = Qt::CheckBox.new(@groupBox_3)
    @summons_gain_extra_exp.objectName = "summons_gain_extra_exp"
    @summons_gain_extra_exp.checked = true

    @gridLayout_5.addWidget(@summons_gain_extra_exp, 1, 2, 1, 1)

    @gain_extra_attribute_points = Qt::CheckBox.new(@groupBox_3)
    @gain_extra_attribute_points.objectName = "gain_extra_attribute_points"

    @gridLayout_5.addWidget(@gain_extra_attribute_points, 1, 1, 1, 1)

    @always_dowsing = Qt::CheckBox.new(@groupBox_3)
    @always_dowsing.objectName = "always_dowsing"

    @gridLayout_5.addWidget(@always_dowsing, 1, 0, 1, 1)

    @open_world_map = Qt::CheckBox.new(@groupBox_3)
    @open_world_map.objectName = "open_world_map"
    @open_world_map.checked = true

    @gridLayout_5.addWidget(@open_world_map, 0, 0, 1, 1)


    @verticalLayout_4.addWidget(@groupBox_3)

    @tabWidget.addTab(@tab_2, Qt::Application.translate("Randomizer", "Game Tweaks", nil, Qt::Application::UnicodeUTF8))
    groupBox_3.raise()
    groupBox.raise()
    groupBox_2.raise()
    groupBox_4.raise()
    @tab_5 = Qt::Widget.new()
    @tab_5.objectName = "tab_5"
    @verticalLayout_8 = Qt::VBoxLayout.new(@tab_5)
    @verticalLayout_8.objectName = "verticalLayout_8"
    @groupBox_5 = Qt::GroupBox.new(@tab_5)
    @groupBox_5.objectName = "groupBox_5"
    @verticalLayout_9 = Qt::VBoxLayout.new(@groupBox_5)
    @verticalLayout_9.objectName = "verticalLayout_9"
    @horizontalLayout_19 = Qt::HBoxLayout.new()
    @horizontalLayout_19.objectName = "horizontalLayout_19"
    @randomize_bgm = Qt::CheckBox.new(@groupBox_5)
    @randomize_bgm.objectName = "randomize_bgm"

    @horizontalLayout_19.addWidget(@randomize_bgm)

    @randomize_dialogue = Qt::CheckBox.new(@groupBox_5)
    @randomize_dialogue.objectName = "randomize_dialogue"

    @horizontalLayout_19.addWidget(@randomize_dialogue)


    @verticalLayout_9.addLayout(@horizontalLayout_19)

    @horizontalLayout_10 = Qt::HBoxLayout.new()
    @horizontalLayout_10.objectName = "horizontalLayout_10"
    @randomize_player_sprites = Qt::CheckBox.new(@groupBox_5)
    @randomize_player_sprites.objectName = "randomize_player_sprites"

    @horizontalLayout_10.addWidget(@randomize_player_sprites)

    @randomize_skill_sprites = Qt::CheckBox.new(@groupBox_5)
    @randomize_skill_sprites.objectName = "randomize_skill_sprites"

    @horizontalLayout_10.addWidget(@randomize_skill_sprites)


    @verticalLayout_9.addLayout(@horizontalLayout_10)


    @verticalLayout_8.addWidget(@groupBox_5)

    @verticalSpacer = Qt::SpacerItem.new(20, 40, Qt::SizePolicy::Minimum, Qt::SizePolicy::Expanding)

    @verticalLayout_8.addItem(@verticalSpacer)

    @tabWidget.addTab(@tab_5, Qt::Application.translate("Randomizer", "Cosmetic", nil, Qt::Application::UnicodeUTF8))
    @tab_4 = Qt::Widget.new()
    @tab_4.objectName = "tab_4"
    @verticalLayout_5 = Qt::VBoxLayout.new(@tab_4)
    @verticalLayout_5.objectName = "verticalLayout_5"
    @label_6 = Qt::Label.new(@tab_4)
    @label_6.objectName = "label_6"

    @verticalLayout_5.addWidget(@label_6)

    @label_7 = Qt::Label.new(@tab_4)
    @label_7.objectName = "label_7"
    @label_7.wordWrap = true

    @verticalLayout_5.addWidget(@label_7)

    @paste_seed_info_field = Qt::TextEdit.new(@tab_4)
    @paste_seed_info_field.objectName = "paste_seed_info_field"

    @verticalLayout_5.addWidget(@paste_seed_info_field)

    @horizontalLayout_6 = Qt::HBoxLayout.new()
    @horizontalLayout_6.objectName = "horizontalLayout_6"
    @horizontalSpacer_2 = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @horizontalLayout_6.addItem(@horizontalSpacer_2)

    @read_seed_info_button = Qt::PushButton.new(@tab_4)
    @read_seed_info_button.objectName = "read_seed_info_button"

    @horizontalLayout_6.addWidget(@read_seed_info_button)


    @verticalLayout_5.addLayout(@horizontalLayout_6)

    @tabWidget.addTab(@tab_4, Qt::Application.translate("Randomizer", "Paste Seed Info", nil, Qt::Application::UnicodeUTF8))

    @verticalLayout.addWidget(@tabWidget)

    @option_description = Qt::Label.new(randomizer)
    @option_description.objectName = "option_description"
    @option_description.minimumSize = Qt::Size.new(0, 32)
    @option_description.wordWrap = true

    @verticalLayout.addWidget(@option_description)

    @horizontalLayout_3 = Qt::HBoxLayout.new()
    @horizontalLayout_3.objectName = "horizontalLayout_3"
    @about_button = Qt::PushButton.new(randomizer)
    @about_button.objectName = "about_button"

    @horizontalLayout_3.addWidget(@about_button)

    @horizontalSpacer = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @horizontalLayout_3.addItem(@horizontalSpacer)

    @label_8 = Qt::Label.new(randomizer)
    @label_8.objectName = "label_8"

    @horizontalLayout_3.addWidget(@label_8)

    @num_seeds_to_create = Qt::ComboBox.new(randomizer)
    @num_seeds_to_create.objectName = "num_seeds_to_create"
    @num_seeds_to_create.minimumSize = Qt::Size.new(75, 26)
    @num_seeds_to_create.maximumSize = Qt::Size.new(75, 26)

    @horizontalLayout_3.addWidget(@num_seeds_to_create)

    @horizontalSpacer_3 = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @horizontalLayout_3.addItem(@horizontalSpacer_3)

    @randomize_button = Qt::PushButton.new(randomizer)
    @randomize_button.objectName = "randomize_button"

    @horizontalLayout_3.addWidget(@randomize_button)


    @verticalLayout.addLayout(@horizontalLayout_3)

    Qt::Widget.setTabOrder(@clean_rom, @clean_rom_browse_button)
    Qt::Widget.setTabOrder(@clean_rom_browse_button, @output_folder)
    Qt::Widget.setTabOrder(@output_folder, @output_folder_browse_button)
    Qt::Widget.setTabOrder(@output_folder_browse_button, @seed)
    Qt::Widget.setTabOrder(@seed, @generate_seed_button)
    Qt::Widget.setTabOrder(@generate_seed_button, @enable_rv)
    Qt::Widget.setTabOrder(@enable_rv, @randomize_pickups)
    Qt::Widget.setTabOrder(@randomize_pickups, @randomize_boss_souls)
    Qt::Widget.setTabOrder(@randomize_boss_souls, @randomize_portraits)
    Qt::Widget.setTabOrder(@randomize_boss_souls, @randomize_red_walls)
    Qt::Widget.setTabOrder(@randomize_red_walls, @randomize_portraits)
    Qt::Widget.setTabOrder(@randomize_portraits, @randomize_villagers)
    Qt::Widget.setTabOrder(@randomize_villagers, @randomize_enemies)
    Qt::Widget.setTabOrder(@randomize_enemies, @randomize_enemy_drops)
    Qt::Widget.setTabOrder(@randomize_enemy_drops, @randomize_enemy_stats)
    Qt::Widget.setTabOrder(@randomize_enemy_stats, @randomize_enemy_anim_speed)
    Qt::Widget.setTabOrder(@randomize_enemy_anim_speed, @randomize_enemy_tolerances)
    Qt::Widget.setTabOrder(@randomize_enemy_tolerances, @randomize_consumable_behavior)
    Qt::Widget.setTabOrder(@randomize_consumable_behavior, @randomize_weapon_behavior)
    Qt::Widget.setTabOrder(@randomize_weapon_behavior, @randomize_skill_behavior)
    Qt::Widget.setTabOrder(@randomize_skill_behavior, @randomize_equipment_stats)
    Qt::Widget.setTabOrder(@randomize_equipment_stats, @randomize_skill_stats)
    Qt::Widget.setTabOrder(@randomize_skill_stats, @randomize_weapon_and_skill_elements)
    Qt::Widget.setTabOrder(@randomize_weapon_and_skill_elements, @randomize_shop)
    Qt::Widget.setTabOrder(@randomize_shop, @randomize_wooden_chests)
    Qt::Widget.setTabOrder(@randomize_wooden_chests, @randomize_weapon_synths)
    Qt::Widget.setTabOrder(@randomize_weapon_synths, @randomize_rooms_map_friendly)
    Qt::Widget.setTabOrder(@randomize_rooms_map_friendly, @randomize_starting_room)
    Qt::Widget.setTabOrder(@randomize_starting_room, @randomize_room_connections)
    Qt::Widget.setTabOrder(@randomize_room_connections, @randomize_area_connections)
    Qt::Widget.setTabOrder(@randomize_area_connections, @experimental_options_enabled)
    Qt::Widget.setTabOrder(@experimental_options_enabled, @randomize_players)
    Qt::Widget.setTabOrder(@randomize_players, @randomize_bosses)
    Qt::Widget.setTabOrder(@randomize_bosses, @randomize_world_map_exits)
    Qt::Widget.setTabOrder(@randomize_world_map_exits, @randomize_enemy_ai)
    Qt::Widget.setTabOrder(@randomize_enemy_ai, @randomize_enemy_sprites)
    Qt::Widget.setTabOrder(@randomize_enemy_sprites, @about_button)
    Qt::Widget.setTabOrder(@about_button, @num_seeds_to_create)
    Qt::Widget.setTabOrder(@num_seeds_to_create, @randomize_button)
    Qt::Widget.setTabOrder(@randomize_button, @tabWidget)
    Qt::Widget.setTabOrder(@tabWidget, @difficulty_level)
    Qt::Widget.setTabOrder(@difficulty_level, @enable_glitch_reqs)
    Qt::Widget.setTabOrder(@enable_glitch_reqs, @bonus_starting_items)
    Qt::Widget.setTabOrder(@bonus_starting_items, @rebalance_enemies_in_room_rando)
    Qt::Widget.setTabOrder(@rebalance_enemies_in_room_rando, @scrollArea)
    Qt::Widget.setTabOrder(@scrollArea, @scavenger_mode)
    Qt::Widget.setTabOrder(@scavenger_mode, @name_unnamed_skills)
    Qt::Widget.setTabOrder(@name_unnamed_skills, @unlock_all_modes)
    Qt::Widget.setTabOrder(@unlock_all_modes, @reveal_breakable_walls)
    Qt::Widget.setTabOrder(@reveal_breakable_walls, @reveal_bestiary)
    Qt::Widget.setTabOrder(@reveal_bestiary, @remove_area_names)
    Qt::Widget.setTabOrder(@remove_area_names, @revise_item_descriptions)
    Qt::Widget.setTabOrder(@revise_item_descriptions, @fix_luck)
    Qt::Widget.setTabOrder(@fix_luck, @no_touch_screen)
    Qt::Widget.setTabOrder(@no_touch_screen, @unlock_boss_doors)
    Qt::Widget.setTabOrder(@unlock_boss_doors, @remove_slot_machines)
    Qt::Widget.setTabOrder(@remove_slot_machines, @add_magical_tickets)
    Qt::Widget.setTabOrder(@add_magical_tickets, @always_start_with_rare_ring)
    Qt::Widget.setTabOrder(@always_start_with_rare_ring, @menace_to_somacula)
    Qt::Widget.setTabOrder(@menace_to_somacula, @dos_new_style_map)
    Qt::Widget.setTabOrder(@dos_new_style_map, @por_short_mode)
    Qt::Widget.setTabOrder(@por_short_mode, @dont_randomize_change_cube)
    Qt::Widget.setTabOrder(@dont_randomize_change_cube, @por_nerf_enemy_resistances)
    Qt::Widget.setTabOrder(@por_nerf_enemy_resistances, @skip_emblem_drawing)
    Qt::Widget.setTabOrder(@skip_emblem_drawing, @fix_infinite_quest_rewards)
    Qt::Widget.setTabOrder(@fix_infinite_quest_rewards, @always_show_drop_percentages)
    Qt::Widget.setTabOrder(@always_show_drop_percentages, @allow_mastering_charlottes_skills)
    Qt::Widget.setTabOrder(@allow_mastering_charlottes_skills, @open_world_map)
    Qt::Widget.setTabOrder(@open_world_map, @always_dowsing)
    Qt::Widget.setTabOrder(@always_dowsing, @gain_extra_attribute_points)
    Qt::Widget.setTabOrder(@gain_extra_attribute_points, @summons_gain_extra_exp)
    Qt::Widget.setTabOrder(@summons_gain_extra_exp, @randomize_bgm)
    Qt::Widget.setTabOrder(@randomize_bgm, @randomize_dialogue)
    Qt::Widget.setTabOrder(@randomize_dialogue, @paste_seed_info_field)
    Qt::Widget.setTabOrder(@paste_seed_info_field, @read_seed_info_button)

    retranslateUi(randomizer)

    @tabWidget.setCurrentIndex(0)


    Qt::MetaObject.connectSlotsByName(randomizer)
    end # setupUi

    def setup_ui(randomizer)
        setupUi(randomizer)
    end

    def retranslateUi(randomizer)
    randomizer.windowTitle = Qt::Application.translate("Randomizer", "DSVania Randomizer", nil, Qt::Application::UnicodeUTF8)
    @label_2.text = Qt::Application.translate("Randomizer", "Clean ROM", nil, Qt::Application::UnicodeUTF8)
    @label.text = Qt::Application.translate("Randomizer", "Seed (optional)", nil, Qt::Application::UnicodeUTF8)
    @label_3.text = Qt::Application.translate("Randomizer", "Output Folder", nil, Qt::Application::UnicodeUTF8)
    @clean_rom_browse_button.text = Qt::Application.translate("Randomizer", "Browse", nil, Qt::Application::UnicodeUTF8)
    @output_folder_browse_button.text = Qt::Application.translate("Randomizer", "Browse", nil, Qt::Application::UnicodeUTF8)
    @generate_seed_button.text = Qt::Application.translate("Randomizer", "New seed", nil, Qt::Application::UnicodeUTF8)
    @groupBox_7.title = Qt::Application.translate("Randomizer", "Randomization options", nil, Qt::Application::UnicodeUTF8)
    @enable_rv.toolTip = Qt::Application.translate("Randomizer", "RV logic (OoE only) has more options for item placement, intended for people who are familiar with the game and want to go fast. Not yet compatible with some features like map/villager randomization.", nil, Qt::Application::UnicodeUTF8)
    @enable_rv.text = Qt::Application.translate("Randomizer", "Use RV Options", nil, Qt::Application::UnicodeUTF8)
    @label_rv_1.text = Qt::Application.translate("Randomizer", "Item location difficulty level", nil, Qt::Application::UnicodeUTF8)
    @label_rv_1.toolTip = Qt::Application.translate("Randomizer", "This option affects which items are considered required to access locations. Does not affect many things (yet.) See the readme for details.", nil, Qt::Application::UnicodeUTF8)
    @rv_difficulty.toolTip = @label_rv_1.toolTip
    @rv_difficulty.addItem("Vanilla")
    @rv_difficulty.addItem("Creative")
    @rv_difficulty.addItem("Do Your Worst")
    @rv_difficulty.setCurrentIndex(1)
    @rv_open_castle.text = Qt::Application.translate("Randomizer", "Open world map + Dracula's Castle", nil, Qt::Application::UnicodeUTF8)
    @rv_open_castle.toolTip = Qt::Application.translate("Randomizer", "Like the Open World Map setting, but also enables access to Dracula's Castle without defeating Barlowe.", nil, Qt::Application::UnicodeUTF8)
    @rv_unlock_albus.text = Qt::Application.translate("Randomizer", "Unlock Albus/Barlowe", nil, Qt::Application::UnicodeUTF8)
    @rv_unlock_albus.toolTip = Qt::Application.translate("Randomizer", "If checked: From first visit to Wygol Village onwards, all villagers will be automatically rescued, which means Albus and Barlowe can be defeated without triggering the Bad Ending. See \"Boss Notes\" for details on the glyphs these bosses cast during fights.", nil, Qt::Application::UnicodeUTF8)
    @rv_split_pools.text = Qt::Application.translate("Randomizer", "Split pools for item/glyph locations", nil, Qt::Application::UnicodeUTF8)
    @rv_split_pools.toolTip = Qt::Application.translate("Randomizer", "If checked, glyphs can only appear at vanilla glyph locations, and items can only appear at vanilla item locations.", nil, Qt::Application::UnicodeUTF8)
    @rv_puzzle_progression.text = Qt::Application.translate("Randomizer", "Allow progression glyphs at Cubus/Morbus", nil, Qt::Application::UnicodeUTF8)
    @rv_puzzle_progression.toolTip = Qt::Application.translate("Randomizer", "If checked, progression items can be placed at locations which require certain elemental attack glyphs to solve the puzzle. Not recommended if skill behavior randomization is enabled.", nil, Qt::Application::UnicodeUTF8)
    rv_difficulties = <<~EOS
      Vanilla: A movement item is only considered progression if something is locked behind it in the original game.
      So, movement items other than Magnes, Ordinary Rock, Volaticus, and Serpent Scale are not considered progression.
      Additionally, progression is not at Training Hall, and Blackmore requires a fire- or light-type glyph.

      Creative: (Recommended) Adds more movement-focused progression items to item placement logic.
      The rule is: If the movement is what gets you over the gap, it goes in logic, except for point 2) below.

      Do Your Worst: No difficulty restrictions. Currently, this only changes four things from Creative:
      1) Waive elemental restrictions on castle bosses,
      2) Allow logical completion of Training Hall with only Redire and Magnes (no double jump),
      3) Allow traversing spikes with unintended methods,
      4) Allow entry to Arms Depot by divekicking off enemies.

      Boss notes: Albus, Barlowe, and Jiangshi cast glyphs during their battles. These are missable,
      so they can't be required to win the game. However, these glyphs are still randomized if "Enemy Drops" is enabled
      in the main tab. Jiangshi always has a duplicate progression glyph that appears somewhere else in the game.
      A hint on Jiangshi's glyph appears in the Albus cutscene in Monastery.
      Albus/Barlowe also have duplicate progression glyphs if "Unlock Albus/Barlowe" is not enabled.
      If it is enabled, their cast glyphs will draw from a less powerful pool in return for the ease of access.
      Barlowe will have a progression glyph, but only main/sub type (no back glyphs.) Albus will have any main/sub glyph.
      Note that these options have no effect on the glyph Albus drops upon defeat. That is handled like any normal glyph.

      What counts as a "progression" glyph for boss dupes?
      Any glyph that can allow you to reach items you couldn't reach with no glyphs, even if your difficulty option
      prevents them from being in logic.
      Also, light and fire glyphs are currently treated as progression. At least one is required by logic for Blackmore.
    EOS
    @label_rv_2.text = Qt::Application.translate("Randomizer", rv_difficulties, nil, Qt::Application::UnicodeUTF8)
    @randomize_pickups.toolTip = Qt::Application.translate("Randomizer", "Randomizes items and skills you find lying on the ground.", nil, Qt::Application::UnicodeUTF8)
    @randomize_pickups.text = Qt::Application.translate("Randomizer", "Item/Skill Locations", nil, Qt::Application::UnicodeUTF8)
    @randomize_boss_souls.toolTip = Qt::Application.translate("Randomizer", "Randomizes the souls dropped by bosses as well as Wallman's glyph (DoS/OoE only).", nil, Qt::Application::UnicodeUTF8)
    @randomize_boss_souls.text = Qt::Application.translate("Randomizer", "Boss Souls", nil, Qt::Application::UnicodeUTF8)
    @randomize_red_walls.toolTip = Qt::Application.translate("Randomizer", "Randomizes which bullet souls are needed to open red walls (DoS only).", nil, Qt::Application::UnicodeUTF8)
    @randomize_red_walls.text = Qt::Application.translate("Randomizer", "Red Soul Walls", nil, Qt::Application::UnicodeUTF8)
    @randomize_portraits.toolTip = Qt::Application.translate("Randomizer", "Randomizes where portraits are located (PoR only).", nil, Qt::Application::UnicodeUTF8)
    @randomize_portraits.text = Qt::Application.translate("Randomizer", "Portraits", nil, Qt::Application::UnicodeUTF8)
    @randomize_villagers.toolTip = Qt::Application.translate("Randomizer", "Randomizes where villagers are located (OoE only).", nil, Qt::Application::UnicodeUTF8)
    @randomize_villagers.text = Qt::Application.translate("Randomizer", "Villagers", nil, Qt::Application::UnicodeUTF8)
    @randomize_enemies.toolTip = Qt::Application.translate("Randomizer", "Randomizes which non-boss enemies appear where.", nil, Qt::Application::UnicodeUTF8)
    @randomize_enemies.text = Qt::Application.translate("Randomizer", "Enemy Locations", nil, Qt::Application::UnicodeUTF8)
    @randomize_enemy_drops.toolTip = Qt::Application.translate("Randomizer", "Randomizes the items, souls, and glyphs dropped by non-boss enemies, as well as their drop chances.", nil, Qt::Application::UnicodeUTF8)
    @randomize_enemy_drops.text = Qt::Application.translate("Randomizer", "Enemy Drops", nil, Qt::Application::UnicodeUTF8)
    @randomize_enemy_stats.toolTip = Qt::Application.translate("Randomizer", "Randomizes enemy attack, defense, HP, EXP given, and other stats.", nil, Qt::Application::UnicodeUTF8)
    @randomize_enemy_stats.text = Qt::Application.translate("Randomizer", "Enemy Stats", nil, Qt::Application::UnicodeUTF8)
    @randomize_enemy_anim_speed.toolTip = Qt::Application.translate("Randomizer", "Randomizes the speed at which each enemy's animations play at, which affects their attack speed.", nil, Qt::Application::UnicodeUTF8)
    @randomize_enemy_anim_speed.text = Qt::Application.translate("Randomizer", "Enemy Animation Speed", nil, Qt::Application::UnicodeUTF8)
    @randomize_enemy_tolerances.toolTip = Qt::Application.translate("Randomizer", "Randomizes enemy elemental weaknesses and resistances.", nil, Qt::Application::UnicodeUTF8)
    @randomize_enemy_tolerances.text = Qt::Application.translate("Randomizer", "Enemy Tolerances", nil, Qt::Application::UnicodeUTF8)
    @randomize_consumable_behavior.toolTip = Qt::Application.translate("Randomizer", "Randomizes what consumables do and how powerful they are.", nil, Qt::Application::UnicodeUTF8)
    @randomize_consumable_behavior.text = Qt::Application.translate("Randomizer", "Consumable Behavior", nil, Qt::Application::UnicodeUTF8)
    @randomize_weapon_behavior.toolTip = Qt::Application.translate("Randomizer", "Randomizes how weapons behave.", nil, Qt::Application::UnicodeUTF8)
    @randomize_weapon_behavior.text = Qt::Application.translate("Randomizer", "Weapon Behavior", nil, Qt::Application::UnicodeUTF8)
    @randomize_skill_behavior.toolTip = Qt::Application.translate("Randomizer", "Randomizes how skills behave.", nil, Qt::Application::UnicodeUTF8)
    @randomize_skill_behavior.text = Qt::Application.translate("Randomizer", "Skill Behavior", nil, Qt::Application::UnicodeUTF8)
    @randomize_equipment_stats.toolTip = Qt::Application.translate("Randomizer", "Randomizes weapon and armor stats.", nil, Qt::Application::UnicodeUTF8)
    @randomize_equipment_stats.text = Qt::Application.translate("Randomizer", "Equipment Stats", nil, Qt::Application::UnicodeUTF8)
    @randomize_skill_stats.toolTip = Qt::Application.translate("Randomizer", "Randomizes skill stats.", nil, Qt::Application::UnicodeUTF8)
    @randomize_skill_stats.text = Qt::Application.translate("Randomizer", "Skill Stats", nil, Qt::Application::UnicodeUTF8)
    @randomize_weapon_and_skill_elements.toolTip = Qt::Application.translate("Randomizer", "Randomizes what elemental damage types and status effects each weapon/skill does.", nil, Qt::Application::UnicodeUTF8)
    @randomize_weapon_and_skill_elements.text = Qt::Application.translate("Randomizer", "Weapon and Skill Elements", nil, Qt::Application::UnicodeUTF8)
    @randomize_shop.toolTip = Qt::Application.translate("Randomizer", "Randomizes what items are for sale in the shop as well as item prices.", nil, Qt::Application::UnicodeUTF8)
    @randomize_shop.text = Qt::Application.translate("Randomizer", "Shop Items", nil, Qt::Application::UnicodeUTF8)
    @randomize_wooden_chests.toolTip = Qt::Application.translate("Randomizer", "Randomizes the pool of items for wooden chests in each area (OoE only).", nil, Qt::Application::UnicodeUTF8)
    @randomize_wooden_chests.text = Qt::Application.translate("Randomizer", "Wooden Chest Items", nil, Qt::Application::UnicodeUTF8)
    @randomize_weapon_synths.toolTip = Qt::Application.translate("Randomizer", "Randomizes which items Yoko can synthesize (DoS only).", nil, Qt::Application::UnicodeUTF8)
    @randomize_weapon_synths.text = Qt::Application.translate("Randomizer", "Weapon Synthesis", nil, Qt::Application::UnicodeUTF8)
    @randomize_rooms_map_friendly.toolTip = Qt::Application.translate("Randomizer", "Randomly generates entirely new maps and connects rooms to match the map.", nil, Qt::Application::UnicodeUTF8)
    @randomize_rooms_map_friendly.text = Qt::Application.translate("Randomizer", "Maps", nil, Qt::Application::UnicodeUTF8)
    @randomize_starting_room.toolTip = Qt::Application.translate("Randomizer", "Randomizes which room you start in.", nil, Qt::Application::UnicodeUTF8)
    @randomize_starting_room.text = Qt::Application.translate("Randomizer", "Starting Room", nil, Qt::Application::UnicodeUTF8)
    @randomize_room_connections.toolTip = Qt::Application.translate("Randomizer", "Randomizes which rooms within an area connect to each other. (The map is not useful with this option, so finding where to go can be extremely difficult.)", nil, Qt::Application::UnicodeUTF8)
    @randomize_room_connections.text = Qt::Application.translate("Randomizer", "Room Connections (Not map-friendly)", nil, Qt::Application::UnicodeUTF8)
    @randomize_area_connections.toolTip = Qt::Application.translate("Randomizer", "Randomizes which areas connect to each other.", nil, Qt::Application::UnicodeUTF8)
    @randomize_area_connections.text = Qt::Application.translate("Randomizer", "Area Connections (Not map-friendly)", nil, Qt::Application::UnicodeUTF8)
    @experimental_options_enabled.title = Qt::Application.translate("Randomizer", "Experimental randomization options (buggy and not guaranteed completable)", nil, Qt::Application::UnicodeUTF8)
    @randomize_players.toolTip = Qt::Application.translate("Randomizer", "Randomizes player graphics and movement stats.", nil, Qt::Application::UnicodeUTF8)
    @randomize_players.text = Qt::Application.translate("Randomizer", "Players", nil, Qt::Application::UnicodeUTF8)
    @randomize_bosses.toolTip = Qt::Application.translate("Randomizer", "Randomizes which bosses appear where.", nil, Qt::Application::UnicodeUTF8)
    @randomize_bosses.text = Qt::Application.translate("Randomizer", "Boss Locations", nil, Qt::Application::UnicodeUTF8)
    @randomize_world_map_exits.toolTip = Qt::Application.translate("Randomizer", "Randomizes the order areas are unlocked on the world map (OoE linear mode only).", nil, Qt::Application::UnicodeUTF8)
    @randomize_world_map_exits.text = Qt::Application.translate("Randomizer", "World Map Exits", nil, Qt::Application::UnicodeUTF8)
    @randomize_enemy_ai.toolTip = Qt::Application.translate("Randomizer", "Shuffles the AI of non-boss enemies (extremely buggy).", nil, Qt::Application::UnicodeUTF8)
    @randomize_enemy_ai.text = Qt::Application.translate("Randomizer", "Enemy AI", nil, Qt::Application::UnicodeUTF8)
    @randomize_enemy_sprites.text = Qt::Application.translate("Randomizer", "Enemy Sprites", nil, Qt::Application::UnicodeUTF8)
    @randomize_boss_sprites.text = Qt::Application.translate("Randomizer", "Boss Sprites", nil, Qt::Application::UnicodeUTF8)
    @tabWidget.setTabText(@tabWidget.indexOf(@tab), Qt::Application.translate("Randomizer", "Randomizer Settings", nil, Qt::Application::UnicodeUTF8))
    @tabWidget.setTabText(@tabWidget.indexOf(@tab_rv), Qt::Application.translate("Randomizer", "RV Settings", nil, Qt::Application::UnicodeUTF8))
    @label_4.text = Qt::Application.translate("Randomizer", "Difficulty level", nil, Qt::Application::UnicodeUTF8)
    @enable_glitch_reqs.toolTip = Qt::Application.translate("Randomizer", "If checked, certain glitches may be necessary to beat the game.", nil, Qt::Application::UnicodeUTF8)
    @enable_glitch_reqs.text = Qt::Application.translate("Randomizer", "Allow requiring glitches to win", nil, Qt::Application::UnicodeUTF8)
    @bonus_starting_items.toolTip = Qt::Application.translate("Randomizer", "Starts you out with 3 random extra items and 3 random extra skills.", nil, Qt::Application::UnicodeUTF8)
    @bonus_starting_items.text = Qt::Application.translate("Randomizer", "Bonus starting items", nil, Qt::Application::UnicodeUTF8)
    @rebalance_enemies_in_room_rando.toolTip = Qt::Application.translate("Randomizer", "Balances enemy and boss difficulty around the order you will reach them, as opposed to how difficult they were in the vanilla game. (Has no effect if all room randomizer options are off.)", nil, Qt::Application::UnicodeUTF8)
    @rebalance_enemies_in_room_rando.text = Qt::Application.translate("Randomizer", "Rebalance enemies by order you reach them (room randomizers only)", nil, Qt::Application::UnicodeUTF8)
    @label_5.text = Qt::Application.translate("Randomizer", "Specify custom difficulty values below:", nil, Qt::Application::UnicodeUTF8)
    @tabWidget.setTabText(@tabWidget.indexOf(@tab_3), Qt::Application.translate("Randomizer", "Difficulty Settings", nil, Qt::Application::UnicodeUTF8))
    @groupBox_4.title = Qt::Application.translate("Randomizer", "All Games", nil, Qt::Application::UnicodeUTF8)
    @reveal_bestiary.toolTip = Qt::Application.translate("Randomizer", "All enemies will appear in the bestiary, even before you kill them once.", nil, Qt::Application::UnicodeUTF8)
    @reveal_bestiary.text = Qt::Application.translate("Randomizer", "Reveal bestiary", nil, Qt::Application::UnicodeUTF8)
    @name_unnamed_skills.toolTip = Qt::Application.translate("Randomizer", "Gives Julius/Yoko/Alucard/Arma Felix/Arma Chiroptera's skills names so they can be distinguished from one another.", nil, Qt::Application::UnicodeUTF8)
    @name_unnamed_skills.text = Qt::Application.translate("Randomizer", "Name unnamed skills", nil, Qt::Application::UnicodeUTF8)
    @unlock_all_modes.toolTip = Qt::Application.translate("Randomizer", "Unlocks alternate modes that normally require you to beat the main game first.", nil, Qt::Application::UnicodeUTF8)
    @unlock_all_modes.text = Qt::Application.translate("Randomizer", "Unlock all modes", nil, Qt::Application::UnicodeUTF8)
    @scavenger_mode.toolTip = Qt::Application.translate("Randomizer", "Common enemies never drop items, souls, or glyphs. You have to rely on pickups you find placed in the world.", nil, Qt::Application::UnicodeUTF8)
    @scavenger_mode.text = Qt::Application.translate("Randomizer", "Scavenger Mode", nil, Qt::Application::UnicodeUTF8)
    @reveal_breakable_walls.toolTip = Qt::Application.translate("Randomizer", "Breakable walls will always blink as if you have Peeping Eye/Eye for Decay on.", nil, Qt::Application::UnicodeUTF8)
    @reveal_breakable_walls.text = Qt::Application.translate("Randomizer", "Reveal breakable walls", nil, Qt::Application::UnicodeUTF8)
    @remove_area_names.toolTip = Qt::Application.translate("Randomizer", "Removes the area names that appear on screen when you first enter an area.", nil, Qt::Application::UnicodeUTF8)
    @remove_area_names.text = Qt::Application.translate("Randomizer", "Remove area names", nil, Qt::Application::UnicodeUTF8)
    @revise_item_descriptions.toolTip = Qt::Application.translate("Randomizer", "Updates all weapon, armor, and skill descriptions to indicate what their randomized attributes are.", nil, Qt::Application::UnicodeUTF8)
    @revise_item_descriptions.text = Qt::Application.translate("Randomizer", "Revise Item Descriptions", nil, Qt::Application::UnicodeUTF8)
    @groupBox.title = Qt::Application.translate("Randomizer", "Dawn of Sorrow", nil, Qt::Application::UnicodeUTF8)
    @fix_luck.toolTip = Qt::Application.translate("Randomizer", "Make each point of luck give +0.1% drop chances (as opposed to almost nothing).", nil, Qt::Application::UnicodeUTF8)
    @fix_luck.text = Qt::Application.translate("Randomizer", "Fix luck", nil, Qt::Application::UnicodeUTF8)
    @no_touch_screen.toolTip = Qt::Application.translate("Randomizer", "Seals auto-draw, no name signing, melee weapons destroy ice blocks.", nil, Qt::Application::UnicodeUTF8)
    @no_touch_screen.text = Qt::Application.translate("Randomizer", "No required touch screen", nil, Qt::Application::UnicodeUTF8)
    @remove_slot_machines.toolTip = Qt::Application.translate("Randomizer", "Removes golden slot machines that require specific amounts of gold to open.", nil, Qt::Application::UnicodeUTF8)
    @remove_slot_machines.text = Qt::Application.translate("Randomizer", "Remove slot machines", nil, Qt::Application::UnicodeUTF8)
    @always_start_with_rare_ring.toolTip = Qt::Application.translate("Randomizer", "Gives you the rewards for having AoS in the GBA slot even when AoS is not in the GBA slot.", nil, Qt::Application::UnicodeUTF8)
    @always_start_with_rare_ring.text = Qt::Application.translate("Randomizer", "Always start with Rare Ring", nil, Qt::Application::UnicodeUTF8)
    @unlock_boss_doors.toolTip = Qt::Application.translate("Randomizer", "You don't need magic seals to open boss doors.", nil, Qt::Application::UnicodeUTF8)
    @unlock_boss_doors.text = Qt::Application.translate("Randomizer", "Unlock boss doors", nil, Qt::Application::UnicodeUTF8)
    @add_magical_tickets.toolTip = Qt::Application.translate("Randomizer", "Implements a new magical ticket item that functions like it does in PoR and OoE.", nil, Qt::Application::UnicodeUTF8)
    @add_magical_tickets.text = Qt::Application.translate("Randomizer", "Add Magical Tickets", nil, Qt::Application::UnicodeUTF8)
    @menace_to_somacula.toolTip = Qt::Application.translate("Randomizer", "Changes the final boss of Soma mode to be Somacula instead of Menace.", nil, Qt::Application::UnicodeUTF8)
    @menace_to_somacula.text = Qt::Application.translate("Randomizer", "Replace Menace", nil, Qt::Application::UnicodeUTF8)
    @dos_new_style_map.toolTip = Qt::Application.translate("Randomizer", "Makes the map in DoS look like the map in PoR and OoE - doors have a hole in them and the colors have better contrast.", nil, Qt::Application::UnicodeUTF8)
    @dos_new_style_map.text = Qt::Application.translate("Randomizer", "New Style Map", nil, Qt::Application::UnicodeUTF8)
    @groupBox_2.title = Qt::Application.translate("Randomizer", "Portrait of Ruin", nil, Qt::Application::UnicodeUTF8)
    @fix_infinite_quest_rewards.toolTip = Qt::Application.translate("Randomizer", "Fixes a bug where you could get any quest reward over and over again.", nil, Qt::Application::UnicodeUTF8)
    @fix_infinite_quest_rewards.text = Qt::Application.translate("Randomizer", "Fix infinite quest rewards bug", nil, Qt::Application::UnicodeUTF8)
    @always_show_drop_percentages.toolTip = Qt::Application.translate("Randomizer", "Drop chances always display as percentages instead of stars.", nil, Qt::Application::UnicodeUTF8)
    @always_show_drop_percentages.text = Qt::Application.translate("Randomizer", "Always have Gambler Glasses effect", nil, Qt::Application::UnicodeUTF8)
    @dont_randomize_change_cube.toolTip = Qt::Application.translate("Randomizer", "The change cube will always be the first item you get.", nil, Qt::Application::UnicodeUTF8)
    @dont_randomize_change_cube.text = Qt::Application.translate("Randomizer", "Don't randomize Change Cube", nil, Qt::Application::UnicodeUTF8)
    @por_short_mode.toolTip = Qt::Application.translate("Randomizer", "Removes 4 random portrait areas from the game. Unlocking Brauner requires beating the bosses of the 4 portraits that remain (not counting Nest of Evil).", nil, Qt::Application::UnicodeUTF8)
    @por_short_mode.text = Qt::Application.translate("Randomizer", "Short Mode", nil, Qt::Application::UnicodeUTF8)
    @skip_emblem_drawing.toolTip = Qt::Application.translate("Randomizer", "Skips the screen where you have to use the touch screen to draw an emblem when starting a new game.", nil, Qt::Application::UnicodeUTF8)
    @skip_emblem_drawing.text = Qt::Application.translate("Randomizer", "Skip emblem drawing", nil, Qt::Application::UnicodeUTF8)
    @por_nerf_enemy_resistances.toolTip = Qt::Application.translate("Randomizer", "Makes enemy resistances behave more like in DoS and OoE: An enemy must resist ALL elements of an attack to resist the attack, instead of just any one of the elements.", nil, Qt::Application::UnicodeUTF8)
    @por_nerf_enemy_resistances.text = Qt::Application.translate("Randomizer", "Nerf enemy resistances", nil, Qt::Application::UnicodeUTF8)
    @allow_mastering_charlottes_skills.toolTip = Qt::Application.translate("Randomizer", "Allow Charlotte's skills to gain SP like Jonathan's. When mastered they act fully charged at half charge, and when both mastered and fully charged they act supercharged.", nil, Qt::Application::UnicodeUTF8)
    @allow_mastering_charlottes_skills.text = Qt::Application.translate("Randomizer", "Allow Charlotte to master skills", nil, Qt::Application::UnicodeUTF8)
    @groupBox_3.title = Qt::Application.translate("Randomizer", "Order of Ecclesia", nil, Qt::Application::UnicodeUTF8)
    @summons_gain_extra_exp.toolTip = Qt::Application.translate("Randomizer", "Your summons gain far more EXP every time they hit an enemy.", nil, Qt::Application::UnicodeUTF8)
    @summons_gain_extra_exp.text = Qt::Application.translate("Randomizer", "Summons gain EXP faster", nil, Qt::Application::UnicodeUTF8)
    @gain_extra_attribute_points.toolTip = Qt::Application.translate("Randomizer", "You gain 25x more AP when killing enemies or absorbing glyphs.", nil, Qt::Application::UnicodeUTF8)
    @gain_extra_attribute_points.text = Qt::Application.translate("Randomizer", "Gain Attribute Points faster", nil, Qt::Application::UnicodeUTF8)
    @always_dowsing.toolTip = Qt::Application.translate("Randomizer", "Hidden blue chests always make a beeping sound.", nil, Qt::Application::UnicodeUTF8)
    @always_dowsing.text = Qt::Application.translate("Randomizer", "Always have Dowsing Hat effect", nil, Qt::Application::UnicodeUTF8)
    @open_world_map.toolTip = Qt::Application.translate("Randomizer", "Make all areas except Dracula's Castle accessible from the start.", nil, Qt::Application::UnicodeUTF8)
    @open_world_map.text = Qt::Application.translate("Randomizer", "Open world map", nil, Qt::Application::UnicodeUTF8)
    @tabWidget.setTabText(@tabWidget.indexOf(@tab_2), Qt::Application.translate("Randomizer", "Game Tweaks", nil, Qt::Application::UnicodeUTF8))
    @groupBox_5.title = Qt::Application.translate("Randomizer", "Cosmetic randomization options", nil, Qt::Application::UnicodeUTF8)
    @randomize_bgm.text = Qt::Application.translate("Randomizer", "BGM", nil, Qt::Application::UnicodeUTF8)
    @randomize_dialogue.text = Qt::Application.translate("Randomizer", "Dialogue", nil, Qt::Application::UnicodeUTF8)
    @randomize_player_sprites.text = Qt::Application.translate("Randomizer", "Player Sprites", nil, Qt::Application::UnicodeUTF8)
    @randomize_skill_sprites.toolTip = Qt::Application.translate("Randomizer", "Randomizes the graphics used by each skill.", nil, Qt::Application::UnicodeUTF8)
    @randomize_skill_sprites.text = Qt::Application.translate("Randomizer", "Skill Sprites", nil, Qt::Application::UnicodeUTF8)
    @tabWidget.setTabText(@tabWidget.indexOf(@tab_5), Qt::Application.translate("Randomizer", "Cosmetic", nil, Qt::Application::UnicodeUTF8))
    @label_6.text = Qt::Application.translate("Randomizer", "Paste the full seed info copied from a seed log into the field below and click Use Seed Info.", nil, Qt::Application::UnicodeUTF8)
    @label_7.text = Qt::Application.translate("Randomizer", "Doing this will make the randomizer use all the same settings as the seed info you copy pasted, without needing to select each option individually.", nil, Qt::Application::UnicodeUTF8)
    @read_seed_info_button.text = Qt::Application.translate("Randomizer", "Use Seed Info", nil, Qt::Application::UnicodeUTF8)
    @tabWidget.setTabText(@tabWidget.indexOf(@tab_4), Qt::Application.translate("Randomizer", "Paste Seed Info", nil, Qt::Application::UnicodeUTF8))
    @option_description.text = ''
    @about_button.text = Qt::Application.translate("Randomizer", "About", nil, Qt::Application::UnicodeUTF8)
    @label_8.text = Qt::Application.translate("Randomizer", "Number of seeds to generate:", nil, Qt::Application::UnicodeUTF8)
    @num_seeds_to_create.insertItems(0, [Qt::Application.translate("Randomizer", "1 seed", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Randomizer", "2 seeds", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Randomizer", "3 seeds", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Randomizer", "4 seeds", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Randomizer", "5 seeds", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Randomizer", "6 seeds", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Randomizer", "7 seeds", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Randomizer", "8 seeds", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Randomizer", "9 seeds", nil, Qt::Application::UnicodeUTF8),
        Qt::Application.translate("Randomizer", "10 seeds", nil, Qt::Application::UnicodeUTF8)])
    @randomize_button.text = Qt::Application.translate("Randomizer", "Randomize", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(randomizer)
        retranslateUi(randomizer)
    end

end

module Ui
    class Randomizer < Ui_Randomizer
    end
end  # module Ui

