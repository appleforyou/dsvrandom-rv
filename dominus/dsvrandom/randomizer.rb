require 'digest/md5'

require_relative '../dsvlib/game'
require_relative 'randomizers/pickup_randomizer'
require_relative 'randomizers/drop_randomizer'
require_relative 'randomizers/chest_pool_randomizer'
require_relative 'randomizers/music_randomizer'
require_relative 'randomizers/shop_randomizer'
require_relative 'rv/ooe_checker'

class Randomizer

  attr_reader :spoiler_log,
              :non_spoiler_log

  def initialize(seed, input_folder, output_folder, patch_folder, settings, options, mode = :normal)
    @seed = seed
    @int_seed = Digest::MD5.hexdigest(seed).to_i(16)
    @rng = Random.new(@int_seed)
    @game_folder = output_folder
    @backup_folder = input_folder
    @patch_folder = patch_folder
    @options = options
    @mode = mode
    options[:rv_difficulty] = settings[:rv_difficulty]
    options[:version] = settings[:version]
    options[:modded_game] = settings[:modded_game]
    options[:rv_hint_cat_locations] = settings[:rv_hint_cat_locations]
    @checker = OoEChecker.new(options, @rng)
    if seed.nil? || seed.empty?
      raise "No seed given"
    end
  end

  def randomize()
    options_completed = 0

    game = Game.new(@options, @game_folder, @backup_folder, @patch_folder, @checker, @mode, @rng) do |stages_done|
      yield [options_completed + (stages_done.to_f * 10.0), "Checking base files..."]
    end
    reset_rng()
    options_string = @options.select{|k,v| v == true}.keys.join(", ")

    if [:normal, :auto_apply].include?(@mode)
      @spoiler_log = StringIO.new
      @non_spoiler_log = StringIO.new
      @logs = [@spoiler_log, @non_spoiler_log]

      @logs.each do |log|
        log.puts "Seed: #{@seed}, Randomizer version: #{DSVRANDOM_VERSION}"
        log.puts "Selected options: #{options_string}"
        log.puts "Difficulty: #{@options[:rv_difficulty]}"
        log.puts "Hint cat locations: #{@options[:rv_hint_cat_locations]}"
      end
    end

    options_completed += 50 # Initialization

    if @options[:randomize_pickups] and [:normal, :auto_apply].include?(@mode)
      yield [options_completed, "Placing static pickups..."]
      PickupRandomizer.new(@rng, game, @logs) do |percent|
        yield [options_completed+percent*50.0, "Placing static pickups..."]
      end
      options_completed += 50
    end

    if @options[:randomize_wooden_chests] and [:normal, :auto_apply].include?(@mode)
      yield [options_completed, "Creating wooden chest pools..."]
      reset_rng()
      ChestPoolRandomizer.new(@rng, game)
      options_completed += 1
    end

    if @options[:randomize_shop] and [:normal, :auto_apply].include?(@mode)
      yield [options_completed, "Randomizing shop items..."]
      reset_rng()
      ShopRandomizer.new(@rng, game)
      options_completed += 1
    end

    if @options[:randomize_enemy_drops] and [:normal, :auto_apply].include?(@mode)
      yield [options_completed, "Randomizing enemy drops..."]
      reset_rng()
      DropRandomizer.new(@rng, game, @logs) do |percent|
        yield [options_completed+percent*2.0, "Randomizing enemy drops..."]
      end
      options_completed += 2
    end

    if @options[:randomize_bgm] and [:normal, :auto_apply].include?(@mode)
      yield [options_completed, "Randomizing background music..."]
      reset_rng()
      MusicRandomizer.new(@rng, game) do |percent|
        yield [options_completed+percent*1.0, "Randomizing background music..."]
      end
      options_completed += 1
    end

    if [:normal, :auto_apply].include?(@mode)
      game.write_patch()
    end
    if @mode != :normal
      game.apply_patch(@mode)
    end
  rescue StandardError => e
    if @spoiler_log
      @logs.each do |log|
        log.puts "ERROR! Randomization failed with error:\n  #{e.message}\n  #{e.backtrace.join("\n  ")}"
      end
    end
    raise e
  end

  def reset_rng
    @rng = Random.new(@int_seed)
  end
end
