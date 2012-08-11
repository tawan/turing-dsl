require 'aquarium'
module CLI
  include Aquarium::DSL

  def self.extended(base)
    base.speed = 1.0

    before :calls_to => :enter, :on_object => base do |jp, object, *args|
      sleep object.speed
      object.print_tape
    end

    base.output_target = $stdout
  end

  attr_reader :speed, :output_target
  
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

  def speed=(speed)
    @speed = speed / 10
  end
end
