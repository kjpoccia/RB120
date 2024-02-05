require "pry-byebug"

class GuessingGame
  NUMBER_OF_GUESSES = 7

  attr_accessor :guesses

  def initialize
    @number = rand(1..100)
    @guesses = NUMBER_OF_GUESSES
    @answer = ''
  end

  def play
    loop do
      give_number_of_guesses
      ask_for_guess
      increment_guesses
      give_result
      break if guessed?
      break if out_of_guesses?
    end
    goodbye
  end

  def goodbye
    puts "Thanks for playing! Goodbye!"
  end

  def give_number_of_guesses
    puts "You have #{guesses} guesses remaining."
  end

  def ask_for_guess
    puts "Enter a number between 1 and 100:"
    loop do
      @answer = gets.chomp.to_i
      break if (1..100).to_a.include?(@answer)
      puts "Invalid guess. Enter a number between 1 and 100:"
    end
  end

  def guessed?
    @answer == @number
  end

  def increment_guesses
    @guesses -= 1
  end

  def give_result
    case
    when @answer < @number
      puts "Your guess is too low."
    when @answer > @number
      puts "Your guess is too high."
    when guessed?
      puts "That's the number!"
      puts ""
      puts "You won!"
    end
  end

  def out_of_guesses?
    if @guesses == 0
      puts "Out of guesses. You lost!"
      return true
    end
    false
  end
end

game = GuessingGame.new
game.play

# You have 7 guesses remaining.
# Enter a number between 1 and 100: 104
# Invalid guess. Enter a number between 1 and 100: 50
# Your guess is too low.

# You have 6 guesses remaining.
# Enter a number between 1 and 100: 75
# Your guess is too low.

# You have 5 guesses remaining.
# Enter a number between 1 and 100: 85
# Your guess is too high.

# You have 4 guesses remaining.
# Enter a number between 1 and 100: 0
# Invalid guess. Enter a number between 1 and 100: 80

# You have 3 guesses remaining.
# Enter a number between 1 and 100: 81
# That's the number!

# You won!

# game.play

# You have 7 guesses remaining.
# Enter a number between 1 and 100: 50
# Your guess is too high.

# You have 6 guesses remaining.
# Enter a number between 1 and 100: 25
# Your guess is too low.

# You have 5 guesses remaining.
# Enter a number between 1 and 100: 37
# Your guess is too high.

# You have 4 guesses remaining.
# Enter a number between 1 and 100: 31
# Your guess is too low.

# You have 3 guesses remaining.
# Enter a number between 1 and 100: 34
# Your guess is too high.

# You have 2 guesses remaining.
# Enter a number between 1 and 100: 32
# Your guess is too low.

# You have 1 guess remaining.
# Enter a number between 1 and 100: 32
# Your guess is too low.

# You have no more guesses. You lost!