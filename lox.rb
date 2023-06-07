require "./scanner.rb"
#Create a Lox module to initiate the interpretation
module Lox
  @had_error = false
  def self.init
    begin
      ARGF.filename
    rescue Errno::ENOENT
      puts "No such file"
    else
      if ARGF.filename == "-"
        self.run_prompt
      else
        self.run_file
      end
    end
  end

  def self.run_prompt
    loop do
      print "> "
      @line = gets
      self.run @line
      @had_error = false
    end
  end

  def self.run_file
    file = ARGF.file
    begin
      @lines = file.read
    rescue Errno::EISDIR
      puts "#{ARGF.filename} is a directory"
    else
      self.run @lines
    end
  end

  def self.run(source)
    @had_error and exit
    @scanner = Scanner.new(source)
    @tokens = @scanner.scan_tokens
  end

  def self.error(line, message)
    report(line, "", message)
  end

  def self.report(line, where, message)
    puts "[line #{line}] Error#{where}: #{message}"
  end
end

# Execute the module
Lox.init
