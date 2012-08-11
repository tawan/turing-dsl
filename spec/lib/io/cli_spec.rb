require 'spec_helper'
require 'tempfile'
describe CLI do
  before(:each) do
    class TestInjectOfSleep
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

  it "should display the tape" do
    @base.output_target = Tempfile.new("cli_spec_example")
    @base.enter
    @base.output_target.rewind
    @base.output_target.readline.should eq(@base.tape)
  end

  it "should display always on the same line" do
    @base.output_target = Tempfile.new("cli_spec_example")
    @base.enter
    @base.output_target.readline.should eq(@base.tape)
  end
end
