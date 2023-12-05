# frozen_string_literal: true

# Saves and loads games
module GameSaver
  def save(game)
    make_dir

    File.open(filename, 'w') { Marshal.dump(game) }
  end

  def filename
    puts 'Choose a name to file'
    chosen_filename = gets.chomp

    return "saved/#{chosen_filename}" unless chosen_filename.empty?

    "saved/#{Time.now.to_i}"
  end

  def make_dir
    Dir.mkdir('saved') unless Dir.exist?('saved')
  end
end
