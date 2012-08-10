require File.expand_path(File.dirname(__FILE__) + '/tape.rb')

class Machine
  class << self
    attr_reader :instances

    def defined_as(name = :turing, &block)
      @instances ||= Hash.new

      m = new
      m.instance_eval(&block)

      @instances[name] = m
      @instances.default = m
      return m
    end

    def find(name = nil)
      return @instances.default if name.nil?
      @instances[name]
    end
  end

  attr_reader :initial_state
  attr_accessor :position

  def head_at_position(position)
    self.position = position
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
    instance_eval(&block)
    @states ||= Hash.new
    @states[state] = @state_collector
    @initial_state ||= state
  end

  def on(symbol, &block)
    @state_collector[symbol] = block
  end

  def write(symbol)
    @tape[self.position] = symbol
  end

  def move_right
    self.position += 1
  end

  def move_left
    self.position -= 1
  end

  def erase
    @tape[self.position] = @tape.blank_symbol
  end

  def enter(state)
    sleep 0.1
    @current_state = state
    puts @tape.to_s
    @states[@current_state][@tape[self.position]].call
  end
end
