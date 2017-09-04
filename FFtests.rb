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

n1 = Function::Number.new 3
n2 = Function::Number.new 4

r = x + n1 + Function::Negative.new(n2)

puts r

dr = r.diff(x)

puts "d(#{r.to_s})/dx = #{dr.to_s}"
