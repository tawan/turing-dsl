require 'spec_helper'
require 'tempfile'
describe CLI::SpeedSettings do
  before(:each) do
    class MockedBase
      def enter(state = :A)
      end

      def move_right
      end

      def move_left
      end

      def tape
        "test tape"
      end
    end
    @base = MockedBase.new
    @base.extend CLI::SpeedSettings
  end
  it "should have a speed" do
    @base.speed.should_not be nil
  end

  it "should inject a sleep to the machine according to speed" do
    start_time = Time.now
    @base.speed = 2.0
    @base.enter
    (Time.now - start_time).should be > 0.1
  end
end
