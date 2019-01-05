
# Run $ bundle exec autotest to boot 'atotest framework'
# This will fire up the Autotest framework, which looks for various files to figure 
# out what kind of app you're testing and what test framework you're using. In our case,
# it will discover the file called .rspec, which contains RSpec options and indicates we're 
# using the RSpec testing framework. Autotest will therefore look for test files under spec/
# and the corresponding class files in lib/.
class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  attr_accessor :word, :guesses, :wrong_guesses
  
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  # Get a word from remote "random word" service.
  # ( You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word )
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end
  
  def guess(letter)
    raise ArgumentError if letter.class == NilClass || letter.empty? || letter =~ /\W/
    letter.downcase!
    if word.include?(letter)
      self.guesses.count(letter) < 1 ? @guesses += letter : false
    else
      self.wrong_guesses.count(letter) < 1 ? @wrong_guesses += letter : false 
    end
  end
  
  def word_with_guesses
    # interate over 'word', if word char in guesses print this char
    # else print '-'
    guess_str = ""
    word.each_char do |ch|
      guesses.include?(ch) ? guess_str << ch : guess_str << '-'
    end
    guess_str
  end
  
  def check_win_or_lose
    # if word_with_guesses not contain '-', then 'win'
    return :win if !word_with_guesses.include?('-')
    return :lose if wrong_guesses.length == 7
    return :play # if neither win nor lose
    
    
  end
end
