require "wordsoup/version"
require 'byebug'
module Wordsoup

  class Author

    attr_accessor :sentences, :word_hash, :first_words, :last_words

    def initialize(file)
      @sentences = make_sentence_array(file)
      @word_hash = Hash.new { |h, k| h[k] = [] }
      @first_words = []
      @last_words = []
      make_word_hash
    end

    def make_sentence_array(file)
      text = ""
      File.open(file).each do |line|
        text << line
      end
      text = text.gsub(/\n/, " ")
      text = text.gsub(/"/, "")
      sentences = text.split("  ")
    end


    def make_word_hash
      @sentences.each do |sentence|
        sentence_array = sentence.split(" ")
        sentence_array.each_with_index do |word, i|
          @first_words << word if i == 0
          @last_words << word if i == sentence_array.length - 1
          unless i == sentence_array.length - 1
            @word_hash[word] << sentence_array[i+1]
          end
        end
      end
    end

    def sentence
      sentence = [@first_words.sample.capitalize]
      word = ""
      until (sentence.length == 30)
        word = @word_hash[sentence.last].sample
        break if word.nil?
        word = fix_word(word)
        sentence << word
        break if ["!","?","."].include?(word[word.length-1])
      end
      sentence = sentence.join(" ")
      sentence[sentence.length-1] = "" if [",", ":", ";"].include?(sentence[sentence.length-1])
      unless ["!","?","."].include?(sentence[sentence.length-1])
        sentence << "?"
      end
      sentence
    end

    def paragraph
      paragraph = ""
      until paragraph.length > 250
        paragraph << " "
        paragraph << self.sentence
      end
      paragraph
    end

    def haiku
      haiku = ""
      haiku << line(5)
      haiku << "\n"
      haiku << line(7)
      haiku << line(5)
    end



    def line(syllables, prev_word = nil)

      line = []
      syllables_in_line = 0
      last_word_in_previous_line = prev_word

      until syllables_in_line == syllables

        if syllables_in_line == 0
          if last_word_in_previous_line.nil?
            first_word = "."
            while first_word.gsub!(/\W+/, '') == ""
              first_word = @first_words.sample.capitalize
              line << first_word
              first_word = first_word.gsub!(/\W+/, '')
            end

            puts "here it is: #{first_word}"
            syllables_in_line += Wordsoup::CMUDictionary.syllable_hash[first_word.upcase]
          end
        end

        if syllables_in_line > syllables
          line = starting_line
          syllables_in_line = 0
        else
          word_to_add = "."
          while first_word.gsub!(/\W+/, '') == ""
            word_to_add = get_next_word(line.last)
            line << word_to_add
            word_to_add = word_to_add.gsub!(/\W+/, '')
          end
          puts "here it is: #{word_to_add}"
          syllables_in_line += Wordsoup::CMUDictionary.syllable_hash[word_to_add.upcase]
        end
      end
      line.join(" ")

    end

    def get_next_word(prev_word)
      word = nil
      while word.nil? || word.length == 0
        word = @word_hash[prev_word].sample
      end
      word
    end

    def fix_word(word)
      word = word.downcase
      capitalized_words = ["i'll", "i", "god", "i."]
      if capitalized_words.include?(word)
        word = word.capitalize
      end
      word
    end



  end

  class Dictionary

    attr_accessor :syllable_hash

    def initialize(file)
      @syllable_hash = parse_cmu_dictionary(file)
    end

    def parse_cmu_dictionary(file)
      dictionary = {}
      File.open(file).each do |line|
        line = line.split(" ")
        dictionary[line.first] = syllable_count(line[1..-1])
      end
      dictionary
    end

    def syllable_count(arr)
      str = arr.join("")
      str = str.gsub(/[A-Z]/, "")
      str.length
    end

  end

  CMUDictionary = Dictionary.new(File.join( File.dirname(__FILE__), './cmudict.txt'))
  Shakespeare = Author.new( File.join( File.dirname(__FILE__), './hamlet.txt'))
  Hemingway = Author.new(File.join( File.dirname(__FILE__), './omats.txt'))
  Bible = Author.new(File.join( File.dirname(__FILE__), './bible.txt'))

end
