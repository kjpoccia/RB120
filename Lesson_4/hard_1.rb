module Tires
  attr_accessor :tires

  def tire_pressure(tire_index)
    @tires[tire_index]
  end

  def inflate_tire(tire_index, pressure)
    @tires[tire_index] = pressure
  end
end

class Vehicle
  attr_accessor :speed, :heading

  def initialize(km_traveled_per_liter, liters_of_fuel_capacity)
    @fuel_efficiency = km_traveled_per_liter
    @fuel_capacity = liters_of_fuel_capacity
  end

  def range
    @fuel_capacity * @fuel_efficiency
  end
end

class Auto < Vehicle
  include Tires

  def initialize
    @tires = [30,30,32,32]
    # 4 tires are various tire pressures
    super(50, 25.0)
  end
end

class Motorcycle < Vehicle
  include Tires

  def initialize
    @tires = [80, 80]
    # 2 tires are various tire pressures
    super(80, 8.0)
  end
end

class Catamaran < Vehicle
  attr_reader :propeller_count, :hull_count

  def initialize(num_propellers, num_hulls, km_traveled_per_liter, liters_of_fuel_capacity)
    @propeller_count = num_propellers
    @hull_count = num_hulls
    super(km_traveled_per_liter, liters_of_fuel_capacity)
  end

  def range
    super + 10
  end
end

class Motorboat < Vehicle

  def initialize(km_traveled_per_liter, liters_of_fuel_capacity)
    @propeller_count = 1
    @hull_count = 1
    super(km_traveled_per_liter, liters_of_fuel_capacity)
  end

  def range
    super + 10
  end
end



p Motorcycle.new.inflate_tire(0, 80)
p Auto.new.tires
p Auto.new.range
p Catamaran.new(4, 2, 70, 12).hull_count
