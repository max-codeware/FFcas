#! /usr/bin/env ruby

# require 'pry-byebug'
# binding.pry

files = Dir["*.rb","FFbinary_ops/*.rb","FFnumbers/*.rb"]
files.each do |file|
  require_relative file unless Dir["FFtests.rb","FFfunction.rb"].include? file
end

x = Function::Variable.new "x"
y = Function::Variable.new "y"
k = Function::Variable.new "k"

n3 = Function::Number.new 3
n4 = Function::Number.new 4
n0 = Function::Number.new 0

pi = Function::PI
e  = Function::E

inf  = Function::P_Infinity
minf = Function::M_Infinity

puts (n3 - x) - (n4 + inf)
#r = x + n1 - n2 + k + Function::Negative.new(y)
#puts r

#dr = r.diff(y)

#puts "d(#{r.to_s})/dx = #{dr.to_s}"
