#! /usr/bin/env ruby

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module Function
  
  class Pow < BinaryOp
    
    alias :red :reduce
    
    # See BinaryOp
    def initialize(l,r)
     super
    end
    
    def +(obj)
      return nil unless (self.top) || (self == obj)
      return Number.new(2) * self if self == obj
      return Sum.new(self,obj)
    end
    
    def -(obj)
      return nil unless (self.top) || (self == obj)
      return Number.new 0 if self == obj
      return Diff.new(self,obj).reduce
    end
    
    def *(obj)
      return nil unless (self.top) || (self == obj) || (self =~ obj)
      if self == obj
        exp = self.right
        exp.top = true
        exp *= Number.new 2
        return Pow.new(self.left,exp).reduce
      end
      if self =~ obj
        if obj.is_a? Pow
          exp = self.right
          exp.top = true
          exp += obj.right
          return Pow.new(self.left,exp).reduce
        else
          exp = self.right
          exp.top = true
          exp += Number.new 1
          return Pow.new(self.left,exp).reduce
        end
      end
      return Prod.new(self,obj) unless obj.is_a? Number
      return Prod.new(obj,self)
    end
    
    def **(obj)
      exp = self.right
      exp.top = true
      exp *= obj
      return Pow.new(self.right,exp).reduce
    end
    
    def =~(obj)    
      return self.left == obj.left if obj.is_a? Pow
      return self.left == obj
    end
    
    def reduce
      self.red
      return self.left if self.right == 1
      raise "Math Error: ∞^0" if (self.left == P_Infinity or self.left == M_Infinity) or (self.right == 0)
      raise "Math Error: 1^∞" if self.left == 1 and (self.right == P_Infinity or self.right == M_Infinity)
      if self.left.is_a? Number 
        return Number.new 0 if self.left.val >0 and self.left.val < 1 and self.right == P_Infinity 
        return P_Infinity if self.left.val >0 and self.left.val < 1 and self.right == M_Infinity
        return Number.new 0 if self.right == M_Infinity
        return P_Infinity if self.right == P_Infinity
        return Number.new 0 if self.right == 0
        return self.left ** self.right if self.right.is_a? Number
      end
      return self.left.val ** self.right if self.left.is_a? Negative and self.right.is_a? Number and self.right.even
      return Negative.new(self.left.val ** self.right) if self.left.is_a? Negative and self.right.is_a? Number and self.right.odd
      return Number.new(1) / (self.left ** self.right.val) if self.right.is_a? Negative
      return Number.new 0 if self.left == 0
      return self
    end
    
    def invert
      ret = Negative.new self
      ret.top = self.top
      return ret
    end
    
    def diff(var)
      lft, rht = self.left, self.right
      lft.top, rht.top = true, true
      d_lft == lft.diff(var)
      exp = rht - Number.new(1)
      return rht *(lft ** exp) * d_lft
    end
    
    def to_s
      lft = (self.left.is_a? Sum or self.left.is_a? Diff) ? "(#{self.left.to_s})" : self.left.to_s
      rht = (self.right.is_a? Sum or self.right.is_a? Diff) ? "(#{self.right.to_s})" : self.right.to_s
      return "#{lft}^#{rht}"
    end
    
    def to_b
      lft = (self.left.is_a? Sum or self.left.is_a? Diff) ? "(#{self.left.to_b})" : self.left.to_b
      rht = (self.right.is_a? Sum or self.right.is_a? Diff) ? "(#{self.right.to_b})" : self.right.to_b
      return "#{lft}**#{rht}"
    end
    
  end

end





