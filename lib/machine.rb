require 'tape.rb'

class Machine
  class << self
    def defined_as(name = :turing, &block)
      @@instances ||= Hash.new

      m = new
      m.instance_eval(&block)

      @@instances[name] = m
      return m
    end

    def find(name)
      @@instances[name]
    end
  end

  attr_reader :initial_state

  def method_missing(method_name, *args)
    if /^move_/ =~ method_name.to_s
      move(method_name.to_s.sub(/move_/, ''))
    end
  end

  def head_at_position(position)
    @position = position
    self
  end

  def of(tape)
    self.tape = tape
  end

  def tape=(tape)
    unless tape.is_a? Tape
      raise TypeError, "wrong argument type (#{tape.class.name}), expected #{Tape.name}"
    end
    @tape = tape
  end

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

  def step
    @states[@current_state][@tape[@position]].call
  end

  def write(symbol)
    @tape[@position] = symbol
  end

  def move(direction)
    if direction == :right then
      @position += 1
    else
      @position -= 1
    end
  end

  def enter(state)
    @current_state = state
    step
  end

  def halt!

  end
end
