require "pry-byebug"

class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  attr_accessor :deck

  def initialize
    @deck = new_deck.shuffle!
  end

  def new_deck
    deck = []
    RANKS.each do |rank|
      SUITS.each do |suit|
        deck << Card.new(rank, suit)
      end
    end
    deck
  end

  def draw
    self.deck = Deck.new.deck if deck.empty?
    deck.pop
  end

  def <=>(other_deck)
    deck <=> other_deck.deck
  end

end

class Card
  include Comparable

  RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, "Jack", "Queen", "King", "Ace"]
  SUIT_RANKS = ["Diamonds", "Clubs", "Hearts", "Spades"]

  attr_reader :rank, :suit, :value, :suit_value

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
    @value = RANKS.index(rank)
    @suit_value = SUIT_RANKS.index(suit)
  end

  def <=>(other_card)
    if suit_value == other_card.suit_value
      self.value <=> other_card.value
    else
      suit_value <=> other_card.suit_value
    end
  end

  def to_s
    "#{rank} of #{suit}"
  end
end

deck = Deck.new
drawn = []
52.times { drawn << deck.draw }
puts drawn.count { |card| card.rank == 5 } #== 4
puts drawn.count { |card| card.suit == 'Hearts' } #== 13

drawn2 = []
52.times { drawn2 << deck.draw }
puts drawn != drawn2 # Almost always.
