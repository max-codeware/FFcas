#! /usr/bin/env ruby

# module Function
#  def self.parse
#    
#  end
# end

files = Dir["*.rb","FFbinary_ops/*.rb","FFvalues/*.rb","FFinterpreters/*.rb"]
files.each do |file|
  require_relative file unless Dir["FFtests.rb","FFfunction.rb"].include? file
end


#class FFfunction
#  include Function
#  
#end
