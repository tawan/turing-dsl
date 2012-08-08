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
    @offset = 0
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

  def [](position)
    @str = blank_symbol and return blank_symbol if @str.nil?
    return blank_symbol if @str[position + @offset].nil?
    @str[position + @offset]
  end

  def []=(position, symbol)
    validate!(symbol) 
    if @str.size <= (position + @offset)
      @str << blank_symbol * ((position + @offset) - @str.size)
      @str << symbol
    elsif position < 0
      if (position.abs > @offset)
        @str.insert(0, blank_symbol * (position.abs - @offset))
        @offset = position.abs
      end
      @str[@offset - position.abs] = symbol
    else
      @str[position + @offset] = symbol
    end
  end

  private

  def configure(new_str)
    new_str.each_char do |c|
      validate!(c)
    end
    @str = new_str
  end


  def validate!(symbol)
    if alphabet[symbol].nil? 
      raise StandardError,
        "#{c} is not in the accepted alphabet (#{alphabet})of the defined machhine!"
    end
  end

  def alphabet
    input_symbols << blank_symbol
  end

  def str
    @str
  end
end
