class Animal
  def speak
    "Hello!"
  end
end

class GoodDog < Animal
  attr_accessor :name, :height, :weight
  @@number_of_dogs = 0

  def self.what_am_i
    "I am a GoodDog Class!"
  end

  def self.total_number_of_dogs
    @@number_of_dogs
  end

  def initialize(n, h, w)
    @@number_of_dogs += 1
    @name = n
    @height = h
    @weight = w
  end

  def speak
    super + " #{name} says Arf!"
  end

  def change_info(n, h, w)
    self.name = n
    self.height = h
    self.weight = w
  end

  def info
    "#{name} weighs #{weight} and is #{height} tall"
  end
end

class Cat < Animal
end

puts GoodDog.what_am_i

sparky = GoodDog.new("Sparky", "2 feet", "31 pounds")
puts sparky.speak

fido = GoodDog.new("Fido", "1 foot", "10 pounds")
puts fido.speak

puts GoodDog.total_number_of_dogs

paws = Cat.new
puts sparky.speak
puts paws.speak

