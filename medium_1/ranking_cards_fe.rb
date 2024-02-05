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



cards = [Card.new(2, 'Hearts'),
        Card.new(2, 'Diamonds'),
         Card.new(10, 'Diamonds'),
         Card.new('Ace', 'Clubs')]
puts cards
puts cards.min #== Card.new(2, 'Diamonds')
puts cards.max #== Card.new('2', 'Hearts')
=begin
cards = [Card.new(5, 'Hearts')]
puts cards.min == Card.new(5, 'Hearts')
puts cards.max == Card.new(5, 'Hearts')

cards = [Card.new(4, 'Hearts'),
         Card.new(4, 'Diamonds'),
         Card.new(10, 'Clubs')]
puts cards.min.rank == 4
puts cards.max == Card.new(10, 'Clubs')

cards = [Card.new(7, 'Diamonds'),
         Card.new('Jack', 'Diamonds'),
         Card.new('Jack', 'Spades')]
puts cards.min == Card.new(7, 'Diamonds')
puts cards.max.rank == 'Jack'

cards = [Card.new(8, 'Diamonds'),
         Card.new(8, 'Clubs'),
         Card.new(8, 'Spades')]
puts cards.min.rank == 8
puts cards.max.rank == 8
=end