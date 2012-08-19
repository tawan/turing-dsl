require File.expand_path(File.dirname(__FILE__) + '/../lib/core/machine.rb')

Machine.defined_as(:successor) do
  head_at_position(4).of Tape.with_blank_symbol("0").and_input_symbols("1") { "11100" }

  in_state 1 do
    on "0" do
    end

    on "1" do
      move_right
      enter 2
    end
  end

  in_state 2 do
    on "0" do
      move_right
      enter 3
    end

    on "1" do
      move_right
      enter 9
    end
  end

  in_state 3 do
    on "0" do
      write "1"
      move_left
      enter 4
    end

    on "1" do
      move_right
      enter 3
    end
  end

  in_state 4 do
    on "0" do
      move_left
      enter 5
    end

    on "1" do
      move_left
      enter 4
    end
  end

  in_state 5 do
    on "0" do
      move_left
      enter 5
    end

    on "1" do
      move_left
      enter 6
    end
  end

  in_state 6 do
    on "0" do
      move_right
      enter 2
    end

    on "1" do
      move_right
      enter 7
    end
  end

  in_state 7 do
    on "0" do
      move_right
      enter 8
    end

    on "1" do
      erase
      move_right
      enter 7
    end
  end

  in_state 8 do
    on "0" do
      move_right
      enter 8
    end

    on "1" do
      move_right
      enter 3
    end
  end

  in_state 9 do
    on "0" do
      write "1"
      move_right
      enter 9
    end

    on "1" do
      move_left
      enter 10
    end
  end

  in_state 10 do
    on "0" do
    end

    on "1" do
      erase
      move_right
      enter 11
    end
  end

  in_state 11 do
    on "0" do
      write "1"
    end

    on "1" do
      move_right
      enter 11
    end
  end
end
