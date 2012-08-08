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

  def initialize
  end

  def method_missing(method_name, *args, &block)
    if /^and_/ =~ method_name.to_s
      send(method_name.to_s.sub(/^and_/, '') + '=', *args)
      if block_given?
        unless yield.is_a? String
          raise TypeError,
            "wrong argument type (#{yield.class.name}), expected #{String.name}"
        else
          configure(yield)
        end
      end
      return self
    else
      super
    end
  end

  def read(position)
    @str = blank_symbol if @str.nil?
    return blank_symbol if @str[position].nil?
    @str[position]
  end

  private

  def configure(new_str)
    new_str.each_char do |c|
      unless blank_symbol == c or !input_symbols[c].nil?
        raise StandardError,
          "#{c} is not in the accepted alphabet of the defined machhine!"
      end
    end
    @str = new_str
  end
end
