# frozen_string_literal: true

# Controls game
class Hangman
  MAX_STRIKES = 6

  def initialize
    @secret_word = pick_secret_word
    @strikes = 0
    @known_letters = Array.new(@secret_word.length, '_')
    @previous_guesses = []
    @current_guess = nil
  end

  def start_game
    until @strikes == MAX_STRIKES
      print_game_status

      update_guess
      update_game_status

      break if @known_letters.join == @secret_word
    end

    puts game_result
  end

  private

  def pick_secret_word
    dictionary = File.open('google-10000-english-no-swears.txt', 'r')
    valid_words = dictionary.readlines(chomp: true).select { |word| word.length.between?(5, 12) }

    valid_words[Random.rand(valid_words.length - 1)]
  end

  def print_game_status
    puts "#{MAX_STRIKES - @strikes} tries left\n\n"

    puts "#{@known_letters.join(' ')}\n\n"

    puts "Previous guesses: #{@previous_guesses.join(', ')}"
  end

  def update_guess
    puts 'Choose a letter or try to guess the word'
    user_guess = gets.chomp.downcase

    new_guess(user_guess)
  rescue StandardError => e
    puts e.message
    retry
  end

  def new_guess(guess)
    raise StandardError, 'Invalid guess' unless guess.length == 1 || guess.length == @secret_word.length
    raise StandardError, 'Option already chosen' if @previous_guesses.include?(guess)

    @current_guess = guess
  end

  def update_game_status
    if @secret_word.include?(@current_guess)
      update_known_letters
    else
      @strikes += 1
    end

    @previous_guesses << @current_guess
  end

  def update_known_letters
    @current_guess.chars.each do |letter|
      letter_positions(letter).each { |i| @known_letters[i] = letter }
    end
  end

  def letter_positions(letter)
    @secret_word.chars.each_index.select { |i| @secret_word[i] == letter }
  end

  def game_result
    return 'You win' if @known_letters.join == @secret_word

    "Game over. Correct word: #{@secret_word}"
  end
end

# Game

hangman = Hangman.new
hangman.start_game
