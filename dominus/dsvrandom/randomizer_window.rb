
require_relative 'ui_randomizer'
require_relative 'constants/options'
require_relative 'randomizer'
require 'fileutils'

class RandomizerWindow < Qt::Dialog
  VALID_SEED_CHARACTERS = "a-zA-Z0-9\\-_'%"

  slots "update_settings()"
  slots "browse_for_clean_rom()"
  slots "browse_for_output_folder()"
  slots "browse_for_patch_folder()"
  slots "generate_seed()"
  slots "unrandomize()"
  slots "randomize()"
  slots "apply_existing_patch()"
  slots "open_about()"
  slots "reset_settings_to_default()"
  slots "save_options_preset_to_file()"
  slots "load_options_preset_from_file()"
  slots "load_seed_info_from_file()"
  slots "paste_seed_info_from_clipboard()"
  slots "generate_backup()"
  slots "restore_backup()"
  slots "difficulty_changed(int)"
  slots "version_changed(int)"

  def initialize
    super(nil, Qt::WindowMinimizeButtonHint)
    @ui = Ui_Randomizer.new
    @ui.setup_ui(self)

    @currently_selected_game = nil

    preserve_default_settings()

    load_settings()

    connect(@ui.clean_rom, SIGNAL("editingFinished()"), self, SLOT("update_settings()"))
    connect(@ui.clean_rom_browse_button, SIGNAL("clicked()"), self, SLOT("browse_for_clean_rom()"))
    connect(@ui.output_folder, SIGNAL("editingFinished()"), self, SLOT("update_settings()"))
    connect(@ui.output_folder_browse_button, SIGNAL("clicked()"), self, SLOT("browse_for_output_folder()"))
    connect(@ui.patch_folder, SIGNAL("editingFinished()"), self, SLOT("update_settings()"))
    connect(@ui.patch_folder_browse_button, SIGNAL("clicked()"), self, SLOT("browse_for_patch_folder()"))
    connect(@ui.generate_seed_button, SIGNAL("clicked()"), self, SLOT("generate_seed()"))
    connect(@ui.seed, SIGNAL("editingFinished()"), self, SLOT("update_settings()"))
    connect(@ui.rv_difficulty, SIGNAL("activated(int)"), self, SLOT("difficulty_changed(int)"))
    connect(@ui.version_selector, SIGNAL("activated(int)"), self, SLOT("version_changed(int)"))

    Options.options.each_key do |option_name|
      connect(@ui.send(option_name), SIGNAL("clicked(bool)"), self, SLOT("update_settings()"))

      @ui.send(option_name).installEventFilter(self)
    end

    connect(@ui.send(:auto_apply), SIGNAL("clicked(bool)"), self, SLOT("update_settings()"))
    connect(@ui.send(:lock_backup), SIGNAL("clicked(bool)"), self, SLOT("update_settings()"))
    connect(@ui.send(:modded_game), SIGNAL("clicked(bool)"), self, SLOT("update_settings()"))

    connect(@ui.generate_backup_button, SIGNAL("clicked()"), self, SLOT("generate_backup()"))
    connect(@ui.restore_backup_button, SIGNAL("clicked()"), self, SLOT("restore_backup()"))
    connect(@ui.randomize_button, SIGNAL("clicked()"), self, SLOT("randomize()"))
    connect(@ui.apply_patch_button, SIGNAL("clicked()"), self, SLOT("apply_existing_patch()"))
    connect(@ui.about_button, SIGNAL("clicked()"), self, SLOT("open_about()"))
    connect(@ui.reset_settings_to_default, SIGNAL("clicked()"), self, SLOT("reset_settings_to_default()"))

    connect(@ui.unrandomize_button, SIGNAL("clicked()"), self, SLOT("unrandomize()"))

    self.setWindowTitle("DSVania Randomizer #{DSVRANDOM_VERSION}")

    update_settings()

    connect(@ui.save_options_preset_button, SIGNAL("clicked()"), self, SLOT("save_options_preset_to_file()"))
    connect(@ui.load_options_preset_button, SIGNAL("clicked()"), self, SLOT("load_options_preset_from_file()"))
    connect(@ui.load_seed_info_button, SIGNAL("clicked()"), self, SLOT("load_seed_info_from_file()"))
    connect(@ui.paste_seed_info_button, SIGNAL("clicked()"), self, SLOT("paste_seed_info_from_clipboard()"))

    self.resize(self.width, 1)

    self.show()
  end

  def preserve_default_settings
    @default_settings = {}
    Options.options.each_key do |option_name|
      @default_settings[option_name] = @ui.send(option_name).checked
    end
  end

  def reset_settings_to_default
    any_setting_changed = false
    Options.options.each_key do |option_name|
      if @default_settings.key?(option_name)
        default_value = @default_settings[option_name]
        current_value = @ui.send(option_name).checked
        if default_value != current_value
          any_setting_changed = true
        end
        @ui.send(option_name).checked = default_value
      end
    end

    if any_setting_changed
      update_settings()
    else
      Qt::MessageBox.information(self,
        "Settings already default",
        "You already have all the default randomization settings."
      )
    end
  end

  def load_settings
    @settings_path = "randomizer_settings.yml"
    if File.file?(@settings_path)
      @settings = YAML::load_file(@settings_path)
    else
      @settings = {}
    end

    @ui.clean_rom.setText(@settings[:clean_rom_path]) if @settings[:clean_rom_path]
    @ui.output_folder.setText(@settings[:output_folder]) if @settings[:output_folder]
    @ui.patch_folder.setText(@settings[:patch_folder]) if @settings[:patch_folder]
    @ui.seed.setText(@settings[:seed]) if @settings[:seed]
    @ui.auto_apply.setChecked(@settings[:auto_apply]) if not @settings[:auto_apply].nil?
    @ui.lock_backup.setChecked(@settings[:lock_backup]) if not @settings[:lock_backup].nil?
    @ui.modded_game.setChecked(@settings[:modded_game]) if not @settings[:modded_game].nil?

    Options.options.each_key do |option_name|
      @ui.send(option_name).setChecked(@settings[option_name]) unless @settings[option_name].nil?
    end

    rv_difficulty_index = @ui.rv_difficulty.findText(@settings[:rv_difficulty].to_s)
    if rv_difficulty_index != -1
      @ui.rv_difficulty.setCurrentIndex(rv_difficulty_index)
    end
    version_index = @ui.version_selector.findText(@settings[:version].to_s)
    if version_index != -1
      @ui.version_selector.setCurrentIndex(version_index)
    end
  end

  def browse_for_clean_rom
    if @settings[:clean_rom_path] && File.directory?(@settings[:clean_rom_path])
      default_dir = @settings[:clean_rom_path]
    end

    clean_rom_path = Qt::FileDialog.getExistingDirectory(self, "Select backup folder", default_dir)
    return if clean_rom_path.nil?

    @ui.clean_rom.text = clean_rom_path

    update_settings()
  end

  def browse_for_output_folder
    if @settings[:output_folder] && File.directory?(@settings[:output_folder])
      default_dir = @settings[:output_folder]
    end

    output_folder_path = Qt::FileDialog.getExistingDirectory(self, "Select output folder", default_dir)
    return if output_folder_path.nil?
    @ui.output_folder.text = output_folder_path
    update_settings()
  end

  def browse_for_patch_folder
    if @settings[:patch_folder] && File.directory?(@settings[:patch_folder])
      default_dir = @settings[:patch_folder]
    end

    patch_folder_path = Qt::FileDialog.getExistingDirectory(self, "Select patch/log folder", default_dir)
    return if patch_folder_path.nil?

    @ui.patch_folder.text = patch_folder_path
    update_settings()
  end

  def update_settings
    @settings[:clean_rom_path] = @ui.clean_rom.text
    @settings[:output_folder] = @ui.output_folder.text
    @settings[:patch_folder] = @ui.patch_folder.text
    @settings[:seed] = @ui.seed.text
    @settings[:auto_apply] = @ui.auto_apply.checked
    @settings[:lock_backup] = @ui.lock_backup.checked
    @settings[:modded_game] = @ui.modded_game.checked

    ensure_valid_combination_of_options()

    Options.options.each_key do |option_name|
      @settings[option_name] = @ui.send(option_name).checked
    end

    @settings[:rv_difficulty] = @ui.rv_difficulty.itemText(@ui.rv_difficulty.currentIndex)
    @settings[:version] = @ui.version_selector.itemText(@ui.version_selector.currentIndex)

    save_settings()
  end

  def save_settings
    File.open(@settings_path, "w") do |f|
      f.write(@settings.to_yaml)
    end
  end

  def eventFilter(target, event)
    if event.type() == Qt::Event::Enter
      option_description = Options.options[target.objectName.to_sym]
      @ui.option_description.text = option_description
      return true
    elsif event.type() == Qt::Event::Leave
      @ui.option_description.text = ""
      return true
    end

    super(target, event)
  end

  def get_current_options_hash
    options_hash = {}

    Options.options.each_key do |option_name|
      # Options that are disabled don't count as being checked, even though they visually remain checked when disabled.
      options_hash[option_name] = @ui.send(option_name).checked && @ui.send(option_name).enabled
    end
    options_hash[:seed] = @settings[:seed]

    return options_hash
  end

  def ensure_valid_combination_of_options
    should_enable_options = {}
    Options.options.each_key do |option_name|
      should_enable_options[option_name] = true
    end

    pickup_randomizer_dependent_options = [
      :rv_split_pools,
      :rv_puzzle_progression
    ]
    if not @ui.randomize_pickups.checked
      pickup_randomizer_dependent_options.each do |option_name|
        should_enable_options[option_name] &&= false
      end
    end
    Options.options.each_key do |option_name|
      if should_enable_options[option_name]
        @ui.send(option_name).enabled = true
      else
        @ui.send(option_name).enabled = false
        @ui.send(option_name).checked = false
      end
    end
    @ui.rv_open_castle.setEnabled(false)
    @ui.rv_randomize_quest_rewards.setEnabled(false)
    @ui.rv_non_vanilla_glyphs.setEnabled(false)
    @ui.randomize_shop.setEnabled(false)
  end

  def difficulty_changed(diff_index)
    @ui.rv_difficulty.setCurrentIndex(diff_index)
    update_settings()
  end

  def version_changed(version_index)
    @ui.version_selector.setCurrentIndex(version_index)
    update_settings()
  end

  def generate_seed
    # Generate a new random seed composed of 2 adjectives and a noun.
    adjectives = File.read("./dsvrandom/seedgen_adjectives.txt").split("\n").sample(2)
    noun = File.read("./dsvrandom/seedgen_nouns.txt").split("\n").sample
    words = adjectives + [noun]
    words.map!{|word| word.capitalize}
    seed = words.join("")

    @settings[:seed] = seed
    @ui.seed.text = @settings[:seed]
    save_settings()
  end

  def generate_backup
    if @settings[:lock_backup]
      Qt::MessageBox.critical(self, "Backups are locked", "You have locked your backups to prevent overwriting. Uncheck the Locked checkbox to enable backup generation.")
      return
    end
    game_folder = @ui.output_folder.text
    backup_folder = @ui.clean_rom.text

    @progress_dialog = ProgressDialog.new("Generating", "This will pause at 5%...", 100)
    @progress_dialog.execute do
      begin
        copy_backup_files(game_folder, backup_folder) do |options_completed|
          break if @progress_dialog.nil?

          Qt.execute_in_main_thread do
            if @progress_dialog && !@progress_dialog.wasCanceled
              @progress_dialog.setValue(options_completed)
            end
          end
        end
      rescue StandardError => e
        Qt.execute_in_main_thread do
          if @progress_dialog
            @progress_dialog.setValue(100) unless @progress_dialog.wasCanceled
            @progress_dialog.reset()
            @progress_dialog = nil
          end

          Qt::MessageBox.critical(self, "Task Failed", "Generating backups failed with error:\n#{e.message}")
        end
        return
      end

      Qt.execute_in_main_thread do
        if @progress_dialog
          @progress_dialog.setValue(100) unless @progress_dialog.wasCanceled
          @progress_dialog.reset()
          @progress_dialog = nil
        end

        msg = "Successfully created backup files."

        Qt::MessageBox.information(self, "Done", msg)
      end
    end
  end

  def copy_backup_files(game_folder, backup_folder)
    options_completed = 0
    ["dra03", "/windata/alldata"].each do |shortname|
      extension = shortname == "dra03" ? ".dll" : ".bin"
      filename = "#{game_folder}/#{shortname}#{extension}"
      new_filename = "#{backup_folder}/#{shortname}_backup3#{extension}"
      if not File.file?(filename)
        raise "You are missing at least one necessary game file from the selected Game Folder. Using Steam's Verify Integrity of Game Files feature can help with this."
      end
      FileUtils.copy(filename, new_filename)
      options_completed += shortname == "dra03" ? 5 : 95
      yield options_completed
    end
  end

  def generate_backup
    if @settings[:lock_backup]
      Qt::MessageBox.critical(self, "Backups are locked", "You have locked your backups to prevent overwriting. Uncheck the Locked checkbox to enable backup generation.")
      return
    end
    game_folder = @ui.output_folder.text
    backup_folder = @ui.clean_rom.text

    @progress_dialog = ProgressDialog.new("Generating", "This will pause at 5%...", 100)
    @progress_dialog.execute do
      begin
        copy_backup_files(game_folder, backup_folder) do |options_completed|
          break if @progress_dialog.nil?

          Qt.execute_in_main_thread do
            if @progress_dialog && !@progress_dialog.wasCanceled
              @progress_dialog.setValue(options_completed)
            end
          end
        end
      rescue StandardError => e
        Qt.execute_in_main_thread do
          if @progress_dialog
            @progress_dialog.setValue(100) unless @progress_dialog.wasCanceled
            @progress_dialog.reset()
            @progress_dialog = nil
          end

          Qt::MessageBox.critical(self, "Task Failed", "Generating backups failed with error:\n#{e.message}")
        end
        return
      end

      Qt.execute_in_main_thread do
        if @progress_dialog
          @progress_dialog.setValue(100) unless @progress_dialog.wasCanceled
          @progress_dialog.reset()
          @progress_dialog = nil
        end

        msg = "Successfully created backup files."

        Qt::MessageBox.information(self, "Done", msg)
      end
    end
  end

  def copy_backup_files(game_folder, backup_folder, restore = false)
    options_completed = 0
    ["dra03", "/windata/alldata"].each do |shortname|
      extension = shortname == "dra03" ? ".dll" : ".bin"
      if restore
        filename = "#{backup_folder}/#{shortname}_backup#{extension}"
        new_filename = "#{game_folder}/#{shortname}#{extension}"
      else
        filename = "#{game_folder}/#{shortname}#{extension}"
        new_filename = "#{backup_folder}/#{shortname}_backup#{extension}"
      end
      if not File.file?(filename)
        if reverse
          raise "You are missing at least one backup file, so this tool cannot help you.\n\nUse Steam's Verify Integrity of Game Files feature to unrandomize your game."
        else
          raise "You are missing at least one necessary game file from the selected Game Folder. Using Steam's Verify Integrity of Game Files feature can help with this."
        end
      end
      FileUtils.copy(filename, new_filename)
      options_completed += shortname == "dra03" ? 5 : 95
      yield options_completed
    end
  end

  def restore_backup
    game_folder = @ui.output_folder.text
    backup_folder = @ui.clean_rom.text

    @progress_dialog = ProgressDialog.new("Restoring", "This will pause at 5%...", 100)
    @progress_dialog.execute do
      begin
        copy_backup_files(game_folder, backup_folder, true) do |options_completed|
          break if @progress_dialog.nil?

          Qt.execute_in_main_thread do
            if @progress_dialog && !@progress_dialog.wasCanceled
              @progress_dialog.setValue(options_completed)
            end
          end
        end
      rescue StandardError => e
        Qt.execute_in_main_thread do
          if @progress_dialog
            @progress_dialog.setValue(100) unless @progress_dialog.wasCanceled
            @progress_dialog.reset()
            @progress_dialog = nil
          end

          Qt::MessageBox.critical(self, "Task Failed", "Restoring from backups failed with error:\n#{e.message}")
        end
        return
      end

      Qt.execute_in_main_thread do
        if @progress_dialog
          @progress_dialog.setValue(100) unless @progress_dialog.wasCanceled
          @progress_dialog.reset()
          @progress_dialog = nil
        end

        msg = "Successfully restored your game files."

        Qt::MessageBox.information(self, "Done", msg)
      end
    end
  end

  def randomize(mode = :normal)
    if mode == :normal and @ui.auto_apply.checked
      mode = :auto_apply
    end

    seed = @settings[:seed].to_s.strip.gsub(/\s/, "")

    if seed.empty?
      generate_seed()
      seed = @settings[:seed]
    end

    if seed =~ /[^#{VALID_SEED_CHARACTERS}]/
      Qt::MessageBox.critical(self, "Invalid seed", "Invalid seed. Seed can only have letters, numbers, dashes, underscores, and apostrophes in it.")
      return
    end

    @settings[:seed] = seed
    @ui.seed.text = @settings[:seed]
    save_settings()

    @sanitized_seed = seed

    options_hash = get_current_options_hash()

    begin
      randomizer = Randomizer.new(seed, @settings[:clean_rom_path], @settings[:output_folder], @settings[:patch_folder], @settings[:rv_difficulty], @settings[:version], @settings[:modded_game], options_hash, mode)
    rescue StandardError => e
      Qt::MessageBox.critical(self, "Randomization Task Failed", "Randomization task failed with error:\n#{e.message}\n\n#{e.backtrace.join("\n")}")
      return
    end

    max_val = 0
    max_val += 50 if options_hash[:randomize_pickups]
    max_val += 50 # Initialization
    max_val += 1 if options_hash[:randomize_wooden_chests]
    max_val += 2 if options_hash[:randomize_enemy_drops]
    max_val += 1 if options_hash[:randomize_bgm]

    @progress_dialog = ProgressDialog.new("Randomizing", "Initializing...", max_val)
    @progress_dialog.execute do
      begin
        randomizer.randomize() do |options_completed, next_option_description|
          break if @progress_dialog.nil?

          Qt.execute_in_main_thread do
            if @progress_dialog && !@progress_dialog.wasCanceled
              @progress_dialog.setValue(options_completed)
              @progress_dialog.labelText = next_option_description
            end
          end
        end
      rescue StandardError => e
        Qt.execute_in_main_thread do
          if @progress_dialog
            @progress_dialog.setValue(max_val) unless @progress_dialog.wasCanceled
            @progress_dialog.reset()
            @progress_dialog = nil
          end

          write_logs(randomizer, is_error: true)

          Qt::MessageBox.critical(self, "Randomization Task Failed", "Randomization task failed with error:\n#{e.message}\n\n#{e.backtrace.join("\n")}")
        end
        return
      end

      Qt.execute_in_main_thread do
        if @progress_dialog
          @progress_dialog.setValue(max_val) unless @progress_dialog.wasCanceled
          @progress_dialog.reset()
          @progress_dialog = nil
        end

        write_logs(randomizer)

        msg = "Randomization task complete.\n\n"
        msg << "If you get stuck, check the FAQ in the readme,\nand the progression spoiler log in the output folder."

        Qt::MessageBox.information(self, "Done", msg)
      end
    end

  end
  alias randomize_n_seeds randomize

  def apply_existing_patch()
    randomize(:apply)
  end

  def unrandomize()
    randomize(:reverse)
  end

  def write_logs(randomizer, is_error: false)
    if is_error
      logs = [randomizer.spoiler_log]
    else
      logs = [randomizer.spoiler_log, randomizer.non_spoiler_log]
    end
    logs.compact!

    logs.each do |log|
      log.seek(0)
      spoiler_str = log.read()

      game_with_caps = "OoE"
      if is_error
        output_log_filename = "#{game_with_caps} #{@sanitized_seed} - Error Log.txt"
      elsif log == randomizer.non_spoiler_log
        output_log_filename = "#{game_with_caps} #{@sanitized_seed} - Non-Spoiler Log.txt"
      else
        output_log_filename = "#{game_with_caps} #{@sanitized_seed} - Spoiler Log.txt"
      end
      output_log_path = File.join(@ui.output_folder.text, output_log_filename)

      File.open(output_log_path, "w") do |f|
        f.write(spoiler_str)
      end
    end
  end

  def open_about
    @about_dialog = Qt::MessageBox.new
    @about_dialog.setTextFormat(Qt::RichText)
    @about_dialog.setWindowTitle("DSVRandom RED Version")
    base_text = "DSVania Randomizer #{DSVRANDOM_VERSION}<br><br>" +
      "Dominus version for OoE by apple_for_you<br>" +
      "Based on the original DSVania randomizer by LagoLunatic<br><br>" +
      "Report issues here:<br><a href=\"https://github.com/appleforyou/dsvrandom-rv/issues\">https://github.com/appleforyou/dsvrandom-rv/issues</a><br><br>" +
      "Check for updates here:<br><a href=\"https://github.com/appleforyou/dsvrandom-rv/releases\">https://github.com/appleforyou/dsvrandom-rv/releases</a><br>" +
      "<a href=\"https://bsky.app/profile/appleforyou.bsky.social\">https://bsky.app/profile/appleforyou.bsky.social</a><br><br>" +
      "Source code:<br><a href=\"https://github.com/appleforyou/dsvrandom-rv\">https://github.com/appleforyou/dsvrandom-rv</a><br>" +
      "<a href=\"https://github.com/LagoLunatic/dsvrandom\">https://github.com/LagoLunatic/dsvrandom</a><br><br>"
    @about_dialog.setText(base_text)
    @about_dialog.windowIcon = self.windowIcon
    @about_dialog.show()
  end

  def save_options_preset_to_file
    if @settings[:options_presets_folder] && File.directory?(@settings[:options_presets_folder])
      default_dir = @settings[:options_presets_folder]
    else
      FileUtils.mkdir_p("./DSVRandom Presets")
      default_dir = "./DSVRandom Presets"
    end

    preset_path, selected_filter = Qt::FileDialog.getSaveFileName(self, "Save options preset", default_dir, "DSVRandom Preset Files (*.dsvrpreset)")
    return if preset_path.nil?

    text = create_options_preset_from_current_settings()
    return if text.nil?

    File.open(preset_path, "wb") do |f|
      f.write(text)
    end

    basename = File.basename(preset_path)
    dirname = File.dirname(preset_path)

    @settings[:options_presets_folder] = dirname
    update_settings()

    Qt::MessageBox.information(self, "Saved options preset", "Successfully saved options preset \"%s\"." % basename)
  end

  def create_options_preset_from_current_settings
    text = StringIO.new

    options = get_current_options_hash()

    options_string = options.select{|k,v| v == true}.keys.join(", ")

    text.puts "DSVRandom Options Preset, Randomizer version: #{DSVRANDOM_VERSION}"
    text.puts "Selected options: #{options_string}"
    text.puts "Difficulty: #{options[:rv_difficulty]}"

    return text.string
  end

  def load_options_preset_from_file
    if @settings[:options_presets_folder] && File.directory?(@settings[:options_presets_folder])
      default_dir = @settings[:options_presets_folder]
    end

    preset_path = Qt::FileDialog.getOpenFileName(self, "Select options preset", default_dir, "DSVRandom Preset Files (*.dsvrpreset)")
    return if preset_path.nil?

    text = File.read(preset_path)
    read_seed_info(text, is_preset=true)

    dirname = File.dirname(preset_path)

    @settings[:options_presets_folder] = dirname
    update_settings()
  end

  def load_seed_info_from_file
    if @settings[:patch_folder] && File.directory?(@settings[:patch_folder])
      default_dir = @settings[:patch_folder]
    end

    log_path = Qt::FileDialog.getOpenFileName(self, "Select spoiler/non-spoiler log", default_dir, "Text files (*.txt)")
    return if log_path.nil?

    text = File.read(log_path)
    read_seed_info(text)
  end

  def paste_seed_info_from_clipboard
    text = $qApp.clipboard.text()
    read_seed_info(text)
  end

  def read_seed_info(text, is_preset=false)
    if is_preset
      format_type = "options preset"
    else
      format_type = "seed info"
    end

    if text.nil? || text.strip == ""
      if is_preset
        raise "#{format_type.capitalize} is blank."
      else
        raise "No #{format_type} input."
      end
    end

    if is_preset
      match = text.match(/DSVRandom Options Preset, Randomizer version: (.+)\s+Selected options: (.+)\s+Difficulty: (.+)/)
      if match.nil?
        raise "#{format_type.capitalize} is not in the proper format."
      end

      seed = ""
      game = "Order of Ecclesia"
      version = $1
      options = $2.split(", ").map(&:to_sym)
      difficulty = $3
    else
      match = text.match(/Seed: ([#{VALID_SEED_CHARACTERS}]+), Randomizer version: (.+)\s+Selected options: (.+)\s+Difficulty: (.+)/)
      if match.nil?
        raise "#{format_type.capitalize} is not in the proper format."
      end

      seed = $1
      version = $2
      options = $3.split(", ").map(&:to_sym)
      difficulty = $4
      game = "Order of Ecclesia"
    end

    if version != DSVRANDOM_VERSION
      raise "Wrong version! This is for #{version}, but you are on #{DSVRANDOM_VERSION}"
    end

    short_game_name = case game
    when "Order of Ecclesia"
      "ooe"
    else
      raise "Invalid game name: #{game}"
    end

    @ui.seed.text = seed
    options.each do |option_name|
      if !@ui.respond_to?(option_name)
        raise "Invalid options name found in #{format_type}: \"#{option_name}\""
      end
      @ui.send(option_name).checked = true
    end
    (Options.options.keys-options).each do |option_name|
      @ui.send(option_name).checked = false
    end

    @ui.tabWidget.currentIndex = 0
    update_settings()

    msg = "Successfully read #{format_type}."
    Qt::MessageBox.information(self, "Read #{format_type}", msg)
  rescue StandardError => e
    puts e.message
    puts e.backtrace.join("\n")
    Qt::MessageBox.warning(self, "#{format_type.capitalize} input failed", e.message)
  end
end


class ProgressDialog < Qt::ProgressDialog
  slots "cancel_thread()"

  def initialize(title, description, max_val)
    super()
    self.windowTitle = title
    self.labelText = description
    self.maximum = max_val
    self.windowModality = Qt::ApplicationModal
    self.windowFlags = Qt::CustomizeWindowHint | Qt::WindowTitleHint
    self.setFixedSize(self.size);
    self.autoReset = false
    connect(self, SIGNAL("canceled()"), self, SLOT("cancel_thread()"))
    self.show
  end

  def execute(&block)
    @thread = Thread.new do
      yield
    end
  end

  def cancel_thread
    @thread.kill
    self.close()
  end
end