require File.join(File.join(File.dirname(__FILE__)), 'dsl')

class Machine
  extend DSL::ClassMethods
  include DSL::InstanceMethods

  def run
    @current_state = @initial_state
    @tape = " "
    @position = 0
    step
    puts @tape
  end

  def step
    @states[@current_state][@tape[@position]].call
  end

  def print(symbol)
    @tape[@position] = symbol
  end

  def move(direction)
    if direction == :right then
      @position += 1
    else
      @position -= 1
    end

    if @position < 0 then
      @tape.prepend " "
      @position = 0
    elsif @tape[@position].nil?
      @tape << " "
    end
  end

  def enter(state)
    @current_state = state
    step
  end

  def halt!

  end
end
