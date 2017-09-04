#! /usr/bin/env ruby

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module Function

  class Diff < BinaryOp
  
    alias :red :reduce
    
    # Same of  BinaryOp
    def initialize(l,r)
      super
    end
    
    
    def to_s
      return "#{self.left.to_s}-#{self.right.to_s}"
    end
  
  end
 
end
