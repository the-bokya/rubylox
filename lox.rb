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
    puts "Interpreting"
  end

  def self.run_file
    puts "Reading"
  end
end

# Execute the module
Lox.init
