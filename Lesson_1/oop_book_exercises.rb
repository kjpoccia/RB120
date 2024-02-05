=begin
Objects are most things in Ruby (but not methods, blocks, and variables.) An example of creating an object:

class Person
end

kj_poccia = Person.new

A module is a collection of behaviors that are available to classes via mixins.

module Actions
  def yell(words)
    puts words
  end
end

class Person
  include Actions
end