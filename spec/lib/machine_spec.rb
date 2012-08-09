require 'spec_helper'

describe Machine do
  before(:each) do
    @tape = double("Tape")
    @tape.stub(:[]=)
    @tape.stub(:is_a? => Tape)
    tape = @tape
    @sample = Machine.defined_as do
      head_at_position(0).of tape
      in_state :A do
        on "0" do end
        on "1"do end
      end
    end
  end

  it "can be defined" do
    m = Machine.defined_as {}
  end

  it "can only be fed with a tape" do
    lambda { @sample.tape=("0000") }.should raise_error
    lambda { @sample.tape=(@tape) }.should_not raise_error
  end

  describe "defined" do
    it "can have a name"do
      with_name = Machine.defined_as(:turing) {}
    end

    it "can be found by its name" do
      turing = Machine.defined_as(:turing) {}
      Machine.find(:turing).should eq(turing)
    end

    it "can define states"do
      Machine.defined_as do
        in_state(:A) {}
        in_state(:B) {}
      end
    end

    it "should have an initial state" do
      Machine.defined_as do
        in_state :initial do end
        in_state :other do end
      end.initial_state.should eq(:initial)
    end

    it "'s states can have defined instructions on read symbol" do
      Machine.defined_as do
        in_state :A do
          on "0" do end
        end
      end
    end

    it "can put it's head on a tape" do
      tape = @tape
      Machine.defined_as do
        head_at_position(0).of tape
      end.position.should eq(0)
    end

    it "can print on a tape" do
      @sample.write(1)
    end

    it "can move left and right" do
      @sample.head_at_position(0).of(@tape)
      @sample.position.should eq(0)
      @sample.move_right
      @sample.move_left
    end
  end
end
