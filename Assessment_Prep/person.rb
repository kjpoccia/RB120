class Person
  def initialize(name)
    @name = name
  end

  def run(mph)
    puts "I'm running at #{mph} miles per hour!"
  end
end

class ShortPerson < Person
  def run(mph, size)
    super(mph)
    puts "I take #{size} steps!"
  end
end

class TallPerson < Person
  def run(mph)
    super(mph)
    puts "I take big steps!"
  end
end

jim = ShortPerson.new("Jim")
mike = TallPerson.new("Mike")
jim.run(60, "little")
mike.run(45)