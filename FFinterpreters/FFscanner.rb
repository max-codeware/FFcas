#! /usr/bin/env ruby

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module Function

  class FFscanner
    
    def set(filename)
      raise "Scan Error: cannot set scanner. Scanning is disabled" unless FFenv.scanning
      raise "File Error: invalid filename" unless File.exist? filename
      file = File.open(filename,"r")
      raise "File Error: cannot open file" unless file
      @line = 0
    end
    
    def next_line
      @line += 1
      out = file.gets
      return :EOF unless out
      return out
    end
    
    def line
      return @line
    end
    
    def close
      file.close
      filename = nil
    end
    
  end

  FFscan = FFscanner.new

end
