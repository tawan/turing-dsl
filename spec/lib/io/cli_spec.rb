require 'spec_helper'
describe CLI do
  before(:each) do
    class TestInjectOfSleep
      def enter
      end
    end
    @base = TestInjectOfSleep.new
    @base.extend CLI
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