require 'spec_helper'
require 'tempfile'

class MockedBase
  attr_reader :tape

  def enter(state = :A)
  end

  def move_right
  end

  def move_left
  end

  def tape
    "test tape"
  end

  def write(sym)

  end

  def position
    0
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
    @base.output_target = Tempfile.new "cli_spec_output"
  end

  it "should log a write operation" do
    @base.write "1"
    @base.output_target.rewind
    @base.output_target.readline
    @base.output_target.readline
    @base.output_target.readline.should eq("Written t on current position...")
  end

  it "should log a move operation" do
    @base.move_left
    @base.output_target.rewind
    @base.output_target.readline
    @base.output_target.readline
    @base.output_target.readline.should eq("Moved 1 position to the left...")

    @base.output_target = Tempfile.new "cli_spec_output"
    @base.move_right
    @base.output_target.rewind
    @base.output_target.readline
    @base.output_target.readline
    @base.output_target.readline.should eq("Moved 1 position to the right...")
  end

  it "should print position, tape and log message all at once" do
    @base.move_left
    @base.output_target.rewind
    @base.output_target.readline.should eq("\u2B07\n")
    @base.output_target.readline.should eq("test tape\n")
    @base.output_target.readline.should eq("Moved 1 position to the left...")
  end
end
