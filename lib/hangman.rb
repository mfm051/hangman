# frozen_string_literal: true

require_relative 'secret_word'
require_relative 'game_saver'

# Controls game
class Hangman
  include GameSaver

  MAX_STRIKES = 6

  def initialize
    @secret_word = SecretWord.new
    @strikes = 0
    @known_letters = Array.new(@secret_word.length, '_')
    @previous_guesses = []
    @current_guess = nil
    @saved = false
  end

  def self.new_game
    puts 'Load previous game? [y/n]'
    user_choice = gets.chomp.downcase

    return load_game if user_choice == 'y'

    Hangman.new.start_game
  end

  def self.load_game
    puts 'Enter filename'
    filename = gets.chomp

    begin
      saved_game = Hangman.new.load(filename)
    rescue StandardError => e
      puts e.message
      retry
    end

    File.delete(".saved/#{filename}")
    saved_game.start_game
  end

  def start_game
    puts "--Hangman--\n\nEnter .save anytime to save current game\n\n"
    sleep 1

    until end_of_game?
      print_game_status

      user_input

      update_game_status
    end

    puts game_result
  end

  private

  def print_game_status
    puts "#{MAX_STRIKES - @strikes} tries left\n\n"

    puts "#{@known_letters.join(' ')}\n\n"

    puts "Previous guesses: #{@previous_guesses.join(', ')}\n\n"
  end

  def user_input
    puts 'Choose a letter or try to guess the word'
    user_input = gets.chomp.downcase

    return save_game if user_input == '.save'

    guess(user_input)
  rescue StandardError => e
    puts e.message
    retry
  end

  def save_game
    puts 'Choose a filename'
    filename = gets.chomp

    save(self, filename)
    @saved = true
  end

  def guess(guess)
    raise StandardError, 'Invalid guess' unless guess.length == 1 || guess.length == @secret_word.length
    raise StandardError, 'Option already chosen' if @previous_guesses.include?(guess)

    @current_guess = guess
  end

  def update_game_status
    @previous_guesses << @current_guess

    return @strikes += 1 unless @secret_word.include?(@current_guess)

    update_known_letters
  end

  def update_known_letters
    @current_guess.chars.each do |letter|
      @secret_word.letter_positions(letter).each { |i| @known_letters[i] = letter }
    end
  end

  def game_result
    return 'You win' if @known_letters.join == @secret_word
    return 'Game saved successfully' if @saved == true

    "Game over. Correct word: #{@secret_word}"
  end

  def end_of_game?
    @strikes == MAX_STRIKES || @known_letters.join == @secret_word || @saved
  end
end
