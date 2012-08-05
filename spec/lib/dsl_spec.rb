require 'spec_helper'

describe DSL do
	it "can be defined"do
		m = Machine.defined_as {}
	end

	describe "defined" do
		it "can have a name"do
			with_name = Machine.defined_as(:turing) {}
		end

		it "can be found by its name" do
			turing = Machine.defined_as(:turing) {}
			Machine.find(:turing).should eq(turing)
		end
	end
end
