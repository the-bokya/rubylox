require "./token.rb"
class Scanner
  @start = 0
  @current = 0
  @line = 1

  @source = ""
  @tokens = []
  def initialize(source)
    @source = source
  end
  
  def scan_tokens
    until at_end?
      @start = current
      scan_token
    end
    @tokens << Token.new(TokenType::EOF, "", nil, line) # This line (tokens) will be returned
  end

  def at_end?
    @current.to_i >= @source.length
  end
end
