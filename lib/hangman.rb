# frozen_string_literal: true

require_relative 'secret_word'

# Controls game
class Hangman
  MAX_STRIKES = 6

  def initialize
    @secret_word = SecretWord.new
    @strikes = 0
    @known_letters = Array.new(@secret_word.length, '_')
    @previous_guesses = []
    @current_guess = nil
  end

  def start_game
    until @strikes == MAX_STRIKES
      print_game_status

      new_guess
      update_game_status

      break if @known_letters.join == @secret_word
    end

    puts game_result
  end

  private

  def print_game_status
    puts "#{MAX_STRIKES - @strikes} tries left\n\n"

    puts "#{@known_letters.join(' ')}\n\n"

    puts "Previous guesses: #{@previous_guesses.join(', ')}"
  end

  def new_guess
    puts 'Choose a letter or try to guess the word'
    user_guess = gets.chomp.downcase

    guess(user_guess)
  rescue StandardError => e
    puts e.message
    retry
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

    "Game over. Correct word: #{@secret_word}"
  end
end

# Game

hangman = Hangman.new
hangman.start_game
