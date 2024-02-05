class Vehicle
  attr_accessor :year, :color, :model

  def initialize(y, c, m)
    @year = y
    @color = c
    @model = m
    @speed = 0
  end

  def age
    "Your #{self.model} is #{years_old} years old"
  end

  private

  def years_old
    Time.now.year - self.year
  end

end



mini = Vehicle.new(2015, "black", "Mini Countryman")
pickup = Vehicle.new(2019, "blue", "pickup")
puts mini.age
