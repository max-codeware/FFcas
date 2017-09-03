#! /usr/bin/env ruby

files = Dir["*.rb","FFbinary_ops/*.rb","FFnumbers/*.rb"]
files.each do |file|
  require_relative file unless Dir["FFtests.rb","FFfunction.rb"]
end



class FFfunction
  include Function
  
end
