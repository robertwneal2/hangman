class Game
  DICTIONARY = File.open("dictionary.txt")
  ALPHABET = ("A".."Z").to_a

  def initialize
    @dictionary = DICTIONARY.readlines.map(&:chomp)
    @word = pick_rand_word
    @guesses_left = 6
    @guesses = []
    @board = '_'
  end

  def play
    until game_over?
      system("clear")
      fill_board
      display_guesses
      puts "Guesses left: #{@guesses_left}"
      get_guess
    end
    display_word
  end

  def display_word
    system("clear")
    fill_board
    display_guesses
    puts "Guesses left: #{@guesses_left}"
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
  end

  def game_over?
    return true if @guesses_left == 0
    return true if !@board.include?('_')
    false
  end

  def get_guess
    puts 'Type \'save\' or \'load\' or guess a letter:'
    loop_over = false
    until loop_over
      guess = gets.chomp.upcase
      if guess_check(guess)
        loop_over = true
      end
    end
    remove_guess(guess)
    @guesses << guess
  end

  def remove_guess(guess)
    if !@word.include?(guess)
      @guesses_left -= 1
    end
  end

  def guess_check(guess)
    if guess.length != 1 
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
    dictionary_length = @dictionary.length
    word = @dictionary[rand(dictionary_length)]
    word_length = word.length
    while word_length < 5 || word_length > 12 do 
      word = @dictionary[rand(dictionary_length)]
      word_length = word.length
    end
    return word.upcase.split('')
  end
end

g = Game.new
g.play