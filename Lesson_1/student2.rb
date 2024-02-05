class Student

  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_than?(other_student)
    puts "Well done!" if grade > other_student.grade
  end

  protected

  def grade
    @grade
  end
end

joe = Student.new("Joe", 95)
ben = Student.new("Ben", 90)

joe.better_grade_than?(ben)
