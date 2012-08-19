require File.expand_path(File.dirname(__FILE__) + '/../lib/core/machine.rb')

Machine.defined_as(:simple) do
  head_at_position(0).of Tape.with_blank_symbol("0").and_input_symbols("1") { "0" }

  in_state :A do
    on "0" do
      move_right
      enter :B
    end
  end

  in_state :B do
    on "0" do
      write "1"
      move_right
      enter :C
    end
  end

  in_state :C do
    on "0" do
      move_right
      enter :D
    end
  end

  in_state :D do
    on "0" do
      write "1"
      move_right
      enter :A
    end
  end
end
