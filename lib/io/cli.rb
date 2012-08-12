require 'aquarium'
module CLI
  module SpeedSettings
    include Aquarium::DSL

    attr_reader :speed

    def self.extended(base)
      base.speed = 1.0

      before :calls_to => :enter, :on_object => base do |jp, object, *args|
        sleep object.speed
      end
    end

    def speed=(new_speed)
      @speed = new_speed.to_f / 10.0
    end
  end

  module OutputSettings
    attr_reader :output_target
    def self.extended(base)
      base.output_target = $stdout
    end
    def output_target=(target)
      @output_target = target
    end

    def print_tape
      print tape.to_s + "\r"
      output_target.flush
    end

    def print(stream)
      output_target.write stream
    end
  end
end
