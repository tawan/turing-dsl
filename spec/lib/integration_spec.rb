require 'spec_helper'

describe "Integration of" do
  describe Machine do
    describe "and Tape" do
      it "should put its head on a tape" do
        Machine.defined_as do
          head_at_position(0).of Tape.with_blank_symbol("0").and_input_symbols("1") { "010101" }
        end
      end
    end
  end
end
