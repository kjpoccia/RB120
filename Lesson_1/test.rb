class Student
  attr_accessor :grade

  def initialize(n, g)
    @name = n
    @grade = g
  end

  def better_grade_than?(this_student)
    self.grade = 93
    puts "Well Done!" if grade > this_student.grade
  end

end

joe = Student.new("Joe", 95)
bob = Student.new("Bob", 90)
joe.better_grade_than?(bob)
puts joe.grade
