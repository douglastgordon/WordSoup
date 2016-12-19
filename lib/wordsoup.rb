require "wordsoup/version"
require 'byebug'
require 'demystify'

module Wordsoup

  SENTENCE_ENDING_PUNC = ["!","?","."]

  class Author

    attr_accessor :parsed_text

    def initialize(file)
      @parsed_text = Demystify::Text.new(file)
    end

    def sentence
      sentence = []
      sentence << @parsed_text.first_words.sample

      until sentence.length >= @parsed_text.average_sentence_length
        new_word = @parsed_text.forwards_probability_hash[sentence.last].sample
        new_word = sanitize_word(new_word)
        new_word = fix_capitalisation(new_word)
        break if new_word.nil?
        sentence << new_word
        break if SENTENCE_ENDING_PUNC.include?(new_word[-1])
      end

      sentence = sentence.join(" ")
      fix_ending(sentence)
    end

    def paragraph
      paragraph = ""
      until paragraph.length > 250
        paragraph << " "
        paragraph << self.sentence
      end
      paragraph[1..-1]
    end

    private

    def fix_capitalisation(word)
      sanitized_word = word.downcase.gsub(/[.,:;!?]/, "")
      unless Dictionary.words[word.downcase] >= 1
        return word
      else
        return word.downcase
      end
    end

    def sanitize_word(word)
      word.gsub(/[(){}\[\]""<>]/, "")
    end

    def fix_ending(sentence)
      if [",", ":", ";"].include?(sentence[-1])
        sentence[-1] = ""
      end
      unless SENTENCE_ENDING_PUNC.include?(sentence[-1])
        sentence += SENTENCE_ENDING_PUNC.sample
      end
      sentence
    end

    # def haiku
    #   haiku = ""
    #   haiku << line(5)
    #   haiku << "\n"
    #   haiku << line(7)
    #   haiku << line(5)
    # end



    # def line(syllables, prev_word = nil)
    #
    #   line = []
    #   syllables_in_line = 0
    #   last_word_in_previous_line = prev_word
    #
    #   until syllables_in_line == syllables
    #
    #     if syllables_in_line == 0
    #       if last_word_in_previous_line.nil?
    #         first_word = "."
    #         while first_word.gsub!(/\W+/, '') == ""
    #           first_word = @first_words.sample.capitalize
    #           line << first_word
    #           first_word = first_word.gsub!(/\W+/, '')
    #         end
    #
    #         puts "here it is: #{first_word}"
    #         syllables_in_line += Wordsoup::CMUDictionary.syllable_hash[first_word.upcase]
    #       end
    #     end
    #
    #     if syllables_in_line > syllables
    #       line = starting_line
    #       syllables_in_line = 0
    #     else
    #       word_to_add = "."
    #       while first_word.gsub!(/\W+/, '') == ""
    #         word_to_add = get_next_word(line.last)
    #         line << word_to_add
    #         word_to_add = word_to_add.gsub!(/\W+/, '')
    #       end
    #       puts "here it is: #{word_to_add}"
    #       syllables_in_line += Wordsoup::CMUDictionary.syllable_hash[word_to_add.upcase]
    #     end
    #   end
    #   line.join(" ")
    #
    # end

    # def get_next_word(prev_word)
    #   word = nil
    #   while word.nil? || word.length == 0
    #     word = @word_hash[prev_word].sample
    #   end
    #   word
    # end
    #
    # def fix_word(word)
    #   word = word.downcase
    #   capitalized_words = ["i'll", "i", "god", "i."]
    #   if capitalized_words.include?(word)
    #     word = word.capitalize
    #   end
    #   word
    # end



  end

  # class Dictionary
  #
  #   attr_accessor :syllable_hash
  #
  #   def initialize(file)
  #     @syllable_hash = parse_cmu_dictionary(file)
  #   end
  #
  #   def parse_cmu_dictionary(file)
  #     dictionary = {}
  #     File.open(file).each do |line|
  #       line = line.split(" ")
  #       dictionary[line.first] = syllable_count(line[1..-1])
  #     end
  #     dictionary
  #   end
  #
  #   def syllable_count(arr)
  #     str = arr.join("")
  #     str = str.gsub(/[A-Z]/, "")
  #     str.length
  #   end
  #
  # end

  class Dictionary

    attr_accessor :words

    def initialize(file)
      make_words(file)
    end

    private

    def make_words(file)
      @words = Hash.new(0)
      File.open(file).each do |word|
        @words[word.chomp] += 1
      end
    end

  end

  # CMUDictionary = Dictionary.new(File.join( File.dirname(__FILE__), './cmudict.txt'))
  Shakespeare = Author.new( File.join( File.dirname(__FILE__), './hamlet.txt'))
  Hemingway = Author.new(File.join( File.dirname(__FILE__), './omats.txt'))
  Bible = Author.new(File.join( File.dirname(__FILE__), './bible.txt'))
  Dictionary = Dictionary.new(File.join( File.dirname(__FILE__), './dictionary.txt'))


end
