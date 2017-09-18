#! /usr/bin/env ruby

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module Function
  
  module FFerrors
  
    def main(message)
      puts message
      exit 0
    end
    
    def unexpected(tk)
      message = "Sintax Error: unexpected #{tk[0].to_s} '#{tk[2]}'\n#{FFlex.context}\n#{' ' * tk[1]}^"
      message += "\nFrom line: #{FFscan.line}" if FFenv.scanning == Enabled
      main message
    end
    
    def expecting(tk,expected)
      message = "Sintax Error: expecting #{expected} but #{tk[0].to_s} '#{tk[2]}' found\n#{FFlex.context}\n#{' ' * tk[1]}^"
      message += "\nFrom line: #{FFscan.line}" if FFenv.scanning == Enabled
      main message
    end
    
    def found_eol(expected)
      message = "Sintax Error: expecting #{expected} but end-of-line found\n#{FFlex.context}\n#{' ' * FFlex.context.size}^"
      message += "\nFrom line: #{FFscan.line}" if FFenv.scanning == Enabled
      main message
    end
    
  end
  
  class FFparser; include FFerrors; end
  
end
