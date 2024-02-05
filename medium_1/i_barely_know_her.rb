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

class PokerHand
  attr_accessor :hand, :deck

  def initialize(deck)
    @hand = []
    @deck = deck
    deal_hand
  end

  def deal_hand
    5.times { hand << deck.draw }
  end

  def print
    hand.each do |card|
      puts card
    end
  end

  def evaluate
    case
      # binding.pry
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  private

  def royal_flush?
    return false if suits.uniq.size != 1
    ranks.none? { |rank| (2..9).to_a.include?(rank) }
  end

  def straight_flush?
    return false if suits.uniq.size != 1
    sorted = hand.sort
    (sorted[4].value - sorted[0].value) < 5
  end

  def four_of_a_kind?
    ranks.any? { |rank| ranks.count(rank) == 4 }
  end

  def full_house?
    ranks.any? { |rank| ranks.count(rank) == 3 } &&
    ranks.uniq.size == 2
  end

  def flush?
    suits.uniq.size == 1
  end

  def straight?
    return false if ranks.uniq.size != 5
    sorted = hand.sort
    (sorted[4].value - sorted[0].value) < 5
  end

  def three_of_a_kind?
    ranks.any? { |rank| ranks.count(rank) == 3 }
  end

  def two_pair?
    temp = ranks.clone
    ranks.each do |rank|
      if ranks.count(rank) == 3 || ranks.count(rank) == 2
        temp.delete(rank)
        return true if temp.uniq.size == 1 || temp.empty?
      end
    end
    false
  end

  def pair?
    ranks.any? { |rank| ranks.count(rank) == 2 }
  end

  def suits
    hand.map(&:suit)
  end

  def ranks
    hand.map(&:rank)
  end
end

# hand = PokerHand.new(Deck.new)
# hand.print
# puts hand.evaluate


# Danger danger danger: monkey
# patching for testing purposes.
class Array
  alias_method :draw, :pop
end

# Test that we can identify each PokerHand type.
hand = PokerHand.new([
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts')
])
puts hand.evaluate == 'Royal flush'

hand = PokerHand.new([
  Card.new(8,       'Clubs'),
  Card.new(9,       'Clubs'),
  Card.new('Queen', 'Clubs'),
  Card.new(10,      'Clubs'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight flush'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Four of a kind'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Full house'

hand = PokerHand.new([
  Card.new(10, 'Hearts'),
  Card.new('Ace', 'Hearts'),
  Card.new(2, 'Hearts'),
  Card.new('King', 'Hearts'),
  Card.new(3, 'Hearts')
])
puts hand.evaluate == 'Flush'

hand = PokerHand.new([
  Card.new(8,      'Clubs'),
  Card.new(9,      'Diamonds'),
  Card.new(10,     'Clubs'),
  Card.new(7,      'Hearts'),
  Card.new('Jack', 'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new('Queen', 'Clubs'),
  Card.new('King',  'Diamonds'),
  Card.new(10,      'Clubs'),
  Card.new('Ace',   'Hearts'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
])
puts hand.evaluate == 'Three of a kind'

hand = PokerHand.new([
  Card.new(9, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(8, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Two pair'

hand = PokerHand.new([
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Pair'

hand = PokerHand.new([
  Card.new(2,      'Hearts'),
  Card.new('King', 'Clubs'),
  Card.new(5,      'Diamonds'),
  Card.new(9,      'Spades'),
  Card.new(3,      'Diamonds')
])
puts hand.evaluate == 'High card'
