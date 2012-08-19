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
    @pos_str = ""
    @neg_str = ""
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
    @pos_str = blank_symbol and return blank_symbol if str.empty?
    if (position >= 0)
      return blank_symbol if @pos_str[position].nil?
      return @pos_str[position]
    else
      return blank_symbol if @neg_str[position.abs - 1].nil?
      return @neg_str[position.abs - 1]
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
