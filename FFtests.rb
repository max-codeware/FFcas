#! /usr/bin/env ruby


files = Dir["*.rb","FFbinary_ops/*.rb"]
files.each do |file|
  require_relative file unless file == Dir["FFtests.rb"][0]
end

x = Function::Variable.new "x"
y = Function::Variable.new "y"

puts x + y
