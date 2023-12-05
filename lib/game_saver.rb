# frozen_string_literal: true

require 'yaml'

# Saves and loads games
module GameSaver
  def save(game, filename)
    make_dir

    File.open("#{filename}.yml", 'w') { YAML.dump(game) }
  rescue StandardError
    File.open("#{standard_filename}.yml", 'w') { YAML.dump(game) }
  end

  def make_dir
    Dir.mkdir('saved') unless Dir.exist?('saved')
  end

  def standard_filename
    "saved/#{Time.now.to_i}"
  end
end
