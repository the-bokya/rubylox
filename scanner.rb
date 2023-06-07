require "./token.rb"
class Scanner
  def initialize(source)
    @tokens = []
    @start = 0
    @current = 0
    @line = 1
    @source = source
  end

  def scan_tokens
    until at_end?
      @start = @current
      scan_token
    end
    @tokens << Token.new(TokenType::EOF, "", nil, @line) # This line (tokens) will be returned
  end

  def at_end?
    @current >= @source.length
  end

  def scan_token
    c = advance
    case c
    when "("
      add_token TokenType::LEFT_PAREN
    when ")"
      add_token TokenType::RIGHT_PAREN 
    when "{"
      add_token TokenType::LEFT_BRACE 
    when "}"
      add_token TokenType::RIGHT_BRACE 
    when ","
      add_token TokenType::COMMA 
    when "."
      add_token TokenType::DOT 
    when "-"
      add_token TokenType::MINUS 
    when "+"
      add_token TokenType::PLUS 
    when ";"
      add_token TokenType::SEMICOLON 
    when "*"
      add_token TokenType::STAR 
    when "!"
      add_token((match("=") and TokenType::BANG_EQUAL or TokenType::BANG))
    when "="
      add_token((match("=") and TokenType::EQUAL_EQUAL or TokenType::EQUAL))
    when "<"
      add_token((match("=") and TokenType::LESS_EQUAL or TokenType::LESS))
    when ">"
      add_token((match("=") and TokenType::GREATER_EQUAL or TokenType::GREATER))
    when "/"
      if match "/" #Eats up a comment
        while (peek() != "\n" and !at_end?)
          advance
        end
      else
        add_token TokenType::SLASH
      end
    when " "
    when "\r"
    when "\t"
    when "\n"
      @line += 1
    else
      Lox.error(@line, "Unexpected character #{c}")
    end
  end

  def advance
    @out = @source[@current]
    @current += 1
    @out
  end

  def add_token(type, literal = nil)
    @text = @source[@start..@current - 1]
    @tokens << Token.new(type, @text, literal, @line)
  end

  def match (expected)
    if at_end? or @source[@current] != expected
      false
    end
    @current += 1
    true
  end

  def peek
    at_end? and "\0" or @source[@current]
  end
end
