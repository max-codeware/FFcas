#! /usr/bin/env ruby

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module Function
  
  class Number < Base
    
    def initialize(val)
      @val = val
      self.top = true
    end
    
    def val
      return @val
    end
    
    def +(obj)
      return nil unless (self.top) || (obj.is_a? Number) || (obj.is_a? Negative and obj.val.is_a? Number) || 
                                                            (obj == P_Infinity) || (obj == M_Infinity)
      return obj if self == 0
      return P_Infinity if obj == P_Infinity
      return M_Infinity if obj == M_Infinity
      return Number.new(self.val + obj.val) if obj.is_a? Number
      return self - obj.val if obj.is_a? Negative
      return obj + self  if obj.is_a? BinaryOp
      return Sum.new(obj,self) 
    end
    
    def -(obj)
      return nil unless (self.top) || (obj.is_a? Number) || (obj == P_Infinity) || (obj == M_Infinity)
      return obj.invert if self == 0
      return P_Infinity if obj == M_Infinity
      return M_Infinity if obj == P_Infinity
      if obj.is_a? Number
        if self.val > obj.val
          return Number.new(self.val - obj.val) 
        else
          return Negative.new(Number.new((self.val - obj.val).abs)) 
        end
      end
      if (obj.is_a? Sum) || (obj.is_a? Diff)
        obj = obj.invert
        return self + obj
      end
      return Number.new(self.val + obj.val) if obj.is_a? Negative
      return Diff.new(self,obj)       
    end
    
    def *(obj)
      return nil unless (self.top) || (obj.is_a? Number) || (obj == P_Infinity) || (obj == M_Infinity)
      raise "Math Error 0*∞" if (self == 0) && ((obj == P_Infinity) || (obj == M_Infinity))
      return obj if self == 1
      if obj == P_Infinity
        return (self.val > 0) ? P_Infinity : M_Infinity
      end
      if obj == M_Infinity
        return (self.val > 0) ? M_Infinity : P_Infinity
      end
      return Number.new(self.val * obj.val) if obj.is_a? Number
      return obj * self if obj.is_a? BinaryOp
      return Negative.new(self * obj.val) if obj.is_a? Negative
      return Prod.new(self,obj).reduce 
    end
    
    def /(obj)
      return nil unless (self.top) || (obj.is_a? Number) || (obj == P_Infinity) || (obj == M_Infinity)
      return Number.new 0 if (obj == P_Infinity) || (obj == M_Infinity)
      return Negative.new(Div.new(self,obj.val)) if obj.is_a? Negative
      return Div.new(self,obj).reduce
    end
    
    def **(obj)
      return nil unless (self.top) || (obj.is_a? Number) || (obj == P_Infinity) || (obj == M_Infinity)
      raise "Math Error: 0^∞" if (self == 0) && ((obj == P_Infinity) || (obj == M_Infinity))
      raise "Math Error: 0^0" if (self == 0) && (obj == 0)
      return P_Infinity if obj == P_Infinity
      return Number.new 0 if obj == M_Infinity
      return Number.new(self.val ** obj.val) if obj.is_a? Number
      return Pow.new(self,obj).reduce
    end
    
    # Implementation of unary plus
    #
    # * **returns**: self
    def +@
      return self
    end
    
    # Implementation of unary minus
    #
    # * **returns**: new Negative (arg -> self)
    def -@
      return self.invert
    end
    
    def invert
      inv = Negative.new self
      inv.top = self.top
      return Negative.new self
    end
    
    def reduce
      return self unless self.val < 0
      return Negative.new(self.val.abs)
    end
    
    def diff(var)
      return Number.new 0
    end
    
    def ==(obj)
      return false unless (obj.is_a? Number) || (obj.is_a? Numeric)
      return self.val == obj if obj.is_a? Numeric
      return self.val == obj.val
    end
    
    def depend?(obj)
      return false
    end
    
    def to_s
      return val.to_s
    end
    
    def to_b
      return val
    end
    
    # def =~(obj)
    #  return self == obj
    # end
    
  end

end








