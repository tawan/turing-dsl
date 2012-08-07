class Tape
  class << self
    def with_blank_symbol(symbol)
      instance = new
      instance.blank_symbol = symbol
      instance
    end

    def with_input_symbols(symbols)
      instance = new
      instance.input_symbols = symbols
      instance
    end
  end

  attr_accessor :blank_symbol, :input_symbols

  def method_missing(method_name, *args)
    if /^and_/ =~ method_name.to_s
      send(method_name.to_s.sub(/^and_/, '') + '=', *args)
      return self
    else
      super
    end
  end
end
