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

  attr_accessor :input_symbols
  attr_reader :blank_symbol

  def initialize
    @pos_str = ""
    @neg_str = ""
  end

  def blank_symbol=(sym)
    @pos_str = sym
    @neg_str = sym
    @blank_symbol = sym
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

  def [](pos)
    @pos_str = blank_symbol and return blank_symbol if str.empty?
    if (pos >= 0)
      @pos_str << blank_symbol * (pos - @pos_str.length + 2) if pos + 1 >= @pos_str.length
      return @pos_str[pos]
    else
       @neg_str << blank_symbol * (pos.abs - @neg_str.length + 1) if pos.abs >= @neg_str.length
      return @neg_str[pos.abs - 1]
    end
  end

  def []=(position, symbol)
    validate!(symbol)
    if position >= 0
      diff = position - @pos_str.size
      @pos_str << blank_symbol * diff if diff > 0
      @pos_str[position] = symbol
    else
      diff = position.abs - 1 - @neg_str.size
      @neg_str << blank_symbol * diff if diff > 0
      @neg_str[position.abs - 1] = symbol
    end
  end

  def inspect
    str
  end

  def to_s
    str
  end

  def length
    @pos_str.length + @neg_str.length
  end

  def transform(pos)
    pos + @neg_str.length
  end

  private

  def configure(new_str)
    new_str.each_char do |c|
      validate!(c)
    end
    @pos_str = new_str
  end


  def validate!(symbol)
    if alphabet[symbol].nil?
      raise StandardError,
        "#{symbol} is not in the accepted alphabet (#{alphabet})of the defined machhine!"
    end
  end

  def alphabet
    input_symbols << blank_symbol
  end

  def str
    @pos_str << blank_symbol if @pos_str.empty?
    @neg_str.reverse + @pos_str
  end
end
