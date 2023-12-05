# frozen_string_literal: true

# Saves and loads games
module GameSaver
  def save(game, filename)
    make_dir

    File.open(filename, 'w') { Marshal.dump(game) }
  rescue StandardError
    File.open(standard_filename, 'w') { Marshal.dump(game) }
  end

  def make_dir
    Dir.mkdir('saved') unless Dir.exist?('saved')
  end

  def standard_filename
    "saved/#{Time.now.to_i}"
  end
end
