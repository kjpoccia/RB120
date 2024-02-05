require "pry-byebug"

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                  [[1, 5, 9], [3, 5, 7]]

  def initialize
    @squares = {}
    reset
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  def []=(key, marker)
    @squares[key].marker = marker
  end

  def empty_square_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    empty_square_keys.empty?
  end

  def winner?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def best_move(opp_mark, my_mark)
    offense(my_mark) || defense(opp_mark) ||
      mid_if_empty || empty_square_keys.sample
  end

  def defense(opp_mark)
    WINNING_LINES.each do |line|
      markers = @squares.values_at(*line).map(&:marker)
      if markers.count(opp_mark) == 2 &&
         line.intersection(empty_square_keys).size == 1
        return line.intersection(empty_square_keys)[0]
      end
    end
    nil
  end

  def offense(my_mark)
    WINNING_LINES.each do |line|
      markers = @squares.values_at(*line).map(&:marker)
      if markers.count(my_mark) == 2 &&
         line.intersection(empty_square_keys).size == 1
        return line.intersection(empty_square_keys)[0]
      end
    end
    nil
  end

  def mid_if_empty
    return 5 if empty_square_keys.include?(5)
    nil
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def display
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).map(&:marker)
    return false if markers.size != 3
    markers.uniq.size == 1
  end
end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    !unmarked?
  end
end

Player = Struct.new('Player', :marker, :name)

class TTTGame
  COMPUTER_MARKER = "O"
  TOTAL_WINS = 3

  attr_reader :board, :human, :computer
  attr_accessor :player_mark

  def initialize
    @board = Board.new
    @human = Player.new
    @computer = Player.new(COMPUTER_MARKER)
    @current_marker = ""
    @player_wins = 0
    @computer_wins = 0
  end

  def play
    clear
    display_welcome_message
    main_game
    display_goodbye_message
  end

  private

  def player_move
    loop do
      current_player_moves
      break if board.winner? || board.full?
      clear_screen_and_display_board if human_turn?
    end
  end

  def single_game
    display_board
    player_move
    display_result
  end

  def total_winner?
    @player_wins == TOTAL_WINS || @computer_wins == TOTAL_WINS
  end

  def first_to_total_wins
    loop do
      single_game
      update_score
      display_score
      reset
      break if total_winner?
    end
  end

  def main_game
    loop do
      get_names
      choose_marker
      first_to_total_wins
      break unless play_again?
      hard_reset
      display_play_again_message
    end
  end

  def clear
    system "clear"
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe, #{human.name}! Tic tac tootles"
  end

  def get_names
    loop do
      puts "What's your name? "
      human.name = gets.chomp
      break if human.name
      puts "Sorry, please enter a valid name"
    end
    puts "Great! Hi, #{human.name}."
    puts "You'll be playing against #{comp_name}"
  end

  def comp_name
    computer.name = ["Frank", "Janine", "Kelly", "Justin"].sample
  end

  def display_board
    puts "You're a #{human.marker}. #{computer.name} is a #{COMPUTER_MARKER}."
    board.display
    puts ""
  end

  def display_choices(choices, delim=", ", word="or ")
    length = choices.length
    if length == 1
      choices[0].to_s
    elsif length == 2
      "#{choices[0]} #{word} #{choices[1]}"
    else
      "#{choices[0..length - 2].join(delim)}#{delim}#{word}#{choices.last}"
    end
  end

  def choose_marker
    puts "What marker would you like to use, #{human.name}?"
    human.marker = gets.chomp
    @current_marker = human.marker
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def human_player_moves
    puts "Choose a square (#{display_choices(board.empty_square_keys)}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.empty_square_keys.include?(square)
      puts "Sorry, please choose a valid square"
    end

    board[square] = human.marker
  end

  def computer_player_moves
    board[board.best_move(human.marker, COMPUTER_MARKER)] = computer.marker
  end

  def human_turn?
    @current_marker == human.marker
  end

  def current_player_moves
    if human_turn?
      human_player_moves
      @current_marker = COMPUTER_MARKER
    else
      computer_player_moves
      @current_marker = human.marker
    end
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      puts "You won!"
    when computer.marker
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def update_score
    puts "I'm updating the score..."
    sleep(2)
    case board.winning_marker
    when human.marker
      @player_wins += 1
    when computer.marker
      @computer_wins += 1
    end
  end

  def display_score
    puts "Score:"
    puts "You: #{@player_wins}, #{computer.name}: #{@computer_wins}"
    sleep(2)
    puts "You won the whole thing!" if @player_wins == TOTAL_WINS
    puts "#{computer.name} won the whole thing!" if @computer_wins == TOTAL_WINS
    sleep(2)
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must by y or n"
    end
    answer == "y"
  end

  def reset
    board.reset
    @current_marker = human.marker
    clear
  end

  def hard_reset
    reset
    @player_wins = 0
    @computer_wins = 0
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end
end

game = TTTGame.new
game.play
