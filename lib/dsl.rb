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
