require 'json'
require 'fileutils'

class GameFile

  attr_reader :name,
              :apply_patch

  def initialize(game, backup_file, game_file, patch_folder, target_md5, options, mode = :normal, &block)
    if backup_file == game_file
      raise "Input file and output file must have different filenames!"
    elsif /backup/.match?(game_file)
      raise "Selected a backup file as an output file!"
    end
    @patches = {}
    @game = game
    @backup_file = backup_file
    @game_file = game_file
    @patch_folder = patch_folder
    @name = File.basename(game_file)
    @options = options
    if /alldata/.match?(backup_file)
      @version_offset = @options[:version] == "1.03" ? 0x3800 : 0x0
    else
      @version_offset = 0x0
    end
    md5 = Digest::MD5.file game_file
    if @options[:modded_game]
      target_md5 = Digest::MD5.file backup_file
    end
    if md5 == target_md5
      if mode == :reverse
        raise "Attempting to unrandomize a clean file!"
      else
        #puts "Skipping #{game_file}"
      end
      yield 2
    else
      if [:apply, :auto_apply].include?(mode)
        if @options[:modded_game]
          raise "Patching a patched file! That won't work!"
        else
          raise "Patching a patched file! That won't work!\n\nIf your game has other mods, please check the box for that.\nNote that the randomizer is not guaranteed to play nicely with other mods."
        end
      end
      #f = File.binread(backup_file)
      yield 1
      #File.binwrite(game_file, f)
      yield 2
    end
  end

  def [](offset, bytes = 1, length = 1)
    encoding = "C*"
    if bytes == 2
      encoding = "v*"
      length *= 2
    elsif bytes == 4
      encoding = "V*"
      length *= 4
    end
    #if version == "1.03"
    #if /dra03/.match?(@backup_file)
      #offset -= 0x30
    #elsif /alldata/.match?(@backup_file)
      #offset += 0x3400
    #end
    result = File.binread(@backup_file, length, offset+@version_offset).unpack(encoding)
    if result.size == 1
      return result[0]
    else
      return result
    end
  end

  alias read []

  def testwrite(i, bytes = 1, content)
    if content.nil?
      raise "Trying to write a nil value"
    end
    encoding = "C*"
    if bytes == 2
      encoding = "v*"
    end
    if !content.kind_of?(Array)
      content = [content]
    end
    patch_filename = @game_file + ".patch"
    patch_content = [i, content.pack(encoding)]
    @patches += patch_content
  end

  def []=(i, bytes = 1, content)
    if content.nil?
      raise "Trying to write a nil value"
    end
    encoding = "C*"
    if bytes == 2
      encoding = "v*"
    elsif bytes == 4
      encoding = "V*"
    end
    if !content.kind_of?(Array)
      content = [content]
    end

    using_patch = true
    if using_patch
      dest_content = content.pack(encoding).unpack("C*")
      source_content = File.binread(@backup_file, dest_content.size, i+@version_offset)
      content_delta = Array.new(dest_content.size)
      source_content.unpack("C*").each_with_index do |byte, index|
        content_delta[index] = dest_content[index] - byte
      end
      patch_content = [i+@version_offset, content_delta.pack("C*")]
      @patches[i+@version_offset] = content_delta
    #end
    else
      File.binwrite(@game_file, content.pack(encoding).unpack("C*"), i+@version_offset)
    end
  end

  alias write []=

  def write_patch()
    patch_filename = "#{@patch_folder}/#{@name}_#{@game.options[:seed]}.patch"
    total_patch = @patches.to_json
    File.binwrite(patch_filename, total_patch)
  end

  def apply_patch(mode = :apply)
    patch_filename = "#{@patch_folder}/#{@name}_#{@game.options[:seed]}.patch"
    new_filename = "#{@patch_folder}/#{@name}.patch"
    if mode != :reverse
      if not File.file?(patch_filename)
        raise "A patch file for that seed doesn't exist yet!\nMake sure to press Create Patch first."
      else
        FileUtils.copy(patch_filename, new_filename)
      end
    else
      if not File.file?(new_filename)
        raise "Can't unrandomize the game due to missing file.\n\nNo recent patch file exists. When a patch is applied, a copy of the patch files is made without the seed name in it, and this is treated as the most recent seed.\n\nWithout that file, you will need to restore your game files from your backups. There is a button for that in the Help tab.\nIf you don't have the backups either, try Steam's Verify Integrity of Game Files tool."
      end
    end
    patches_to_use = JSON.parse(File.binread(new_filename))
    patches_to_use.each do |offset, content_delta|
      offset = offset.to_i
      if content_delta.nil?
        raise "Trying to write a nil value"
      end
      source_file = mode == :reverse ? @game_file : @backup_file
      source_content = File.binread(source_file, content_delta.size, offset)
      output_content = Array.new(content_delta.size)
      modifier = mode == :reverse ? -1 : 1
      source_content.unpack("C*").each_with_index do |byte, index|
        output_content[index] = byte + content_delta[index] * modifier
      end
      File.binwrite(@game_file, output_content.pack("C*"), offset)
    end
  end
end
