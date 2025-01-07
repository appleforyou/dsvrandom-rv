=begin
** Form generated from reading ui file 'randomizer.ui'
**
** Created: Sat Dec 3 18:28:02 2022
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
    attr_reader :clean_rom_label
    attr_reader :label
    attr_reader :output_label
    attr_reader :output_folder
    attr_reader :generate_seed_button
    attr_reader :clean_rom_browse_button
    attr_reader :seed
    attr_reader :output_folder_browse_button
    attr_reader :clean_rom
    attr_reader :groupBox_7
    attr_reader :gridLayout_7
    attr_reader :widget_3
    attr_reader :randomize_pickups
    attr_reader :randomize_enemy_drops
    attr_reader :groupBox_9
    attr_reader :gridLayout_9
    attr_reader :widget
    attr_reader :groupBox_6
    attr_reader :gridLayout_11
    attr_reader :groupBox_8
    attr_reader :gridLayout_10
    attr_reader :groupBox_10
    attr_reader :gridLayout_12
    attr_reader :randomize_shop
    attr_reader :randomize_wooden_chests
    attr_reader :widget_2
    attr_reader :tab_3
    attr_reader :verticalLayout_7
    attr_reader :horizontalLayout_16
    attr_reader :horizontalLayout_17
    attr_reader :label_4
    attr_reader :horizontalLayout_14
    attr_reader :line
    attr_reader :label_5
    attr_reader :scrollArea
    attr_reader :scrollAreaWidgetContents
    attr_reader :formLayout_5
    attr_reader :tab_2
    attr_reader :verticalLayout_4
    attr_reader :groupBox_4
    attr_reader :gridLayout_2
    attr_reader :remove_area_names
    attr_reader :reveal_breakable_walls
    attr_reader :groupBox
    attr_reader :gridLayout_3
    attr_reader :groupBox_2
    attr_reader :gridLayout_4
    attr_reader :groupBox_3
    attr_reader :gridLayout_5
    attr_reader :summons_gain_extra_exp
    attr_reader :always_dowsing
    attr_reader :open_world_map
    attr_reader :groupBox_11
    attr_reader :gridLayout_13
    attr_reader :verticalSpacer_2
    attr_reader :tab_5
    attr_reader :verticalLayout_8
    attr_reader :groupBox_5
    attr_reader :gridLayout_6
    attr_reader :randomize_bgm
    attr_reader :verticalSpacer
    attr_reader :option_description
    attr_reader :horizontalLayout_2
    attr_reader :load_seed_info_button
    attr_reader :paste_seed_info_button
    attr_reader :save_options_preset_button
    attr_reader :load_options_preset_button
    attr_reader :horizontalLayout_3
    attr_reader :about_button
    attr_reader :horizontalSpacer
    attr_reader :reset_settings_to_default
    attr_reader :horizontalSpacer_4
    attr_reader :horizontalSpacer_3
    attr_reader :randomize_button
    attr_reader :rv_difficulty
    attr_reader :rv_open_castle
    attr_reader :rv_unlock_albus
    attr_reader :rv_non_vanilla_glyphs
    attr_reader :rv_unlock_cerberus
    attr_reader :rv_split_pools
    attr_reader :rv_puzzle_progression
    attr_reader :rv_randomize_quest_rewards
    attr_reader :patch_folder
    attr_reader :patch_folder_browse_button
    attr_reader :unrandomize_button
    attr_reader :generate_backup_button
    attr_reader :restore_backup_button
    attr_reader :apply_patch_button
    attr_reader :phase_1_label
    attr_reader :phase_2_label
    attr_reader :auto_apply
    attr_reader :lock_backup
    attr_reader :rv_arthrovertas_revenge
    attr_reader :rv_hint_cat_locations
    attr_reader :reveal_enemy_info
    attr_reader :version_selector
    attr_reader :version_label
    attr_reader :modded_game


    def setupUi(randomizer)
    if randomizer.objectName.nil?
        randomizer.objectName = "randomizer"
    end
    randomizer.resize(820, 710)
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

    @horizontalLayout_16 = Qt::HBoxLayout.new()
    @horizontalLayout_16.objectName = "horizontalLayout_16"

    @verticalLayout_2.addLayout(@horizontalLayout_16)

    @phase_1_label = Qt::Label.new(@tab)
    @phase_1_label.objectName = "phase_1_label"

    @horizontalLayout_16.addWidget(@phase_1_label)

    @horizontalSpacer_3 = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @horizontalLayout_16.addItem(@horizontalSpacer_3)

    @version_label = Qt::Label.new(@tab)
    @version_label.objectName = "version_label"
    @horizontalLayout_16.addWidget(@version_label)

    @version_selector = Qt::ComboBox.new(@tab)
    @version_selector.objectName = "version_selector"
    @horizontalLayout_16.addWidget(@version_selector)

    @label_5 = Qt::Label.new(@tab)
    @label_5.objectName = "label_5"

    @gridLayout.addWidget(@label_5, 0, 1, 1, 1)

    @output_label = Qt::Label.new(@tab)
    @output_label.objectName = "output_label"

    @gridLayout.addWidget(@output_label, 1, 0, 1, 1)

    @output_folder = Qt::LineEdit.new(@tab)
    @output_folder.objectName = "output_folder"

    @gridLayout.addWidget(@output_folder, 1, 1, 1, 1)

    @output_folder_browse_button = Qt::PushButton.new(@tab)
    @output_folder_browse_button.objectName = "output_folder_browse_button"

    @gridLayout.addWidget(@output_folder_browse_button, 1, 2, 1, 1)

    @label_4 = Qt::Label.new(@tab)
    @label_4.objectName = "label_4"

    @gridLayout.addWidget(@label_4, 2, 1, 1, 1)

    @clean_rom_label = Qt::Label.new(@tab)
    @clean_rom_label.objectName = "clean_rom_label"

    @gridLayout.addWidget(@clean_rom_label, 3, 0, 1, 1)

    @clean_rom = Qt::LineEdit.new(@tab)
    @clean_rom.objectName = "clean_rom"

    @gridLayout.addWidget(@clean_rom, 3, 1, 1, 1)

    @clean_rom_browse_button = Qt::PushButton.new(@tab)
    @clean_rom_browse_button.objectName = "clean_rom_browse_button"

    @gridLayout.addWidget(@clean_rom_browse_button, 3, 2, 1, 1)

    @label_8 = Qt::Label.new(@tab)
    @label_8.objectName = "label_8"

    @gridLayout.addWidget(@label_8, 4, 1, 1, 1)

    @generate_backup_button = Qt::PushButton.new(@tab)
    @generate_backup_button.objectName = "generate_backup_button"

    @gridLayout.addWidget(@generate_backup_button, 5, 1, 1, 1)

    @permission_label = Qt::Label.new(@tab)
    @permission_label.objectName = "permission_label"

    @gridLayout.addWidget(@permission_label, 6, 1, 1, 1)

    @lock_backup = Qt::CheckBox.new(@tab)
    @lock_backup.objectName = "lock_backup"
    @lock_backup.checked = false

    @gridLayout.addWidget(@lock_backup, 5, 2, 1, 1)

    @verticalLayout_2.addLayout(@gridLayout)

    @line = Qt::Frame.new(@tab_3)
    @line.objectName = "line"
    @line.setFrameShape(Qt::Frame::HLine)
    @line.setFrameShadow(Qt::Frame::Sunken)

    @verticalLayout_2.addWidget(@line)

    @horizontalLayout_17 = Qt::HBoxLayout.new()
    @horizontalLayout_17.objectName = "horizontalLayout_17"

    @verticalLayout_2.addLayout(@horizontalLayout_17)

    @phase_2_label = Qt::Label.new(@tab)
    @phase_2_label.objectName = "phase_2_label"

    @horizontalLayout_17.addWidget(@phase_2_label)

    @horizontalSpacer_4 = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @horizontalLayout_17.addItem(@horizontalSpacer_4)

    @modded_game = Qt::CheckBox.new(@tab)
    @modded_game.objectName = "modded_game"
    @modded_game.checked = false

    @horizontalLayout_17.addWidget(@modded_game)

    @gridLayout_3 = Qt::GridLayout.new(@groupBox)
    @gridLayout_3.objectName = "gridLayout_3"

    @label_6 = Qt::Label.new(@tab)
    @label_6.objectName = "label_6"

    @gridLayout_3.addWidget(@label_6, 0, 1, 1, 1)

    @patch_label = Qt::Label.new(@tab)
    @patch_label.objectName = "patch_label"

    @gridLayout_3.addWidget(@patch_label, 1, 0, 1, 1)

    @patch_folder = Qt::LineEdit.new(@tab)
    @patch_folder.objectName = "patch_folder"

    @gridLayout_3.addWidget(@patch_folder, 1, 1, 1, 1)

    @patch_folder_browse_button = Qt::PushButton.new(@tab)
    @patch_folder_browse_button.objectName = "patch_folder_browse_button"

    @gridLayout_3.addWidget(@patch_folder_browse_button, 1, 2, 1, 1)

    @label_7 = Qt::Label.new(@tab)
    @label_7.objectName = "label_7"

    @gridLayout_3.addWidget(@label_7, 2, 1, 1, 1)

    @label = Qt::Label.new(@tab)
    @label.objectName = "label"

    @gridLayout_3.addWidget(@label, 3, 0, 1, 1)

    @seed = Qt::LineEdit.new(@tab)
    @seed.objectName = "seed"

    @gridLayout_3.addWidget(@seed, 3, 1, 1, 1)

    @generate_seed_button = Qt::PushButton.new(@tab)
    @generate_seed_button.objectName = "generate_seed_button"

    @gridLayout_3.addWidget(@generate_seed_button, 3, 2, 1, 1)

    @label_9 = Qt::Label.new(@tab)
    @label_9.objectName = "label_9"

    @gridLayout_3.addWidget(@label_9, 4, 1, 1, 1)

    @unrandomize_button = Qt::PushButton.new(randomizer)
    @unrandomize_button.objectName = "unrandomize_button"

    @gridLayout_3.addWidget(@unrandomize_button, 5, 1, 1, 1)

    @label_10 = Qt::Label.new(@tab)
    @label_10.objectName = "label_10"

    @gridLayout_3.addWidget(@label_10, 6, 1, 1, 1)

    @randomize_button = Qt::PushButton.new(randomizer)
    @randomize_button.objectName = "randomize_button"

    @gridLayout_3.addWidget(@randomize_button, 7, 1, 1, 1)

    @auto_apply = Qt::CheckBox.new(@tab)
    @auto_apply.objectName = "auto_apply"
    @auto_apply.checked = true

    @gridLayout_3.addWidget(@auto_apply, 7, 2, 1, 1)

    @label_11 = Qt::Label.new(@tab)
    @label_11.objectName = "label_11"

    @gridLayout_3.addWidget(@label_11, 8, 1, 1, 1)

    @apply_patch_button = Qt::PushButton.new(randomizer)
    @apply_patch_button.objectName = "apply_patch_button"

    @gridLayout_3.addWidget(@apply_patch_button, 9, 1, 1, 1)

    @verticalLayout_2.addLayout(@gridLayout_3)

    @line_2 = Qt::Frame.new(@tab_3)
    @line_2.objectName = "line"
    @line_2.setFrameShape(Qt::Frame::HLine)
    @line_2.setFrameShadow(Qt::Frame::Sunken)

    @verticalLayout_2.addWidget(@line_2)

    @horizontalLayout_14 = Qt::HBoxLayout.new()
    @horizontalLayout_14.objectName = "horizontalLayout_14"

    @label_12 = Qt::Label.new(@tab)
    @label_12.objectName = "label_12"

    @horizontalLayout_14.addWidget(@label_12)

    @verticalLayout_2.addLayout(@horizontalLayout_14)

    @horizontalLayout_18 = Qt::HBoxLayout.new()
    @horizontalLayout_18.objectName = "horizontalLayout_18"

    @label_13 = Qt::Label.new(@tab)
    @label_13.objectName = "label_13"

    @horizontalLayout_18.addWidget(@label_13)

    @verticalLayout_2.addLayout(@horizontalLayout_18)




    @tabWidget.addTab(@tab, Qt::Application.translate("Randomizer", "Randomize", nil, Qt::Application::UnicodeUTF8))


    @tab_3 = Qt::Widget.new()
    @tab_3.objectName = "tab_3"
    @verticalLayout_7 = Qt::VBoxLayout.new(@tab_3)
    @verticalLayout_7.objectName = "verticalLayout_7"




    @groupBox_7 = Qt::GroupBox.new(@tab_3)
    @groupBox_7.objectName = "groupBox_7"
    @sizePolicy = Qt::SizePolicy.new(Qt::SizePolicy::Minimum, Qt::SizePolicy::Preferred)
    @sizePolicy.setHorizontalStretch(0)
    @sizePolicy.setVerticalStretch(0)
    @sizePolicy.heightForWidth = @groupBox_7.sizePolicy.hasHeightForWidth
    @groupBox_7.sizePolicy = @sizePolicy
    @gridLayout_7 = Qt::GridLayout.new(@groupBox_7)
    @gridLayout_7.objectName = "gridLayout_7"
    @widget_3 = Qt::Widget.new(@groupBox_7)
    @widget_3.objectName = "widget_3"

    @gridLayout_7.addWidget(@widget_3, 0, 2, 1, 1)

    @horizontalLayout_rv_1 = Qt::HBoxLayout.new()
    @horizontalLayout_rv_1.objectName = "horizontalLayout_rv_1"

    @rv_difficulty_label = Qt::Label.new(@tab_3)
    @rv_difficulty_label.objectName = "rv_difficulty_label"
    @horizontalLayout_rv_1.addWidget(@rv_difficulty_label)

    @rv_difficulty = Qt::ComboBox.new(@tab_3)
    @rv_difficulty.objectName = "rv_difficulty"
    @horizontalLayout_rv_1.addWidget(@rv_difficulty)

    @verticalLayout_7.addLayout(@horizontalLayout_rv_1)

    @randomize_pickups = Qt::CheckBox.new(@groupBox_7)
    @randomize_pickups.objectName = "randomize_pickups"
    @randomize_pickups.checked = true

    @gridLayout_7.addWidget(@randomize_pickups, 0, 0, 1, 1)

    @rv_split_pools = Qt::CheckBox.new(@groupBox_7)
    @rv_split_pools.objectName = "rv_split_pools"
    @rv_split_pools.checked = true

    @gridLayout_7.addWidget(@rv_split_pools, 0, 1, 1, 1)

    @rv_puzzle_progression = Qt::CheckBox.new(@groupBox_7)
    @rv_puzzle_progression.objectName = "rv_puzzle_progression"
    @rv_puzzle_progression.checked = true

    @gridLayout_7.addWidget(@rv_puzzle_progression, 0, 2, 1, 1)

    @verticalLayout_7.addWidget(@groupBox_7)

    @groupBox_10 = Qt::GroupBox.new(@tab_3)
    @groupBox_10.objectName = "groupBox_10"
    @gridLayout_12 = Qt::GridLayout.new(@groupBox_10)
    @gridLayout_12.objectName = "gridLayout_12"

    @randomize_enemy_drops = Qt::CheckBox.new(@groupBox_6)
    @randomize_enemy_drops.objectName = "randomize_enemy_drops"
    @randomize_enemy_drops.checked = true

    @gridLayout_12.addWidget(@randomize_enemy_drops, 0, 0, 1, 1)

    @randomize_wooden_chests = Qt::CheckBox.new(@groupBox_10)
    @randomize_wooden_chests.objectName = "randomize_wooden_chests"
    @randomize_wooden_chests.checked = true

    @gridLayout_12.addWidget(@randomize_wooden_chests, 0, 1, 1, 1)

    @randomize_bgm = Qt::CheckBox.new(@groupBox_10)
    @randomize_bgm.objectName = "randomize_bgm"
    @randomize_bgm.checked = true

    @gridLayout_12.addWidget(@randomize_bgm, 0, 2, 1, 1)

    @randomize_shop = Qt::CheckBox.new(@groupBox_10)
    @randomize_shop.objectName = "randomize_shop"
    @randomize_shop.checked = true

    @gridLayout_12.addWidget(@randomize_shop, 1, 0, 1, 1)

    @rv_randomize_quest_rewards = Qt::CheckBox.new(@groupBox_7)
    @rv_randomize_quest_rewards.objectName = "rv_randomize_quest_rewards"
    @rv_randomize_quest_rewards.checked = true

    @gridLayout_12.addWidget(@rv_randomize_quest_rewards, 1, 1, 1, 1)

    @widget_2 = Qt::Widget.new(@groupBox_10)
    @widget_2.objectName = "widget_2"

    @gridLayout_12.addWidget(@widget_2, 0, 4, 1, 1)


    @verticalLayout_7.addWidget(@groupBox_10)

    @groupBox_4 = Qt::GroupBox.new(@tab_3)
    @groupBox_4.objectName = "groupBox_4"
    @gridLayout_2 = Qt::GridLayout.new(@groupBox_4)
    @gridLayout_2.objectName = "gridLayout_2"

    @rv_open_castle = Qt::CheckBox.new(@groupBox_4)
    @rv_open_castle.objectName = "rv_open_castle"
    @rv_open_castle.checked = true
    @rv_open_castle.enabled = false

    @gridLayout_2.addWidget(@rv_open_castle, 0, 0, 1, 1)

    @rv_unlock_albus = Qt::CheckBox.new(@groupBox_4)
    @rv_unlock_albus.objectName = "rv_unlock_albus"
    @rv_unlock_albus.checked = true

    @gridLayout_2.addWidget(@rv_unlock_albus, 0, 1, 1, 1)

    @rv_unlock_cerberus = Qt::CheckBox.new(@groupBox_4)
    @rv_unlock_cerberus.objectName = "rv_unlock_cerberus"
    @rv_unlock_cerberus.checked = true

    @gridLayout_2.addWidget(@rv_unlock_cerberus, 0, 2, 1, 1)

    @remove_area_names = Qt::CheckBox.new(@groupBox_4)
    @remove_area_names.objectName = "remove_area_names"
    @remove_area_names.checked = true

    @gridLayout_2.addWidget(@remove_area_names, 1, 0, 1, 1)

    @reveal_breakable_walls = Qt::CheckBox.new(@groupBox_4)
    @reveal_breakable_walls.objectName = "reveal_breakable_walls"
    @reveal_breakable_walls.checked = true

    @gridLayout_2.addWidget(@reveal_breakable_walls, 1, 1, 1, 1)

    @always_dowsing = Qt::CheckBox.new(@groupBox_4)
    @always_dowsing.objectName = "always_dowsing"
    @always_dowsing.checked = true

    @gridLayout_2.addWidget(@always_dowsing, 1, 2, 1, 1)

    @verticalLayout_7.addWidget(@groupBox_4)

    @groupBox_8 = Qt::GroupBox.new(@tab_3)
    @groupBox_8.objectName = "groupBox_8"
    @gridLayout_10 = Qt::GridLayout.new(@groupBox_8)
    @gridLayout_10.objectName = "gridLayout_10"

    @rv_arthrovertas_revenge = Qt::CheckBox.new(@groupBox_10)
    @rv_arthrovertas_revenge.objectName = "rv_arthrovertas_revenge"
    @rv_arthrovertas_revenge.checked = false

    @gridLayout_10.addWidget(@rv_arthrovertas_revenge, 0, 0, 1, 1)

    @reveal_enemy_info = Qt::CheckBox.new(@groupBox_10)
    @reveal_enemy_info.objectName = "reveal_enemy_info"
    @reveal_enemy_info.checked = true

    @gridLayout_10.addWidget(@reveal_enemy_info, 1, 0, 1, 1)

    @rv_non_vanilla_glyphs = Qt::CheckBox.new(@groupBox_7)
    @rv_non_vanilla_glyphs.objectName = "rv_non_vanilla_glyphs"
    @rv_non_vanilla_glyphs.checked = false
    @rv_non_vanilla_glyphs.enabled = false

    @gridLayout_10.addWidget(@rv_non_vanilla_glyphs, 0, 1, 1, 1)

    @rv_hint_cat_label = Qt::Label.new(@tab_3)
    @rv_hint_cat_label.objectName = "rv_hint_cat_label"
    @gridLayout_7.addWidget(@rv_hint_cat_label, 1, 0, 1, 1)

    @rv_hint_cat_locations = Qt::ComboBox.new(@tab_3)
    @rv_hint_cat_locations.objectName = "rv_hint_cat_locations"
    @gridLayout_7.addWidget(@rv_hint_cat_locations, 1, 1, 1, 1)

    @verticalLayout_7.addWidget(@groupBox_8)

    @tabWidget.addTab(@tab_3, Qt::Application.translate("Randomizer", "Randomization Options", nil, Qt::Application::UnicodeUTF8))
    @tab_2 = Qt::Widget.new()
    @tab_2.objectName = "tab_2"
    @verticalLayout_4 = Qt::VBoxLayout.new(@tab_2)
    @verticalLayout_4.objectName = "verticalLayout_4"


    @groupBox = Qt::GroupBox.new(@tab_2)
    @groupBox.objectName = "groupBox"


    @verticalLayout_4.addWidget(@groupBox)

    @groupBox_2 = Qt::GroupBox.new(@tab_2)
    @groupBox_2.objectName = "groupBox_2"
    @gridLayout_4 = Qt::GridLayout.new(@groupBox_2)
    @gridLayout_4.objectName = "gridLayout_4"



    @verticalLayout_4.addWidget(@groupBox_2)

    @groupBox_3 = Qt::GroupBox.new(@tab_2)
    @groupBox_3.objectName = "groupBox_3"
    @gridLayout_5 = Qt::GridLayout.new(@groupBox_3)
    @gridLayout_5.objectName = "gridLayout_5"

    @verticalLayout_4.addWidget(@groupBox_3)

    @groupBox_11 = Qt::GroupBox.new(@tab_2)
    @groupBox_11.objectName = "groupBox_11"
    @gridLayout_13 = Qt::GridLayout.new(@groupBox_11)
    @gridLayout_13.objectName = "gridLayout_13"


    @verticalLayout_4.addWidget(@groupBox_11)

    @verticalSpacer_2 = Qt::SpacerItem.new(20, 40, Qt::SizePolicy::Minimum, Qt::SizePolicy::Expanding)

    @verticalLayout_4.addItem(@verticalSpacer_2)

    @tab_5 = Qt::Widget.new()
    @tab_5.objectName = "tab_5"
    @verticalLayout_8 = Qt::VBoxLayout.new(@tab_5)
    @verticalLayout_8.objectName = "verticalLayout_8"

    @restore_backup_button = Qt::PushButton.new(@tab_5)
    @restore_backup_button.objectName = "restore_backup_button"

    @verticalLayout_8.addWidget(@restore_backup_button)

    @help_label = Qt::Label.new(@tab_5)
    @help_label.objectName = "help_label"
    @verticalLayout_8.addWidget(@help_label)

    @test_box = Qt::ToolBox.new(@tab_5)
    @test_box.objectName = "test_box"

    @patches_label = Qt::Label.new(@tab_5)
    @patches_label.objectName = "patches_label"
    @patches_label.wordWrap = true
    @modded_label = Qt::Label.new(@tab_5)
    @modded_label.objectName = "modded_label"
    @modded_label.wordWrap = true

    @open_world_label = Qt::Label.new(@tab_5)
    @open_world_label.objectName = "open_world_label"
    @open_world_label.wordWrap = true

    @difficulty_preset_label = Qt::Label.new(@tab_5)
    @difficulty_preset_label.objectName = "difficulty_preset_label"
    @difficulty_preset_label.wordWrap = true

    @vanilla_label = Qt::Label.new(@tab_5)
    @vanilla_label.objectName = "vanilla_label"
    @vanilla_label.wordWrap = true
    @creative_label = Qt::Label.new(@tab_5)
    @creative_label.objectName = "creative_label"
    @creative_label.wordWrap = true
    @worst_label = Qt::Label.new(@tab_5)
    @worst_label.objectName = "worst_label"
    @worst_label.wordWrap = true

    @gear_label = Qt::Label.new(@tab_5)
    @gear_label.objectName = "gear_label"
    @gear_label.wordWrap = true


    @test_box.addItem(@patches_label, "About patches")
    @test_box.addItem(@modded_label, "About pre-modded game files")
    @test_box.addItem(@open_world_label, "About open world options")
    @test_box.addItem(@difficulty_preset_label, "Item Location Difficulty Presets")
    @test_box.addItem(@vanilla_label, "Vanilla")
    @test_box.addItem(@creative_label, "Creative")
    @test_box.addItem(@worst_label, "Do Your Worst")

    @test_box.addItem(@gear_label, "Gear Level and Equipment Tiers")

    @verticalLayout_8.addWidget(@test_box)

    @tabWidget.addTab(@tab_5, Qt::Application.translate("Randomizer", "Help", nil, Qt::Application::UnicodeUTF8))

    @verticalLayout.addWidget(@tabWidget)

    @option_description = Qt::Label.new(randomizer)
    @option_description.objectName = "option_description"
    @option_description.minimumSize = Qt::Size.new(0, 32)
    @option_description.wordWrap = true

    @verticalLayout.addWidget(@option_description)

    @horizontalLayout_2 = Qt::HBoxLayout.new()
    @horizontalLayout_2.objectName = "horizontalLayout_2"
    @load_seed_info_button = Qt::PushButton.new(randomizer)
    @load_seed_info_button.objectName = "load_seed_info_button"

    @horizontalLayout_2.addWidget(@load_seed_info_button)

    @paste_seed_info_button = Qt::PushButton.new(randomizer)
    @paste_seed_info_button.objectName = "paste_seed_info_button"

    @horizontalLayout_2.addWidget(@paste_seed_info_button)

    @save_options_preset_button = Qt::PushButton.new(randomizer)
    @save_options_preset_button.objectName = "save_options_preset_button"

    @horizontalLayout_2.addWidget(@save_options_preset_button)

    @load_options_preset_button = Qt::PushButton.new(randomizer)
    @load_options_preset_button.objectName = "load_options_preset_button"

    @horizontalLayout_2.addWidget(@load_options_preset_button)


    @verticalLayout.addLayout(@horizontalLayout_2)

    @horizontalLayout_3 = Qt::HBoxLayout.new()
    @horizontalLayout_3.objectName = "horizontalLayout_3"
    @reset_settings_to_default = Qt::PushButton.new(randomizer)
    @reset_settings_to_default.objectName = "reset_settings_to_default"
    @reset_settings_to_default.minimumSize = Qt::Size.new(180, 0)

    @horizontalLayout_3.addWidget(@reset_settings_to_default)

    @horizontalSpacer = Qt::SpacerItem.new(40, 20, Qt::SizePolicy::Expanding, Qt::SizePolicy::Minimum)

    @horizontalLayout_3.addItem(@horizontalSpacer)

    @about_button = Qt::PushButton.new(randomizer)
    @about_button.objectName = "about_button"

    @horizontalLayout_3.addWidget(@about_button)

    @verticalLayout.addLayout(@horizontalLayout_3)

    Qt::Widget.setTabOrder(@clean_rom, @clean_rom_browse_button)
    Qt::Widget.setTabOrder(@clean_rom_browse_button, @output_folder)
    Qt::Widget.setTabOrder(@output_folder, @output_folder_browse_button)
    Qt::Widget.setTabOrder(@output_folder_browse_button, @seed)
    Qt::Widget.setTabOrder(@seed, @generate_seed_button)
    Qt::Widget.setTabOrder(@generate_seed_button, @randomize_pickups)
    Qt::Widget.setTabOrder(@randomize_pickups, @randomize_enemy_drops)
    Qt::Widget.setTabOrder(@randomize_enemy_drops, @randomize_shop)
    Qt::Widget.setTabOrder(@randomize_shop, @randomize_wooden_chests)
    Qt::Widget.setTabOrder(@randomize_wooden_chests, @load_seed_info_button)
    Qt::Widget.setTabOrder(@load_seed_info_button, @paste_seed_info_button)
    Qt::Widget.setTabOrder(@paste_seed_info_button, @save_options_preset_button)
    Qt::Widget.setTabOrder(@save_options_preset_button, @load_options_preset_button)
    Qt::Widget.setTabOrder(@load_options_preset_button, @about_button)
    Qt::Widget.setTabOrder(@about_button, @reset_settings_to_default)
    Qt::Widget.setTabOrder(@reset_settings_to_default, @randomize_button)
    Qt::Widget.setTabOrder(@randomize_button, @scrollArea)
    Qt::Widget.setTabOrder(@scrollArea, @reveal_breakable_walls)
    Qt::Widget.setTabOrder(@reveal_breakable_walls, @remove_area_names)
    Qt::Widget.setTabOrder(@remove_area_names, @open_world_map)
    Qt::Widget.setTabOrder(@open_world_map, @always_dowsing)
    Qt::Widget.setTabOrder(@always_dowsing, @summons_gain_extra_exp)
    Qt::Widget.setTabOrder(@summons_gain_extra_exp, @randomize_bgm)
    Qt::Widget.setTabOrder(@randomize_bgm, @tabWidget)

    retranslateUi(randomizer)

    @tabWidget.setCurrentIndex(0)


    Qt::MetaObject.connectSlotsByName(randomizer)
    end # setupUi

    def setup_ui(randomizer)
        setupUi(randomizer)
    end

    def retranslateUi(randomizer)
    randomizer.windowTitle = Qt::Application.translate("Randomizer", "DSVania Randomizer", nil, Qt::Application::UnicodeUTF8)
    @clean_rom_label.text = Qt::Application.translate("Randomizer", "Backup Folder", nil, Qt::Application::UnicodeUTF8)
    @label.text = Qt::Application.translate("Randomizer", "Seed Name", nil, Qt::Application::UnicodeUTF8)
    @output_label.text = Qt::Application.translate("Randomizer", "Game Folder", nil, Qt::Application::UnicodeUTF8)
    @generate_seed_button.text = Qt::Application.translate("Randomizer", "New seed", nil, Qt::Application::UnicodeUTF8)
    @clean_rom_browse_button.text = Qt::Application.translate("Randomizer", "Browse", nil, Qt::Application::UnicodeUTF8)
    @output_folder_browse_button.text = Qt::Application.translate("Randomizer", "Browse", nil, Qt::Application::UnicodeUTF8)
    @generate_backup_button.text = Qt::Application.translate("Randomizer", "Generate Backup Files", nil, Qt::Application::UnicodeUTF8)
    @restore_backup_button.text = Qt::Application.translate("Randomizer", "Restore Game Files from Backups", nil, Qt::Application::UnicodeUTF8)
    @lock_backup.text = Qt::Application.translate("Randomizer", "Locked", nil, Qt::Application::UnicodeUTF8)
    @modded_game.text = Qt::Application.translate("Randomizer", "Game has other mods", nil, Qt::Application::UnicodeUTF8)
    @groupBox_7.title = Qt::Application.translate("Randomizer", "Progression randomization options", nil, Qt::Application::UnicodeUTF8)
    @randomize_pickups.text = Qt::Application.translate("Randomizer", "Randomize Item/Skill Locations", nil, Qt::Application::UnicodeUTF8)

    @rv_open_castle.text = Qt::Application.translate("Randomizer", "Open World Map + Dracula's Castle", nil, Qt::Application::UnicodeUTF8)
    @rv_unlock_albus.text = Qt::Application.translate("Randomizer", "Unlock Albus/Barlowe", nil, Qt::Application::UnicodeUTF8)
    @rv_non_vanilla_glyphs.text = Qt::Application.translate("Randomizer", "Not implemented yet", nil, Qt::Application::UnicodeUTF8)
    @rv_unlock_cerberus.text = Qt::Application.translate("Randomizer", "Unlock Cerberus Gate", nil, Qt::Application::UnicodeUTF8)
    @rv_split_pools.text = Qt::Application.translate("Randomizer", "Split pools for item/glyph locations", nil, Qt::Application::UnicodeUTF8)
    @rv_puzzle_progression.text = Qt::Application.translate("Randomizer", "Allow progression glyphs at Cubus/Morbus", nil, Qt::Application::UnicodeUTF8)
    @rv_randomize_quest_rewards.text = Qt::Application.translate("Randomizer", "Quest Reward Items", nil, Qt::Application::UnicodeUTF8)
    @rv_arthrovertas_revenge.text = Qt::Application.translate("Randomizer", "Arthroverta's Revenge", nil, Qt::Application::UnicodeUTF8)
    @reveal_enemy_info.text = Qt::Application.translate("Randomizer", "Reveal Enemy Info", nil, Qt::Application::UnicodeUTF8)
    @patch_label.text = Qt::Application.translate("Randomizer", "Patch Folder", nil, Qt::Application::UnicodeUTF8)
    @patch_folder_browse_button.text = Qt::Application.translate("Randomizer", "Browse", nil, Qt::Application::UnicodeUTF8)
    @rv_difficulty_label.text = Qt::Application.translate("Randomizer", "Item location difficulty preset", nil, Qt::Application::UnicodeUTF8)
    @rv_difficulty_label.toolTip = Qt::Application.translate("Randomizer", "This option affects rules for which items are considered required to access locations. See the Help tab for details.", nil, Qt::Application::UnicodeUTF8)
    @rv_difficulty.toolTip = @rv_difficulty_label.toolTip
    @rv_difficulty.addItem("Vanilla")
    @rv_difficulty.addItem("Creative")
    @rv_difficulty.addItem("Do Your Worst")
    @rv_difficulty.setCurrentIndex(1)
    @rv_hint_cat_label.text = Qt::Application.translate("Randomizer", "Hint cat locations (may depend on other settings)", nil, Qt::Application::UnicodeUTF8)
    @rv_hint_cat_label.toolTip = Qt::Application.translate("Randomizer", "This option determines where cats which gave hints in the original game will be placed (or whether they give randomizer-relevant hints at all.)", nil, Qt::Application::UnicodeUTF8)
    @rv_hint_cat_locations.toolTip = @rv_hint_cat_label.toolTip
    @rv_hint_cat_locations.addItem("No Hints")
    @rv_hint_cat_locations.addItem("Original Locations")
    @rv_hint_cat_locations.addItem("Randomized Among Villager Locations")
    @rv_hint_cat_locations.setCurrentIndex(1)

    @version_label.text = Qt::Application.translate("Randomizer", "Dominus Version", nil, Qt::Application::UnicodeUTF8)
    @version_label.toolTip = Qt::Application.translate("Randomizer", "Select the version of your Dominus Collection on Steam. It will be displayed on the main splash screen. 1.0 is not supported yet.", nil, Qt::Application::UnicodeUTF8)
    @version_selector.toolTip = @version_label.toolTip
    @version_selector.addItem("1.03")
    @version_selector.addItem("1.01")
    @version_selector.setCurrentIndex(0)


    @randomize_enemy_drops.text = Qt::Application.translate("Randomizer", "Enemy Drops", nil, Qt::Application::UnicodeUTF8)
    @groupBox_8.title = Qt::Application.translate("Randomizer", "Sneak preview options (quite incomplete, some jank)", nil, Qt::Application::UnicodeUTF8)
    @groupBox_10.title = Qt::Application.translate("Randomizer", "Other randomization options", nil, Qt::Application::UnicodeUTF8)
    @randomize_shop.text = Qt::Application.translate("Randomizer", "Shop Items + Prices", nil, Qt::Application::UnicodeUTF8)
    @randomize_wooden_chests.text = Qt::Application.translate("Randomizer", "Wooden Chest Items", nil, Qt::Application::UnicodeUTF8)
    @tabWidget.setTabText(@tabWidget.indexOf(@tab), Qt::Application.translate("Randomizer", "Randomize", nil, Qt::Application::UnicodeUTF8))

    @phase_1_label.text = Qt::Application.translate("Randomizer", "PHASE 1 --- Setup!", nil, Qt::Application::UnicodeUTF8)
    @phase_2_label.text = Qt::Application.translate("Randomizer", "PHASE 2 --- Randomize!", nil, Qt::Application::UnicodeUTF8)
    @label_5.text = Qt::Application.translate("Randomizer", "Step 1: Select your game folder (SteamLibrary/steamapps/common/Castlevania Dominus Collection/)", nil, Qt::Application::UnicodeUTF8)
    @label_4.text = Qt::Application.translate("Randomizer", "Step 2: Select where backup game files will be stored. Can be same as above, or elsewhere. This is >800 MB.", nil, Qt::Application::UnicodeUTF8)
    @label_8.text = Qt::Application.translate("Randomizer", "Step 3: Create backup files. Only needs to be done once, unless you lose them somehow.", nil, Qt::Application::UnicodeUTF8)
    @label_6.text = Qt::Application.translate("Randomizer", "Step 4: Select where randomizer patches and spoiler logs will be stored. These files are relatively small.", nil, Qt::Application::UnicodeUTF8)
    @label_7.text = Qt::Application.translate("Randomizer", "Step 5: Select a seed name, and choose your game options in the Randomization Options tab.", nil, Qt::Application::UnicodeUTF8)
    @label_9.text = Qt::Application.translate("Randomizer", "Step 6: Press the Unrandomize button if you randomized the game already! Undoes the most recently applied patch.", nil, Qt::Application::UnicodeUTF8)
    @label_10.text = Qt::Application.translate("Randomizer", "Step 7: Press the Create Patch button. Check Auto-Apply if you want to skip the next step.", nil, Qt::Application::UnicodeUTF8)
    @auto_apply.text = Qt::Application.translate("Randomizer", "Auto-Apply", nil, Qt::Application::UnicodeUTF8)
    @label_11.text = Qt::Application.translate("Randomizer", "Step 8: Press the Apply Patch button to randomize the game! This will use the currently selected seed name.", nil, Qt::Application::UnicodeUTF8)
    @label_12.text = Qt::Application.translate("Randomizer", "Note: PLEASE do not share or download patch files! Use the Load Seed Info buttons below instead.", nil, Qt::Application::UnicodeUTF8)
    @label_13.text = Qt::Application.translate("Randomizer", "In order to randomize the game, this program can do anything to your game files, so downloading patches online is unsafe.", nil, Qt::Application::UnicodeUTF8)
    @tabWidget.setTabText(@tabWidget.indexOf(@tab_3), Qt::Application.translate("Randomizer", "Randomization Options", nil, Qt::Application::UnicodeUTF8))
    @groupBox_4.title = Qt::Application.translate("Randomizer", "Game adjustments", nil, Qt::Application::UnicodeUTF8)
    @remove_area_names.text = Qt::Application.translate("Randomizer", "Remove area names", nil, Qt::Application::UnicodeUTF8)
    @reveal_breakable_walls.text = Qt::Application.translate("Randomizer", "Reveal breakable walls", nil, Qt::Application::UnicodeUTF8)
    @groupBox.title = Qt::Application.translate("Randomizer", "Dawn of Sorrow", nil, Qt::Application::UnicodeUTF8)
    @groupBox_2.title = Qt::Application.translate("Randomizer", "Portrait of Ruin", nil, Qt::Application::UnicodeUTF8)
    @groupBox_3.title = Qt::Application.translate("Randomizer", "Order of Ecclesia", nil, Qt::Application::UnicodeUTF8)
    @always_dowsing.text = Qt::Application.translate("Randomizer", "Always have Dowsing Hat effect", nil, Qt::Application::UnicodeUTF8)
    @groupBox_11.title = Qt::Application.translate("Randomizer", "Portrait of Ruin && Order of Ecclesia", nil, Qt::Application::UnicodeUTF8)
    @randomize_bgm.text = Qt::Application.translate("Randomizer", "Music", nil, Qt::Application::UnicodeUTF8)
    @tabWidget.setTabText(@tabWidget.indexOf(@tab_5), Qt::Application.translate("Randomizer", "Help", nil, Qt::Application::UnicodeUTF8))
    @option_description.text = ''
    @load_seed_info_button.text = Qt::Application.translate("Randomizer", "Load Seed Info from Spoiler/Non-Spoiler Log", nil, Qt::Application::UnicodeUTF8)
    @paste_seed_info_button.text = Qt::Application.translate("Randomizer", "Paste Seed Info from Clipboard", nil, Qt::Application::UnicodeUTF8)
    @save_options_preset_button.text = Qt::Application.translate("Randomizer", "Save Current Options to Preset File", nil, Qt::Application::UnicodeUTF8)
    @load_options_preset_button.text = Qt::Application.translate("Randomizer", "Load Options from Preset File", nil, Qt::Application::UnicodeUTF8)
    @about_button.text = Qt::Application.translate("Randomizer", "About", nil, Qt::Application::UnicodeUTF8)
    @reset_settings_to_default.text = Qt::Application.translate("Randomizer", "Reset Randomization Options to Default", nil, Qt::Application::UnicodeUTF8)
    @randomize_button.text = Qt::Application.translate("Randomizer", "Create Patch", nil, Qt::Application::UnicodeUTF8)
    @apply_patch_button.text = Qt::Application.translate("Randomizer", "Apply Patch", nil, Qt::Application::UnicodeUTF8)
    @unrandomize_button.text = Qt::Application.translate("Randomizer", "Unrandomize", nil, Qt::Application::UnicodeUTF8)
    @permission_label.text = Qt::Application.translate("Randomizer", "Note: Windows can be picky about which folders you can write to. Take care there, or run this program in Administrator Mode.", nil, Qt::Application::UnicodeUTF8)


    @help_label.text = Qt::Application.translate("Randomizer", "Select a heading below to read detailed descriptions of the randomizer options. Click the About button to find out how to ask me other questions.", nil, Qt::Application::UnicodeUTF8)
    @open_world_label.text = Qt::Application.translate("Randomizer", "Some notes on a few open world options:\n\n- When Unlock Albus/Barlowe is selected, Barlowe will be given a duplicate of a progression glyph that exists somewhere else in the world. Absorb it when he casts Globus during the fight. Albus's Acerbatus will be replaced by a damaging glyph which may be a progression glyph, but may also not be. You can fight Albus/Barlowe at any time after the tutorial as soon as you're ready to survive the fight. I personally recommend enabling this option as it opens up the game considerably.\n\n- Cats that you find in the world will now give hints on the locations of Custos/Dominus glyphs (if you've selected Unlock Cerberus Gate it will only be Dominus hints.) The transformation required to talk to cats will be randomized if Unlock Cerberus Gate is selected. If not selected, to account for the hints being weaker, all transformations will be able to talk to cats.\nAlso, note that the hints will become more detailed when you've rescued all 3 cats other than Tom.\n\n- The split pools option makes glyphs only appear at glyph locations, and items only appear at item locations. Use this if you want slower checks like boss fights to be more valuable, or for seeds to be quicker on average.", nil, Qt::Application::UnicodeUTF8)
    @patches_label.text = Qt::Application.translate("Randomizer", "In order to avoid creating >800MB files every time you make a seed, the randomizer patches your game instead, and uses the same patch file to unrandomize it.\nPatch files are stored with their seed name. There will also be one set of patched files without a seed name. That's the most recently patched files. Make sure you don't delete those until you unrandomize your game. I may add a function to clean up your patch folder for you in the future.\n\nIn the event you do make a mistake and delete these patch files, you can use the Restore Game Files button above to unrandomize your game. It will take longer than unrandomizing normally.\n\nBy the way, you can still create multiple seeds in advance if you uncheck the Auto-Apply checkbox. When it's checked, you have to unrandomize the game first.", nil, Qt::Application::UnicodeUTF8)
    @modded_label.text = Qt::Application.translate("Randomizer", "The randomizer can theoretically be used even if you've already modded your game files with another mod, but it's not recommended. It's possible that the other mod may overwrite something that is also overwritten by the randomizer, and due to the patching method, this could produce bad results.\n\nThe checkbox is still there if you want to use it, but be aware that the randomizer can't tell anymore whether your game has been randomized, so it has to check against your backup file, and the Checking Files step may take longer.", nil, Qt::Application::UnicodeUTF8)
    @difficulty_preset_label.text = Qt::Application.translate("Randomizer", "You may currently choose from 3 different presets for the difficulty of the logic used to place items in your seed.\nYou can read more detailed descriptions in their specific headings below, but the quick summary is that Vanilla is the easiest and Do Your Worst is the hardest. Creative can be considered a middle ground which may require you to know some non-obvious aspects of the game.\n\nThe presets don't only consider movement such as double jump or flight. They also consider what equipment and damage glyphs are available, and make an attempt to arm you with at least a certain amount of gear appropriately to your difficulty. This system is still unfinished and will never be perfect, and it's subject to the whims of randomness, but it does its job in most cases, and is certainly better than nothing.\n\nIf you find an uncompletable seed according to the preset rules, please by all means share the spoiler log with me!", nil, Qt::Application::UnicodeUTF8)
    @vanilla_label.text = Qt::Application.translate("Randomizer", "Vanilla difficulty is named that because it shouldn't require much beyond the knowledge you gained from your first playthrough of the original game. Namely Ordinary Rock, Serpent Scale, Magnes, Volaticus, and Paries are the only movement pickups that are actually considered by Vanilla difficulty. It will still place others, but it will ensure that those 5 are enough for your movement needs. This means you won't be required to know how to use unconventional movement methods or tricks.\n\nIn addition, the randomizer will assume you are fighting enemies along the way instead of avoiding them, and will try to give you enough equipment and glyphs to do that.\nExamples:\n\nTymeo Mountains requires Gear Level 6.\nMystery Manor requires that you have Gear Level 12.\nAlbus requires that you have gear level 12 and a combat-ready Slash or Dark glyph.\nBlackmore requires that you have a Fire or Light glyph and Gear Level 14.\nFinal Approach requires that you have Gear Level 20.\n\nOverall this preset should be the most comfortable for people who want to fight enemies or who want to get strong movement items early.", nil, Qt::Application::UnicodeUTF8)
    @creative_label.text = Qt::Application.translate("Randomizer", "Creative difficulty opens up the toolset to allow a number of different ways to cross obstacles beyond what may be immediately obvious. If you aren't sure how to proceed, here are some things that may be required:\n- Arma Machina can break spikes\n- Arma Felix and Arma Chiroptera have invincibility on some attacks which can be used to cross spikes\n- Arma Felix has a pouncing attack that can provide extra momentum to cross gaps. Moonwalkers/Mercury Boots/Winged Boots can be used in a similar way.\n- Divekick off the breakable ledge in Minera Prison Island to proceed without Magnes.\n\nAs for combat logic, the Creative preset assumes you are playing for speed and will try to avoid enemies instead of fighting them. As a result, areas with denser enemies will be rated as more difficult than ones that are easier to avoid, even if they are later in the game. Some of the boss requirements are relaxed compared to vanilla, but some don't change much.\nExamples:\n\nTymeo Mountains has no gear requirement.\nMystery Manor requires Gear Level 8.\nAlbus requires Gear Level 12 and a Slash or Dark glyph.\nCastle Library requires Gear Level 6.\nFinal Approach requires Gear Level 20.\n\nOverall this preset should be most comfortable for people who want variety from their randomizer seed, and due to some complicated factors, it's also the fastest preset on average! I recommend it as it's the closest preset to well-tuned at the moment.", nil, Qt::Application::UnicodeUTF8)
    @worst_label.text = Qt::Application.translate("Randomizer", "Do Your Worst difficulty does what it says on the tin. All known non-glitched ways of proceeding through the game will be used by the randomizer logic and can be required of you. If you're a master of the game, you can handle it. This may involve making very precise backdash jumps, or divekicking off of moving enemies to reach pickup locations.\n\nThe gear considerations present in the other presets are basically completely absent here! You may be asked to do some long or difficult boss fights, or hoard healing items to traverse hazards.\n\nThis preset is for people who consider themselvers a veteran of the game and want to give the randomizer the opportunity to challenge them, although it's up to RNG whether it actually chooses to do so.", nil, Qt::Application::UnicodeUTF8)
    @gear_label.text = Qt::Application.translate("Randomizer", "Presets other than Do Your Worst will calculate an estimated Gear Level for the equipment placed in the seed thus far to determine whether you can reasonably traverse an area or defeat a boss. This calculation is still unfinished and quite vague, but should be better than nothing.\n\nThe way it works is each equipment has an assigned Tier, and the best available Tier in each equipment slot is added up to your total Gear Level.\n\nThe best tier is currently Tier 5, which includes only Queen of Hearts, Death Ring, and Judgement Ring.\nAn example of a Tier 4 item is Minerva Mail.\nAn example of a Tier 3 item is Strength Ring.\nAn example of a Tier 2 item is Party Dress.\nAn example of a Tier 1 item is Babushka.\nAnd Tier 0, the lowest, has items like Sandals or Gold Ring.\n\nIf you have 5 level 3 items, that makes Gear Level 15.\nBy the way, only equipment is tiered currently! The rest, including glyphs, is not.", nil, Qt::Application::UnicodeUTF8)
    end # retranslateUi

    def retranslate_ui(randomizer)
        retranslateUi(randomizer)
    end

end

module Ui
    class Randomizer < Ui_Randomizer
    end
end  # module Ui

