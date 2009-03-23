require 'test/unit'
require File.expand_path(
    File.join(File.dirname(__FILE__), %w[.. lib sweep]))

TEST_FILE = <<CODE 
namespace :first do
  namespace :second do
    task :one => [:two, "poop.txt", "what/hi/hah"] do
      puts "you rock"
    end
    
    task :two, [:param_one, :param_two] => [:what] do |t, args|
      puts "dude"
    end
  end
  
  task :three do
    puts "whee"
  end
end

task :top  do
  puts "ARGH"
end

file "test.txt" do
  File.open("poop.txt", "w+") {|f| f.write("yo") }
end

directory("test/ing")

CODE