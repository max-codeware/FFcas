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

sin = Function::Sin.new x*n3
log = Function::Log.new(sin)/sin

#puts n3 * y * n4 * n3 *x * minf
r = log
#r = y * n3 + k * y 	  #/ n4 #* y * k * inf
puts r

dr = r.diff(x)

puts "d(#{r.to_s})/dk = #{dr.to_s}"
