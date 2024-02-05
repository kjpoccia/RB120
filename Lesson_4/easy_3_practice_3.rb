class AngryCat
  def initialize(type)
    @type = type
  end

  def to_s
    "I am a #{@type} cat"
  end

  def hiss
    puts "Hisssss!!!"
  end
end

little_cat = AngryCat.new("tabby")
puts little_cat
