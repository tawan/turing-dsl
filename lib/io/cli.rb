require 'aquarium'
module CLI
  module SpeedSettings
    include Aquarium::DSL

    attr_reader :speed

    def self.extended(base)
      base.speed = 1.0

      before :calls_to => [:move_left, :move_right, :write], :on_object => base do |jp, object, *args|
        sleep object.speed
      end
    end

    def speed=(new_speed)
      @speed = new_speed.to_f / 10.0
    end
  end

  module OutputSettings

    attr_reader :output_target
    attr_accessor :clear_on_update

    def self.extended(base)
      base.extend Aquarium::DSL
      base.output_target = $stdout
      base.clear_on_update = false

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
      @output_target.set_encoding 'UTF-8'
    end

    def log(map)
      map.each do |method, message|
        after :calls_to => method, :on_object => self do |jp, object, *args|
          update message
        end
      end
    end

    def update(stream)
      system 'clear' if clear_on_update
      output_target.print " " * tape.transform(position) + "\u2B07\n"
      output_target.print tape.to_s + "\n"

      if stream.is_a? Hash
        args = stream[:args].map { |arg| arg.is_a?(Proc) ? arg.call : arg }
        output_target.write stream[:format] % args
      else
        output_target.write stream
      end
    end
  end
end
