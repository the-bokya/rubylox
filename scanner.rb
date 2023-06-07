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

  def scan_token
    c = advance
    case c
    when '('
      addToken(TokenType::LEFT_PAREN)
    when ')'
      addToken(TokenType::RIGHT_PAREN)
    when '{'
      addToken(TokenType::LEFT_BRACE)
    when '}'
      addToken(TokenType::RIGHT_BRACE)
    when ','
      addToken(TokenType::COMMA)
    when '.'
      addToken(TokenType::DOT)
    when '-'
      addToken(TokenType::MINUS)
    when '+'
      addToken(TokenType::PLUS)
    when ';'
      addToken(TokenType::SEMICOLON)
    when '*' 
      addToken(TokenType::STAR) 
    end
end
