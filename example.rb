class Violin

  attr_reader :strings

  def initialize
    puts "creating a violin"
    @strings = []
    @strings << ::String.new("E")
    @strings << ::String.new("A")
    @strings << ::String.new("D")
    @strings << ::String.new("G")
  end

  def to_s
    @strings.inspect
  end

  class String
    def initialize(note)
      @note = note
    end

    def to_s
      "playing the note: #{@note.inspect}"
    end
  end

end

strad = Violin.new
puts strad
strad.strings.each {|string| puts string.class}
