module DSL
  module ClassMethods
    def defined_as(&block)
      m = new
      m.instance_eval(&block)
      return m
    end
  end

  module InstanceMethods
    def in_state(state, &block)
      @state_collector = Hash.new
      instance_eval &block
      @states ||= Hash.new
      @states[state] = @state_collector
      @initial_state ||= state
    end

    def on(symbol, &block)
      @state_collector[symbol] = block
    end
  end
end

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

Machine.defined_as do
  in_state :A do
    on " " do
      print "0"
      move :right
      enter :B
    end
  end

  in_state :B do
    on " " do
      move :right
      enter :C
    end
  end

  in_state :C do
    on " " do
      print "1"
      move :right
      enter :D
    end
  end

  in_state :D do
    on " " do
      move :right
 #     enter :A
    end
  end
end.run
