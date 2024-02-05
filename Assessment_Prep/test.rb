module Clawable
  @@number_of_claws = 1

  def puts_claws
    puts @@number_of_claws
  end
end

class Cat
  include Clawable

  attr_reader :name, :buddies

  def initialize(name)
    @name = name
    @buddies = ["spock", "kyle"]
    # @@number_of_claws = 0
  end

  def [](idx)
    buddies[idx]
  end

  def []=(idx, obj)
    buddies[idx] = obj
  end
end

eric = Cat.new("eric")
# puts eric[1]
# eric[2] = "duke"
# puts eric[2]
# puts eric.buddies
eric.puts_claws