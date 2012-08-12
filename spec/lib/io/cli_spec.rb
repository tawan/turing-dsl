require 'spec_helper'
require 'tempfile'

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

describe CLI::SpeedSettings do
  before(:each) do
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

describe CLI::OutputSettings do
  before(:each) do
    @base = MockedBase.new
    @base.extend CLI::OutputSettings
  end

  it "log movements and changes of the tape"  do
    @base.output_target = Tempfile.new "cli_spec_output"
    log_message = "Entered state #{ lambda { @base.current_state.to_s } }..."
    @base.log :enter => log_message
    @base.enter
    @base.output_target.rewind
    @base.output_target.readline.should eq(log_message)
  end
end
