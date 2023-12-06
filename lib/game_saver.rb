# frozen_string_literal: true

require 'yaml'

# Saves and loads games
module GameSaver
  DEFAULT_DIR = '.saved'

  def save(game_object, filename)
    make_dir

    File.open("#{DEFAULT_DIR}/#{filename}", 'w') { |file| file.puts YAML.dump(game_object) }
  rescue StandardError
    File.open(standard_filename, 'w') { |file| file.puts YAML.dump(game_object) }
  end

  def load(filename)
    raise StandardError, 'File not found' unless File.exist?("#{DEFAULT_DIR}/#{filename}")

    File.open("#{DEFAULT_DIR}/#{filename}", 'r') do |file|
      YAML.safe_load_file(file, permitted_classes: [Hangman, SecretWord])
    end
  end

  def make_dir
    Dir.mkdir(DEFAULT_DIR) unless Dir.exist?(DEFAULT_DIR)
  end

  def standard_filename
    "#{DEFAULT_DIR}/#{Time.now.to_i}"
  end
end
