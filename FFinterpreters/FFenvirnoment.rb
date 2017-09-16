#! /usr/bin/env ruby

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module Function

  Enabled  = true
  Disabled = false
  
  class FFenvironment
  
    def initialize
      @scan  = Disabled
      self.iMode = Disabled
      @vars = {}
    end
    
    def set_var(name,value)
      raise "iMode Error: cannot set variables if iMode is disabled" unless self.iMode
      @vars[name] = value
    end
    
    def get_var(name)
      raise "iMode Error: cannot get variables if iMode is disabled" unless self.iMode
      raise "Argument Error: variable #{name} not defined" unless @vars.keys.include? name
      return @vars[name]
    end

    def scanning=(state)
      raise "Scan Error: cannot modify scan state if iMode is disabled" unless self.iMode
      @scan = state
    end
    
    def scanning
      return @scan
    end
    
    def iMode=(state)
      @iMode = state
    end
    
    def iMode
      return @iMode
    end

  end
  
  FFenv = FFenvironment.new

end


