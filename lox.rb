#Create a Lox module to initiate the interpretation
module Lox
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
      line = gets
      line.chomp!
      run line
    end
  end

  def self.run_file
    file = ARGF.file
    begin
      lines = file.readlines
    rescue Errno::EISDIR
      puts "#{ARGF.filename} is a directory"
    else
        lines.each { |line| self.run line }
    end
  end

  def self.run(line)
    puts "I'm here cuz master demands of me to be."
    puts "Reading line #{line}"
  end

  def error(line, message)
    report(line, "", message)
  end

  def report(line, where, message)
    puts "[line #{line}] Error#{where}: #{message}"
  end
end

# Execute the module
Lox.init
