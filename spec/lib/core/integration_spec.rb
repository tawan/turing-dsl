require 'spec_helper.rb'

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

describe "Sample implementation" do
  it "should add two numbers" do
    Machine.defined_as(:adder) do
      head_at_position(3).of Tape.with_blank_symbol("0").and_input_symbols("1") { "01101100" }

      in_state 1 do
        on "0" do
          write "1"
          move_right
          enter 2
        end

        on "1" do
          move_right
          enter 1
        end
      end

      in_state 2 do
        on "0" do
          move_left
          enter 3
        end

        on "1" do
          move_right
          enter 2
        end
      end

      in_state 3 do
        on "0" do
        end

        on "1" do
          erase
        end
      end
    end

    adder = Machine.find(:adder)
    adder.tape.to_s.should eq("001101100")

    adder.enter adder.initial_state

    adder.tape.to_s.should eq("001111000")
  end

  it "write over the edges" do
    Machine.defined_as(:edge_case) do
      head_at_position(0).of Tape.with_blank_symbol("0").and_input_symbols("1") { "0" }
      in_state :A do
        on "0" do
          write "1"
          move_left
          enter :B
        end
      end

      in_state :B do
        on "0" do
          write "1"
          move_left
          enter :B
        end
      end

      in_state :C do
        on "0" do
          move_left
          write "1"
        end
      end
    end

    edge_case = Machine.find :edge_case
    edge_case.enter edge_case.initial_state
  end
end
