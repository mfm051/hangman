# frozen_string_literal: true

# Secret word used in Hangman
class SecretWord < String
  MIN_LENGTH = 5
  MAX_LENGTH = 12

  def initialize
    super(secret_word)
  end

  def letter_positions(letter)
    return nil unless include?(letter)

    chars.each_index.select { |i| self[i] == letter }
  end

  private

  def secret_word
    dictionary = File.open('google-10000-english-no-swears.txt', 'r')
    valid_words = dictionary.readlines(chomp: true).select { |word| word.length.between?(MIN_LENGTH, MAX_LENGTH) }

    valid_words[Random.rand(valid_words.length - 1)]
  end
end
