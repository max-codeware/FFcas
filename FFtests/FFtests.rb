#! /usr/bin/env ruby

# require 'pry-byebug'
# binding.pry
=begin
files = Dir["*.rb","FFbinary_ops/*.rb","FFvalues/*.rb","FFinterpreters/*.rb"]
files.each do |file|
  require_relative file unless Dir["FFtests.rb","FFfunction.rb","FF.rb"].include? file
end

x = Function::Variable.new "x"
 y = Function::Variable.new "y"
 k = Function::Variable.new "k"

 n3 = Function::Number.new 3
# n4 = Function::Number.new 4
# n0 = Function::Number.new 0

pi = Function::PI
e  = Function::E

inf  = Function::P_Infinity
minf = Function::M_Infinity

sin = Function::Sin.new x
cos = Function::Cos.new n3*x
log = Function::Log.new(sin)/sin
acos = Function::Acos.new n3*x
asin = Function::Asin.new n3*x
tan = Function::Tan.new n3*x
atan = Function::Atan.new n3*x
sqrt = Function::Sqrt.new n3*x

#puts n3 * y * n4 * n3 *x * minf
#r = -pi
r = y * n3 + k * y 	  #/ n4 #* y * k * inf
puts x + (sin - n3) + x

dr = r.diff(x)

puts "d(#{r.to_s})/dx = #{dr.to_s}"


include Function
f = FFParser.parse("f^3*g^2")
g = FFParser.parse("f")
x = FFParser.parse "x"
puts f.diff(g)
#puts b
=end























