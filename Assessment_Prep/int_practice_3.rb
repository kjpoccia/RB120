class Human  # Problem received from Raul Romero
  attr_reader :name 
  
  def initialize(name)
    @name = name
  end

  def +(other)
    "#{name}#{other.name}"
  end
 
end

gilles = Human.new("gilles") 
anna = Human.new("anna") 

puts anna + gilles # should output annagilles 