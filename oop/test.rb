class Car
  def self.description
    puts "Hello dude"
  end

  def description
    puts "I am a car"
  end
end

module SuperDude
  def say
    puts self.phrase
  end

  def set_phrase(phrase = "HOHOHO")
    self.phrase = phrase
  end

  protected
  attr_accessor :phrase
end

module Debugger
  def debug(message)
    puts "ALARM"
    puts message
  end
end

class Dude
  @@dudes = 0
  include SuperDude
  extend Debugger

  def initialize
    @description = "I am a dude"
    @@description = "Hi dude"
    @@dudes += 1
  end

  class << self
    def dudes
      puts "Dudes population is #{@@dudes} now"
    end

    def description
      puts @@description
    end
  end

  debug("Start")

  def description
    puts @description
  end

  def dudes
    self.class.dudes
  end

  debug "Finish"
end

module Ns1
  class Dude
    def initialize
      puts "Call me Ns1::Dude.new"
    end
  end
end

