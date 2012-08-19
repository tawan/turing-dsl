require 'spec_helper'

describe Tape do
  before(:each) do
    @sample = Tape.with_blank_symbol("0").and_input_symbols("1") do
      "01"
    end
  end

  it "has blank symbol" do
    Tape.with_blank_symbol('0').blank_symbol.should eq('0')
  end

  it "should have a length" do
    @sample.length.should be 2
  end

  it "should have input symbols" do
    Tape.with_input_symbols("1").input_symbols.should eq('1')
  end

  it "should support a DSL like definition" do
    tape = Tape.with_blank_symbol("0").and_input_symbols("1")
    tape.blank_symbol.should eq("0")
    tape.input_symbols.should eq("1")

    tape = Tape.with_input_symbols("abc").and_blank_symbol(" ")
    tape.blank_symbol.should eq(" ")
    tape.input_symbols.should eq("abc")
  end

  it "can be initialized with a starting configuration" do
    tape = Tape.with_blank_symbol("0").and_input_symbols("1") do
      "001111"
    end
    tape[1].should eq("0")
    tape[2].should eq("1")

    lambda do
      Tape.with_blank_symbol("0").and_input_symbols("1") do
        "00vxz1"
      end
    end.should raise_error
  end

  it "should return the blank symbol on default" do
    Tape.with_blank_symbol("b")[0].should eq("b")
    Tape.with_blank_symbol("b")[1].should eq("b")
    Tape.with_blank_symbol("b")[-1].should eq("b")
  end

  it "can be written on" do
    @sample[0] = "1"
    @sample[0].should  eq("1")
    lambda { @sample[0] = "x" }.should raise_error

  end

  it "expand with blank symbols if written out of index" do
    @sample[3] = "1"
    @sample[2].should eq("0")
    @sample[3].should eq("1")

    @sample[-3] = "1"
    @sample[-2] = "1"
    @sample[5] = "1"
    @sample[-1].should eq("0")
    @sample[-2].should eq("1")
    @sample.send(:str).should eq("110010101")
  end
end
