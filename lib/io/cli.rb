require 'aquarium'
module CLI
  include Aquarium::DSL

  def self.extended(base)
    base.speed = 1.0

    before :calls_to => :enter, :on_object => base do |jp, object, *args|
      sleep object.speed
    end
  end

  attr_reader :speed

  def speed=(speed)
    @speed = speed / 10
  end
end
