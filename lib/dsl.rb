module DSL
  module ClassMethods
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

  module InstanceMethods
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
  end
end
