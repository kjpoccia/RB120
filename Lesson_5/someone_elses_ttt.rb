module Displayable
  def clear
    system 'clear'
  end

  def welcome_message
    puts "Welcome to Tic Tac Toe!", ''
  end

  def player_names_message(human_name, computer_name)
    puts "Hello, #{human_name}!"
    puts "You will be playing against #{computer_name}."
  end

  def whos_on_first_message
    puts "Who goes first? You or #{computer.name}?"
    puts "Turn order rotates between games.", ''
    puts "Enter '1' to make the first move or '2' to go second."
    puts "Enter '3' if you would like #{computer.name} to choose."
  end

  def goodbye_message
    puts "Thanks for playing Tic Tac Toe, #{human.name}!"
  end

  def mark_info
    puts ''
    puts "#{human.name} is #{human.marker}."
    puts "#{computer.name} is #{computer.marker}."
    puts ''
  end

  def match_info
    puts "First to win 5 games wins the match!"
    puts ''
    puts "Difficulty is set to: #{difficulty}"
    puts ''
    puts "#{human.name}'s score: #{human.score}"
    puts "#{computer.name}'s score: #{computer.score}"
    puts ''
  end

  def game_reset_message
    puts ''
    puts "Let's play again!"
    puts "Press 'enter' to continue."
    gets
  end

  def display_board
    match_info
    board.draw
    mark_info
  end

  def game_result_message
    clear_screen_and_display_board
    case board.winning_marker
    when human.marker
      puts "#{human.name} won the game!"
    when computer.marker
      puts "#{computer.name} won the game!"
    else
      puts "Tie game. No score."
    end
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def joinor(arr, separator= ', ', conjunction= 'or')
    return arr.last if arr.size == 1
    arr2 = arr - [arr.last]
    arr2.join(separator) + " #{conjunction} #{arr.last}"
  end

  def match_result_message
    puts ''
    puts "#{match_winner_name} won the match!"
  end
end

module Choosable
  FIRST  = 'first'
  SECOND = 'second'
  CHOICES = [ONE = '1', TWO = '2', THREE = '3']
  DIFFICULTIES = [EASY   = '  :-/  ...meh',
                  MEDIUM = '  ;-|  ...hmmm',
                  HARD   = '  >%-{}  ...@#$^!']

  def assign_first_to_move(turn)
    case turn
    when ONE
      self.order_choice = FIRST
    when TWO
      self.order_choice = SECOND
    when THREE
      self.order_choice = [FIRST, SECOND].sample
      puts "OK, you will go #{order_choice}."
    end
  end

  def choose_first_to_move
    turn = nil
    loop do
      whos_on_first_message
      turn = gets.chomp
      break if CHOICES.include?(turn)
      puts "You must enter #{ONE}, #{TWO}, or #{THREE}!", ''
    end
    assign_first_to_move(turn)
  end

  def assign_difficulty(level)
    self.difficulty = DIFFICULTIES[level.to_i - 1]
  end

  def choose_difficulty
    level = nil
    loop do
      puts "How difficult should #{computer.name} play against you?"
      puts "Enter #{ONE} for easy, #{TWO} for medium and #{THREE} for hard."
      level = gets.chomp
      break if CHOICES.include?(level)
      puts "You must enter #{ONE}, #{TWO}, or #{THREE}!"
    end
    assign_difficulty(level)
  end
end

module Winable
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def winning_marker
    WINNING_LINES.each do |line|
      return @squares[line[0]].marker if winning_line?(line)
    end
    nil
  end

  def easy_difficulty(plyr_mrk)
    WINNING_LINES.each do |line|
      if line_breakdown?(three_mark(line), plyr_mrk)
        return no_move_squares(line).sample.marker = plyr_mrk
      end
    end
    random_square(plyr_mrk)
  end

  def medium_difficulty(plyr_mrk, other_plyr_mrk)
    WINNING_LINES.each do |line|
      if line_breakdown?(three_mark(line), other_plyr_mrk)
        return no_move_squares(line)[0].marker = plyr_mrk
      end
    end
    random_square(plyr_mrk)
  end

  def hard_defense(plyr_mrk, other_plyr_mrk)
    WINNING_LINES.each do |line|
      if line_breakdown?(three_mark(line), other_plyr_mrk)
        return no_move_squares(line)[0].marker = plyr_mrk
      end
    end
    middle_square(plyr_mrk)
  end

  def hard_difficulty(plyr_mrk, other_plyr_mrk)
    WINNING_LINES.each do |line|
      if line_breakdown?(three_mark(line), plyr_mrk)
        return no_move_squares(line).sample.marker = plyr_mrk
      end
    end
    hard_defense(plyr_mrk, other_plyr_mrk)
  end
end

class Player
  include Choosable
  include Displayable

  MARKS = [X = 'X', O = 'O']
  COMPUTER_NAMES = ['ChatGPT', 'HAL 9000', 'Ava', 'The Borg', 'Watson']

  attr_accessor :marker, :name, :score

  def initialize
    @score = 0
  end

  def assign_players_names(computer)
    loop do
      puts "Enter your playing name:"
      self.name = gets.chomp
      break if name.strip != ''
      puts "You must enter at least a single character name!"
    end
    computer.name = COMPUTER_NAMES.sample
    puts ''
    player_names_message(name, computer.name)
  end

  def assign_players_marks(computer)
    loop do
      puts "Would you like to be 'X' or 'O'?"
      self.marker = gets.chomp.upcase
      break if MARKS.include?(marker)
      puts "You must enter 'X' or 'O'!"
    end
    computer_mark(computer)
  end

  def computer_mark(computer)
    case marker
    when X
      computer.marker = O
    when O
      computer.marker = X
    end
  end
end

class Board
  include Winable

  def initialize
    @squares = {}
    (1..9).each { |key| @squares[key] = Square.new }
  end

  def [](key)
    @squares[key].marker
  end

  def []=(key, marker)
    @squares[key].marker = marker
  end

  def no_move_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    no_move_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def three_mark(line)
    @squares.values_at(*line).map(&:marker)
  end

  def line_values(line)
    @squares.values_at(*line)
  end

  def winning_line?(line)
    three_mark(line).uniq.size == 1 && !@squares[line[0]].unmarked?
  end

  def line_breakdown?(line, plyr_mrk)
    line.count(plyr_mrk) == 2 && line.count(Square::NO_MOVE) == 1
  end

  def no_move_squares(line)
    line_values(line).select do |idx|
      idx.marker == Square::NO_MOVE
    end
  end

  def random_square(plyr_mrk)
    self[no_move_keys.sample] = plyr_mrk
  end

  def middle_square(plyr_mrk)
    return self[5] = plyr_mrk if @squares[5].unmarked?
    random_square(plyr_mrk)
  end

  def square_id(num)
    no_move_keys.size == 9 ? num : ' '
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def draw
    puts "             |     |"
    puts "          #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "         #{square_id(1)}   | #{square_id(2)}   | #{square_id(3)}"
    puts "        -----+-----+-----"
    puts "             |     |"
    puts "          #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "         #{square_id(4)}   | #{square_id(5)}   | #{square_id(6)}"
    puts "        -----+-----+-----"
    puts "             |     |"
    puts "          #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "         #{square_id(7)}   | #{square_id(8)}   | #{square_id(9)}"
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def reset_squares
    (1..9).each { |key| @squares[key] = Square.new }
  end
end

class Square
  NO_MOVE = ' '
  attr_accessor :marker

  def initialize(marker=NO_MOVE)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == NO_MOVE
  end
end

class TTTMatch < Player
  include Displayable
  include Choosable

  MATCH_WIN = 5

  attr_reader :board
  attr_accessor :order_choice, :difficulty, :human, :computer

  private

  def generate_board_and_players
    @board = Board.new
    @human = Player.new
    @computer = Player.new
    human.assign_players_names(computer)
    puts ''
    human.assign_players_marks(computer)
  end

  def match_parameter_choices
    generate_board_and_players
    puts ''
    choose_first_to_move
    puts ''
    choose_difficulty
    clear
  end

  def human_moves
    square_choice = nil
    open_squares = board.no_move_keys.map(&:to_s)
    puts "Please select an open square from:"
    puts joinor(open_squares)
    loop do
      square_choice = gets.chomp
      break if open_squares.include?(square_choice)
      puts "Sorry, that's not a valid choice."
    end
    board[square_choice.to_i] = human.marker
  end

  def computer_moves
    case difficulty
    when EASY
      board.easy_difficulty(computer.marker)
    when MEDIUM
      board.medium_difficulty(computer.marker, human.marker)
    when HARD
      board.hard_difficulty(computer.marker, human.marker)
    end
  end

  def first_player_turn?
    return true if board.no_move_keys.size.odd?
    false
  end

  def human_turn?
    (first_player_turn? && order_choice == FIRST) ||
      (!first_player_turn? && order_choice == SECOND)
  end

  def current_player_moves
    return human_moves if human_turn?
    computer_moves
  end

  def turn_for_next_game
    return self.order_choice = SECOND if order_choice == FIRST
    self.order_choice = FIRST
  end

  def game_reset
    board.reset_squares
    turn_for_next_game
    clear
  end

  def match_again?
    answer = nil
    loop do
      puts "Enter 'y' to play another match or 'n' to quit:"
      answer = gets.chomp.downcase
      break if answer == 'n' || answer == 'y'
    end
    answer == 'y'
  end

  def score_counter
    if board.winning_marker == human.marker
      human.score += 1
    elsif board.winning_marker == computer.marker
      computer.score += 1
    end
  end

  def match_winner_name
    if human.score == MATCH_WIN
      human.name
    elsif computer.score == MATCH_WIN
      computer.name
    end
  end

  def match_win?
    human.score == MATCH_WIN || computer.score == MATCH_WIN
  end

  def next_match_difficulty
    change = nil
    loop do
      puts "Would you like to change #{computer.name}'s game difficulty?"
      puts "Enter 'y' to change or 'n' to keep."
      change = gets.chomp.downcase
      break if change == 'y' || change == 'n'
      puts "Please enter 'y' or 'n'!"
    end
    choose_difficulty if change == 'y'
  end

  def match_reset
    human.score = 0
    computer.score = 0
    game_reset
  end

  public

  def player_moves_loop
    loop do
      current_player_moves
      score_counter
      clear_screen_and_display_board
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if first_player_turn?
    end
  end

  def game_loop
    loop do
      display_board
      player_moves_loop
      game_result_message
      break if match_win?
      game_reset_message
      game_reset
    end
  end

  def match_loop
    loop do
      game_loop
      match_result_message
      break unless match_again?
      next_match_difficulty
      match_reset
    end
  end

  def play
    clear
    welcome_message
    match_parameter_choices
    match_loop
    goodbye_message
  end
end

game = TTTMatch.new
game.play