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
      base.extend Aquarium::DSL
      base.output_target = $stdout

      base.log(
        :move_right => "Moved 1 position to the right...",
        :move_left => "Moved 1 position to the left...",
        :write => {
          :format => "Written %s on current position...",
          :args => [ lambda { base.tape[base.position] } ]
        }
      )
    end

    def output_target=(target)
      @output_target = target
    end

    def log(map)
      map.each do |method, message|
        after :calls_to => method, :on_object => self do |jp, object, *args|
          print message
        end
      end
    end

    def print(stream)
      if stream.is_a? Hash
        args = stream[:args].map { |arg| arg.call if arg.is_a? Proc }
        output_target.write stream[:format] % args
      else
        output_target.write stream
      end
    end
  end
end
