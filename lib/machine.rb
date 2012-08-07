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
