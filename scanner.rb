require "./token.rb"
require "./token_type.rb"
class Scanner
  @source = ""
  @tokens = []
  def initialize(source)
    @source = source
  end

  def scan_tokens
    until is_at_end
      @start = current
      scan_token
    end
    @tokens << Token.new(TokenType::EOF, "", nil, line) # This line (tokens) will be returned
  end
end
