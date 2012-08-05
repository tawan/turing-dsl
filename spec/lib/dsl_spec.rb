require 'spec_helper'

describe DSL do
  before(:all) do
    class SampleBaseClass
      extend DSL::ClassMethods
      include DSL::InstanceMethods
    end
  end

  it "can define a new machine"do
    m = SampleBaseClass.defined_as {}
  end

  describe "SampleBaseClass defined" do
    it "can have a name"do
      with_name = SampleBaseClass.defined_as(:turing) {}
    end

    it "can be found by its name" do
      turing = SampleBaseClass.defined_as(:turing) {}
      SampleBaseClass.find(:turing).should eq(turing)
    end

    it "can define states"do
      SampleBaseClass.defined_as do
        in_state(:A) {}
        in_state(:B) {}
      end  
    end

    it "should have an initial state" do
      SampleBaseClass.defined_as do
        in_state :initial do end
        in_state :other do end
      end.initial_state.should eq(:initial)
    end

    it "'s states can have defined instructions" do
      SampleBaseClass.defined_as do
        in_state :A do
          on "0"do end
        end
      end
    end
  end
end
