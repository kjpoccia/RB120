class Vehicle
  def self.gas_mileage(miles_driven, gallons_used)
    "#{miles_driven/gallons_used} miles per gallon"
  end

  def speed_up(num)
    @speed += num
    puts "You pushed the gas and accelerated #{num} mph."
  end

  def brake(num)
    @speed -= num
    puts "You pushed the gas and decelerated #{num} mph."
  end

  def turn_off
    @speed = 0
    puts "Let's park this bad boy!"
  end

  def spray_paint(color)
    self.color = color
    puts "You spray painted the car #{color}! Neat!"
  end

  @@number_of_vehicles = 0

  def initialize(y, c, m)
    @year = y
    @color = c
    @model = m
    @speed = 0
    @@number_of_vehicles += 1
  end

  def self.how_many_vehicles
    "There are #{@@number_of_vehicles} vehicles on the road."
  end

  def age
    "Your #{self.model} is #{years_old} years old"
  end

  private

  def years_old
    Time.now.year - self.year
  end

end

module Haulable
  def haul
    "I'm hauling!"
  end
end

class MyCar < Vehicle
  attr_accessor :year, :color, :model

  NUMBER_OF_PASSENGERS = 4

  def to_s
    "This car is a #{@color} #{@year} #{@model} and it is currently driving #{@speed} mph."
  end
end

class MyTruck < Vehicle
  attr_accessor :year, :color, :model

  NUMBER_OF_PASSENGERS = 2

  include Haulable

  def to_s
    "This truck is a #{@color} #{@year} #{@model} and it is currently driving #{@speed} mph."
  end
end


mini = MyCar.new(2015, "black", "Mini Countryman")
pickup = MyTruck.new(2019, "blue", "pickup")
puts Vehicle.how_many_vehicles
puts pickup.haul
puts Vehicle.ancestors
puts mini.age
