Design a Sports Team (Author Unknown...thank you!)

- Include 4 players (attacker, midfielder, defender, goalkeeper)
- All the players’ jersey is blue, except the goalkeeper, his jersey is white with blue stripes
- All players can run and shoot the ball.
- Attacker should be able to lob the ball
- Midfielder should be able to pass the ball
- Defender should be able to block the ball
- The referee has a whistle. He wears black and is able to run and whistle.

Nouns: player, attacker, midfield, defender, goalkeeper, referee, jersey
Verbs: run, shoot, lob, pass, block, whistle

module Runnable
  def run
  end
end

class Player
  include Runnable

  def initialize
    @jersey = "blue"
  end

  def shoot
  end
end

class Attacker < Player
  def lob
  end
end

class Midfielder < Player
  def pass
  end
end

class Defender < Player
  def block
  end
end

class GoalKeeper < Player
  def initialize
    @jersey = "white with blue stripes"
  end
end

class Referee
  include Runnable

  def initialize
    @jersey = "black"
  end

  def whistle
  end
end
