class Vehicle
  attr_accessor :color, :model

  attr_reader :year

  @@number_of_vehicles = 0

  def self.gas_mileage(miles_driven, gas_used)
    miles_driven / gas_used
  end

  def initialize(y, c, m)
    @year = y
    @color = c
    @model = m
    @speed = 0
    @@number_of_vehicles += 1
  end

  def speed_up(num)
    @speed += num
    "You've sped up #{num} mph. Your speed is now #{@speed}!"
  end

  def slow_down(num)
    @speed -= num
    "You've slowed down #{num} mph. Your speed is now #{@speed}!"
  end

  def brake
    @speed = 0
    "You've stopped. Your speed is now #{@speed}!"
  end

  def spray_paint(color)
    self.color = color
    "You've spray painted your car #{color}!"
  end

  def self.how_many_vehicles
    puts "There are #{@@number_of_vehicles} vehicles"
  end

  def age
    "This #{model} is #{private_age} years old"
  end

  private

  def private_age
    Time.now.year - year
  end
end

module Haulable
  def haulable
    "I'm haulable!"
  end
end

class MyCar < Vehicle
  NUMBER_OF_PASSENGERS = 4

  def to_s
    "This car is a #{year} #{color} #{model}"
  end
end

class MyTruck < Vehicle
  NUMBER_OF_PASSENGERS = 2

  include Haulable

  def to_s
    "This truck is a #{year} #{color} #{model}"
  end
end

honda = MyCar.new(2003, "orange", "Element")
puts honda.speed_up(60)
puts honda.speed_up(20)
puts honda.slow_down(60)
puts honda.brake
puts honda.color
honda.color = "black"
puts honda.color
puts honda.year
puts honda.spray_paint("pink")
puts honda.color
puts MyCar.gas_mileage(200, 10)
puts honda
ford = MyTruck.new(2010, "blue", "F150")
Vehicle.how_many_vehicles
puts ford
puts ford.haulable
puts Vehicle.ancestors
puts MyCar.ancestors
puts MyTruck.ancestors
puts honda.age
puts ford.age
