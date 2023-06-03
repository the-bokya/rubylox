#Create a Lox module to initiate the interpretation
module Lox
  def self.init
    begin
    ARGF.filename
    rescue Errno::ENOENT
      puts "No such file"
      else
        if ARGF.filename == "-"
          self.runPrompt
        else
          self.runFile
        end
    end
  end
  def self.runPrompt
    puts "Interpreting"
  end
  def self.runFile
    puts "Reading"
  end
end

# Execute the module
Lox.init
