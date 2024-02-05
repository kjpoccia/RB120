#started with rps_design_2

class Move
  VALUES = ['rock', 'paper', 'scissors']

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def >(other_move)
    (rock? && other_move.scissors?) ||
      (paper? && other_move.rock?) ||
      (scissors? && other_move.paper?)
  end

  def <(other_move)
    (rock? && other_move.paper?) ||
      (paper? && other_move.scissors?) ||
      (scissors? && other_move.rock?)
  end

  def to_s
    @value
  end
end

class Player
  attr_accessor :move, :name

  def initialize
    set_name
  end
end

class Human < Player
  def set_name
    n = ""
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, or scissors:"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ["R2D2", "Hal", "Chappie", "Sunny", "Number 5"].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class RPSGame
  MAX_POINTS = 5

  attr_accessor :human, :computer, :winner, :human_points, :computer_points

  def initialize
    @human = Human.new
    @computer = Computer.new
    @human_points = 0
    @computer_points = 0
  end

  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors!"
    puts "You'll be playing against #{computer.name}."
    puts "You'll be playing to #{MAX_POINTS} points."
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors. Goodbye!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def winner
    if human.move > computer.move
      human
    elsif human.move < computer.move
      computer
    end
  end

  def display_winner
    if winner == human
      puts "#{human.name} won!"
    elsif winner == computer
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def reset_score
    self.human_points = 0
    self.computer_points = 0
  end

  def update_score
    if winner == human
      self.human_points += 1
    elsif winner == computer
      self.computer_points += 1
    end
  end

  def display_score
    puts "-----Score-----"
    puts "#{human.name}: #{human_points}"
    puts "#{computer.name}: #{computer_points}"
    puts "---------------"
  end

  def max_points_reached?
    human_points == MAX_POINTS ||
    computer_points == MAX_POINTS
  end

  def display_big_winner
    if human_points == MAX_POINTS
      puts "#{human.name} won the whole thing!"
    else
      puts "#{computer.name} won the whole thing!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include?(answer)
      puts "Invalid response."
    end

    return true if answer == 'y'
    false
  end

  def little_game
    loop do
      human.choose
      computer.choose
      display_moves
      winner
      display_winner
      update_score
      display_score
      break if max_points_reached?
    end
    display_big_winner
  end

  def play
    display_welcome_message
    loop do
      little_game
      break unless play_again?
      reset_score
    end
    display_goodbye_message
  end
end

RPSGame.new.play
