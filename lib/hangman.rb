# frozen_string_literal: true

# Controls game
class Hangman
  attr_reader :secret_word

  def initialize
    @secret_word = pick_secret_word
    @strikes = 0
    @known_letters = Array.new(@secret_word.length, '_')
    @chosen_letters = []
  end

  private

  def pick_secret_word
    dictionary = File.open('google-10000-english-no-swears.txt', 'r')
    valid_words = dictionary.readlines.select { |word| word.length.between?(5, 12) }
    valid_words[Random.rand(valid_words.length - 1)]
  end
end
