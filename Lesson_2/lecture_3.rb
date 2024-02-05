class Person
  attr_accessor :first_name, :last_name

  def initialize(full_name)
    parse_full_name(full_name)
  end

  def name
    (@first_name + ' ' + @last_name).strip
  end

  def name=(name)
    parse_full_name(name)
  end

  private

  def parse_full_name(name)
    first_and_last = name.split
    self.first_name = first_and_last.first
    self.last_name = (first_and_last.size > 1 ? first_and_last.last : '')
  end
end


bob = Person.new('Robert')
puts bob.name                  == 'Robert'
puts bob.first_name            # => 'Robert'
puts bob.last_name             # => ''
bob.last_name = 'Smith'
puts bob.name                  # => 'Robert Smith'

bob.name = "John Adams"
puts bob.first_name            # => 'John'
puts bob.last_name             # => 'Adams'