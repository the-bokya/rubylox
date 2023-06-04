class Token
  def token(type, lexeme, literal, line)
    @type = type
    @lexeme = lexeme
    @literal = literal
    @line = line
  end
  def to_string
    "#{@type} #{@lexeme} #{@literal}"
  end
end
