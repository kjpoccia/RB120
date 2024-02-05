require "pry-byebug"

module Displayable

  def display_welcome
    puts "Welcome to the Guessing Game!"
  end

  def display_remaining(guesses)
    puts "You have #{guesses} guesses remaining."
  end

  def display_goodbye
    puts "Thanks for playing! Goodbye!"
  end

  def display_ask_for_guess
    puts "Enter a number between #{self.low} and #{self.high}:"
  end

  def display_invalid_guess
    puts "Invalid guess. Enter a number between #{self.low} and #{self.high}:"
  end

  def display_too_low
    puts "Your guess is too low."
  end

  def display_too_high
    puts "Your guess is too high."
  end

  def display_correct_guess
    puts "That's the number!"
    puts ''
    puts "You won!"
  end

  def display_out_of_guesses
    puts "You ran out of guesses! You lost."
  end
end

class Player
  include Displayable

  attr_accessor :low, :high

  def initialize(low, high)
    @low = low
    @high = high
  end

  def guess
    answer = nil
    loop do
      answer = gets.chomp.to_i
      break if (low..high).to_a.include?(answer)
      display_invalid_guess
    end
    answer
  end
end

class GuessingGame
  include Displayable

  attr_accessor :guesses, :answer, :number, :low, :high

  def initialize(low, high)
    @number = rand(low..high)
    @guesses = nil
    @answer = ''
    @player = Player.new(low, high)
    @low = low
    @high = high
    @size_of_range = high - low
  end

  def play
    display_welcome
    determine_num_guesses
    main_loop
    display_goodbye
  end

  def main_loop
    loop do
      display_remaining(guesses)
      get_guess
      increment_guesses
      give_result
      break if guessed?
      break if out_of_guesses?
    end
  end

  def determine_num_guesses
    self.guesses = Math.log2(@size_of_range).to_i + 1
  end

  def get_guess
    display_ask_for_guess
    self.answer = @player.guess
  end

  def guessed?
    answer == number
  end

  def increment_guesses
    self.guesses -= 1
  end

  def give_result
    case
    when answer < number
      display_too_low
    when @answer > @number
      display_too_high
    when guessed?
      display_correct_guess
    end
  end

  def out_of_guesses?
    if @guesses == 0
      display_out_of_guesses
      return true
    end
    false
  end
end

game = GuessingGame.new(501, 1500)
game.play
