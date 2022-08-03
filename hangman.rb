require 'yaml'
require 'pry-byebug'

class Game
  DICTIONARY = File.open("dictionary.txt").readlines.map(&:chomp)
  ALPHABET = ("A".."Z").to_a

  def initialize
    @word = pick_rand_word
    @guesses_left = 6
    @guesses = []
    @board = '_'
    @save = false
  end

  def play
    system("clear")
    until game_over?
      fill_board
      display_guesses
      get_guess
      system("clear")
    end
    if @save == true
      puts 'Game saved!'
    else
      display_word
    end
  end

  def display_word
    system("clear")
    fill_board
    display_guesses
    if @guesses_left == 0
      puts 'You lose!'
    else
      puts 'You win!'
    end
    puts "Word: #{@word.join('')}"
  end

  def display_guesses
    guesses = ''
    @guesses.each do |char|
      guesses += "#{char} "
    end
    puts "Guesses: #{guesses}"
    puts "Guesses left: #{@guesses_left}"
  end

  def game_over?
    return true if @guesses_left == 0
    return true if !@board.include?('_')
    return true if @save == true
    false
  end

  def get_guess
    puts 'Type \'save\' or guess a letter:'
    loop_over = false
    until loop_over
      guess = gets.chomp.upcase
      if guess_check(guess)
        loop_over = true
      end
    end
    if @save == false
      remove_guess(guess)
      @guesses << guess
      fill_board
    end
  end

  def remove_guess(guess)
    if !@word.include?(guess)
      @guesses_left -= 1
    end
  end

  def guess_check(guess)
    if  guess == 'SAVE'
      save_game
      @save = true
      return true
    elsif guess.length != 1 
      puts 'Guess must be only one letter, try again!'
      return false
    elsif @guesses.include?(guess)
      puts 'Letter already guessed, try again!'
      return false
    elsif ALPHABET.include?(guess) 
      return true
    else
      puts 'Invalid guess, try again!'
      return false
    end
  end

  def fill_board
    board = ''
    @word.each do |char|
      @guesses.include?(char) ? board += "#{char} " : board += "_ "
    end
    @board = board
    puts board
  end

  def display_dictionary
    p @dictionary
  end

  def pick_rand_word
    dictionary_length = DICTIONARY.length
    word = DICTIONARY[rand(dictionary_length)]
    word_length = word.length
    while word_length < 5 || word_length > 12 do 
      word = DICTIONARY[rand(dictionary_length)]
      word_length = word.length
    end
    return word.upcase.split('')
  end

  def save_game
    puts 'Enter file save name:'
    file_name = gets.chomp
    File.open("saves/#{file_name}.yml", "w") { |file| file.write(self.to_yaml) }
  end
end

system("clear")
puts "Load game? Enter Y/N"
load_input = gets.chomp.upcase
if load_input == 'Y'
  loop_done = false
  puts 'Enter file name or \'new\' to start a new game:'
  while loop_done == false do
    file_name = gets.chomp
    file_path = "saves/#{file_name}.yml"
    if file_name.upcase == 'NEW'
      game = Game.new
      loop_done = true
    elsif File.exist?(file_path)
      game = YAML.load(File.read(file_path), permitted_classes: [Game])
      loop_done = true
    else
      puts 'File name does not exist, try again:'
    end
  end
else
  game = Game.new
end
game.play