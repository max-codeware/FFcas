#! /usr/bin/env ruby


files = Dir["*.rb","FFbinary_ops/*.rb","FFnumbers/*.rb"]
files.each do |file|
  require_relative file unless Dir["FFtests.rb","FFfunction.rb"].include? file
end

x = Function::Variable.new "x"
y = Function::Variable.new "y"
k = Function::Variable.new "k"

r = x + y
dr = r.diff(x)

puts "d(#{r.to_s})/dx = #{dr}"
