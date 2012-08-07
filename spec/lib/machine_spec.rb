require 'spec_helper'

describe Machine do
  before(:each) do
    @sample = Machine.defined_as do
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
    lambda { @sample.tape=(Tape.new) }.should_not raise_error
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
  end
end
