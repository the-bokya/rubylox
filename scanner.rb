require "./token.rb"
class Scanner
  def initialize(source)
    @tokens = []
    @start = 0
    @current = 0
    @line = 1
    @source = source
  @keywords = {"and" => TokenType::AND, "class" => TokenType::CLASS, "else" => TokenType::ELSE, "false" => TokenType::FALSE, "for" => TokenType::FOR, "fun" => TokenType::FUN, "if" => TokenType::IF, "nil" => TokenType::NIL, "or" => TokenType::OR, "print" => TokenType::PRINT, "return" => TokenType::RETURN, "super" => TokenType::SUPER, "this" => TokenType::THIS, "true" => TokenType::TRUE, "var" => TokenType::VAR, "while" => TokenType::WHILE}
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
      add_token((match("=") && TokenType::BANG_EQUAL || TokenType::BANG))
    when "="
      add_token((match("=") && TokenType::EQUAL_EQUAL || TokenType::EQUAL))
    when "<"
      add_token((match("=") && TokenType::LESS_EQUAL || TokenType::LESS))
    when ">"
      add_token((match("=") && TokenType::GREATER_EQUAL || TokenType::GREATER))
    when "/"
      if peek == "/" #Eats up a comment
        advance
        while (peek() != "\n" && !at_end?)
          advance
        end
      elsif peek == "*" #Eats up a multiline comment
        advance
        multi 
      else
        add_token TokenType::SLASH
      end
    when " "
    when "\r"
    when "\t"
    when "\n"
      @line += 1
    when '"'
      string
    else
      if digit? c
        number
      elsif alpha? c
        identifier
      else
        Lox.error(@line, "Unexpected character #{c}")
      end
    end
  end

  def advance
    @out = @source[@current]
    @current += 1
    @out
  end

  def add_token(type, literal = nil)
    if literal == nil
      @text = @source[@start..@current - 1]
      @tokens << Token.new(type, @text, literal, @line)
    end
    puts "#{type}: #{literal}"
  end

  def match (expected)
    if at_end? || @source[@current] != expected
    @current += 1
      false
    else
    @current += 1
      true
    end
  end

  def peek
    at_end? && "\0" || @source[@current]
  end

  def peek_next
    ((@current + 1 >= @source.length)  && "\0" || @source[@current + 1])
  end

  def string
    while peek != '"' && !at_end?
      if peek == "\n"
        @line += 1
      end
      advance
    end
    if at_end?
      Lox.error(@line, "Unterminated string")
    end
    advance
    @value = @source[(@start + 1) .. @current-2]
    add_token(TokenType::STRING, @value)
  end

  def digit?(c)
    "0" <= c && c <= "9"
  end

  def alpha?(c)
    ("a" <= c && c <= "z") || ("A" <= c && c <= "Z") || c == "_"
  end

  def alphanumeric?(c)
    alpha?(c) || digit?(c)
  end

  def identifier
    while alphanumeric? peek
      advance
    end
    @text = @source[@start .. @current - 1]
    @type = @keywords[@text]
    if @type == nil
      @type = TokenType::IDENTIFIER
    end
    add_token @type
  end
  
  def number
    while digit? peek
      advance
    end
    if peek == "." && (digit? peek_next)
      advance
      while digit? peek
        advance
      end
    end
    @text = @source[@start .. @current - 1]
    add_token TokenType::NUMBER, @text.to_f
  end

  def multi
    loop {
      if peek() == "/" && peek_next() == "*"
        advance
        advance
        multi
      elsif peek() == "*" && peek_next() == "/"
        advance
        advance
        break
      end
      advance
    }
  end
end
