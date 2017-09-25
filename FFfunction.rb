#! /usr/bin/env ruby


%w| FFbase.rb
    FFbinary_ops/FFdiff.rb FFbinary_ops/FFdiv.rb FFbinary_ops/FFpow.rb
    FFbinary_ops/FFprod.rb FFbinary_ops/FFsum.rb 
    FFvalues/FFconstants.rb FFvalues/FFm_functions.rb 
    FFvalues/FFnegative.rb FFvalues/FFnumber.rb FFvalues/FFvariable.rb
    FFinterpreters/FFenvironment.rb FFinterpreters/FFerrors.rb
    FFinterpreters/FFlexer.rb FFinterpreters/FFparser.rb
    FFinterpreters/FFscanner.rb
    FFsystem/FFhistory.rb FFsystem/FFlistener.rb FFsystem/FFoverload.rb
    FFsystem/FFsystem.rb|.each do |file|
    
      require_relative File.expand_path(file,File.dirname(__FILE__))
      
    end


#class FFfunction
#  include Function
#  
#end
