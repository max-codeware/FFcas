#! /usr/bin/env ruby

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module Function

  class Sum < BinaryOp
  
    def initialize(l,r)
      super
    end
        
    def +(obj)
      obj.top = false
      if obj.is_a? BinaryOp then
        op = self + obj.left
        op += self + obj.right
        return op
      end
      lft = self.left + obj
      if !(lft == nil) then
        @left = lft
      else
        rht = self.right + obj
        if !(rht == nil) then
          @right = rht
        else
          self.top = false
          return Sum.new(self,obj)
        end
      end
    end
  end
  
  class Diff < BinaryOp
  
  end
  
  class Prod < BinaryOp
  
  end
  
  class Div < BinaryOp
  
  end
  
  class Pow < BinaryOp
  
  end

end
