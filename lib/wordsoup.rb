require "wordsoup/version"

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


    def make_word_hash()
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

    def fix_word(word)
      word = word.downcase
      capitalized_words = ["i'll", "i", "god", "i."]
      if capitalized_words.include?(word)
        word = word.capitalize
      end
      word
    end

  end

  class Shakespeare < Author

    def initialize(file = File.join( File.dirname(__FILE__), './hamlet.txt'))
      super(file)
    end

  end

  class Hemingway < Author

    def initialize(file = File.join( File.dirname(__FILE__), './omats.txt'))
      super(file)
    end

  end

  class Bible < Author

    def initialize(file = File.join( File.dirname(__FILE__), './bible.txt'))
      super(file)
    end

  end
end
