class Person
  attr_reader :name

  def name=(n)
    @name = "Mr. #{n}"
  end
end

person1 = Person.new
person1.name = 'James'
puts person1.name