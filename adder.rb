require File.expand_path(File.dirname(__FILE__) + '/lib/machine.rb')

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
      puts @tape.to_s
    end
  end
end.enter 1
