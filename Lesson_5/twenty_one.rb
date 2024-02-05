require "pry-byebug"

module Totalable
  POINTS = { "an Ace" => 11, "a Jack" => 10, "a Queen" => 10, "a King" => 10, +
             "a 2" => 2, "a 3" => 3, "a 4" => 4, "a 5" => 5, "a 6" => 6, +
             "a 7" => 7, "an 8" => 8, "a 9" => 9 }
  attr_accessor :total

  def calculate_total
    self.total = 0
    cards.each { |card| self.total += POINTS[card] }
    correct_for_aces
    self.total
  end

  def correct_for_aces
    ace_count = cards.count("an Ace")
    loop do
      break if ace_count == 0 || @total < 22
      self.total -= 10
      ace_count -= 1
    end
  end

  def player?
    instance_of?(Player)
  end

  def display_cards
    puts "#{player? ? 'You were' : 'Dealer was'} dealt #{cards[-1]}."
    sleep(2)
  end

  def display_total
    puts "#{player? ? 'Your' : 'Dealer'} total is #{total}."
    sleep(2)
  end
end

class Player
  include Totalable

  attr_accessor :cards, :busted

  def initialize
    @cards = []
    @busted = false
  end

  def stay?
    puts "Would you like to hit or stay? h/s"
    answer = ''
    loop do
      answer = gets.chomp.downcase[0]
      break if %w(h s).include?(answer)
      puts "Sorry, invalid choice. Please enter h or s."
    end
    answer == "s"
  end

  def hit(dealt)
    self.cards += dealt
    calculate_total
    display_cards
    display_total
  end

  def busted?
    return unless total > 21
    self.busted = true
  end
end

class Dealer
  include Totalable

  attr_accessor :cards, :busted

  def initialize
    @cards = []
    @busted = false
  end

  def stay?
    return unless total > 16
    puts "Dealer will stay."
    true
  end

  def hit(dealt)
    self.cards += dealt
    calculate_total
    display_cards
    display_total
  end

  def busted?
    return unless total > 21
    self.busted = true
  end
end

class Deck
  CARDS = ["a 2", "a 3", "a 4", "a 5", "a 6", "a 7", "an 8", +
           "a 9", "an Ace", "a Jack", "a Queen", "a King"]

  attr_accessor :available_cards

  def initialize
    new_deck
  end

  def new_deck
    self.available_cards = {}
    CARDS.each do |card|
      available_cards[card] = 4
    end
  end

  def deal(num)
    dealt = available_cards.keys.sample(num)
    remove(dealt)
    dealt
  end

  def remove(dealt)
    dealt.each { |card| available_cards[card] -= 1 }
    available_cards.select! { |_, remain| remain > 0 }
  end
end

class Game
  PAUSE = 2
  WINS = 5

  attr_accessor :deck, :player, :dealer

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
    @player_wins = 0
    @dealer_wins = 0
  end

  def start
    clear
    display_welcome_message
    game_loop
    display_goodbye_message
  end

  def game_loop
    loop do
      best_to_five
      break unless play_again?
      hard_reset
      clear
    end
  end

  def best_to_five
    loop do
      reset
      display_score
      sleep(PAUSE)
      single_game
      break if total_wins
      clear
    end
    display_total_result
  end

  def single_game
    deal_initial_cards
    calculate_totals
    show_initial_cards
    player_turn
    dealer_turn unless player.busted
    show_result
    press_continue
  end

  def reset
    player.busted = false
    dealer.busted = false
  end

  def deal_initial_cards
    player.cards = deck.deal(2)
    dealer.cards = deck.deal(2)
  end

  def calculate_totals
    player.calculate_total
    dealer.calculate_total
  end

  def show_initial_cards
    puts "You were dealt #{player.cards[0]} and #{player.cards[1]}."
    puts "Dealer was dealt #{dealer.cards[0]}."
    player.display_total
  end

  def player_turn
    loop do
      break if player.busted? || player.stay?
      sleep(PAUSE)
      player.hit(deck.deal(1))
    end
  end

  def dealer_turn
    puts "Dealer's second card is #{dealer.cards[1]}."
    sleep(PAUSE)
    dealer.display_total
    loop do
      break if dealer.busted? || dealer.stay?
      dealer.hit(deck.deal(1))
    end
  end

  def winner
    if player.busted || ((dealer.total > player.total) && !dealer.busted)
      @dealer
    elsif player.total == dealer.total
      nil
    else
      @player
    end
  end

  def total_wins
    if winner == dealer
      @dealer_wins += 1
    elsif winner == player
      @player_wins += 1
    end
    @dealer_wins == WINS || @player_wins == WINS
  end

  def display_score
    puts "Score:"
    puts "You: #{@player_wins}, Dealer: #{@dealer_wins}."
    puts ""
  end

  def display_total_result
    clear
    display_score
    if @player_wins == WINS
      puts "You won the whole thing!"
    else
      puts "Dealer won the whole thing!"
    end
  end

  def show_result
    if player.busted
      puts "Aww you busted! Dealer wins"
    elsif dealer.busted
      puts "Dealer busted! You win!"
    elsif winner
      puts "#{winner.instance_of?(Player) ? 'You' : 'Dealer'} wins!"
    else
      puts "It's a tie!"
    end
  end

  def clear
    system 'clear'
  end

  def press_continue
    puts "Press 'enter' to continue"
    gets
  end

  def display_welcome_message
    puts "Welcome to Twenty One!"
    puts ""
    sleep(PAUSE)
    puts "In this game, you will play against The Dealer."
    sleep(PAUSE)
    puts "Whoever is closest to 21 points wins!"
    sleep(PAUSE)
    puts "We'll play to 5. Get ready..."
    sleep(PAUSE)
  end

  def display_goodbye_message
    puts "Thanks for playing Twenty-One! Goodbye!"
  end

  def play_again?
    puts "Would you like to play again? y/n"
    answer = ''
    loop do
      answer = gets.chomp.downcase[0]
      break if %w(y n).include?(answer)
      puts "Please enter a valid response."
    end
    answer == 'y'
  end

  def hard_reset
    @player_wins = 0
    @dealer_wins = 0
    @deck = Deck.new
    player.cards = []
    dealer.cards = []
  end
end

Game.new.start
