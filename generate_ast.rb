output_dir = ARGV[0]
def generate_ast (output_dir, base_name, types)
  Dir.mkdir output_dir unless Dir.exists? output_dir
  path = output_dir + "/" + base_name + ".rb"
  file = File.open path, "w+"
  file.write "class #{base_name}#{$/}"
  types.each do |type|
    class_name = (type.split ":")[0].delete " "
    fields = (type.split ":")[1].delete " "
    #define_type file, base_name, class_name, fields
  end
end
generate_ast output_dir, "a", ["meow: ye!"]

