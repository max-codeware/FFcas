#! /usr/bin/env ruby

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module Function
  
  ##
  # This class represents an abstract power between two algebric elements
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class Pow < BinaryOp
    
    alias :red :reduce
    
    # See BinaryOp
    def initialize(l,r)
      super
    end
    
    # * **argument**:
    #   * Negative
    #   * BinaryOp and children
    #   * Variable
    #   * Math_Funct
    #   * Numeric
    #   * P_Infinity_Val
    #   * M_Infinity_Val
    # * **returns**: 
    #   * Children of BinaryOp
    #   * +nil+ if the operation can't be performed
    def +(obj)
      return nil unless (self.top) || (self == obj)
      return Number.new(2) * self if self == obj
      return Sum.new(self,obj)
    end
    
    # * **argument**:
    #   * Negative
    #   * BinaryOp and children
    #   * Variable
    #   * Math_Funct
    #   * Numeric
    #   * P_Infinity_Val
    #   * M_Infinity_Val
    # * **returns**: 
    #   * Children of BinaryOp
    #   * +nil+ if the operation can't be performed
    def -(obj)
      return nil unless (self.top) || (self == obj)
      return Number.new 0 if self == obj
      return Diff.new(self,obj).reduce
    end
    
    # * **argument**:
    #   * Negative
    #   * BinaryOp and children
    #   * Variable
    #   * Math_Funct
    #   * Numeric
    #   * P_Infinity_Val
    #   * M_Infinity_Val
    # * **returns**: 
    #   * Children of BinaryOp
    #   * +nil+ if the operation can't be performed
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
    
    # * **argument**:
    #   * Negative
    #   * BinaryOp and children
    #   * Variable
    #   * Math_Funct
    #   * Numeric
    #   * P_Infinity_Val
    #   * M_Infinity_Val
    # * **returns**: 
    #   * Children of BinaryOp
    #   * +nil+ if the operation can't be performed
    def **(obj)
      exp = self.right
      exp.top = true
      exp *= obj
      return Pow.new(self.right,exp).reduce
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
    
    # Tells whether obj is similar so self. That is: x^n =~ x^k
    def =~(obj)    
      return self.left == obj.left if obj.is_a? Pow
      return self.left == obj
    end
    
    # Simplifies the power:
    # * ∞^0             => raises an error
    # * 1^∞             => raises an error
    # * 0^y             => 0
    # * x^∞, 0 < x < 1  => 0
    # * x^-∞, 0 < x < 1 => ∞
    # * x^∞             => ∞
    # * x^-∞            => 0
    # * x ^ 0           => 1
    # * n ^ m, n m Numb.=> n ** m
    # * (-x) ^ 2*y      => x ^ 2y
    # * (-x) ^ y        => -(x^y)
    # * x ^ (-y)        => 1 / x ^ y
    # * x ^ 0           => 0
    def reduce
      self.red
      if self.right == 1
        self.left.top = self.top
        return self.left 
      end
      raise "Math Error: ∞^0" if (self.left == P_Infinity or self.left == M_Infinity) or (self.right == 0)
      raise "Math Error: 1^∞" if self.left == 1 and (self.right == P_Infinity or self.right == M_Infinity)
      if self.left.is_a? Number 
        return Number.new 0 if self.left.val > 0 and self.left.val < 1 and self.right == P_Infinity 
        return P_Infinity if self.left.val > 0 and self.left.val < 1 and self.right == M_Infinity
        return Number.new 0 if self.right == M_Infinity
        return P_Infinity if self.right == P_Infinity
        return Number.new 1 if self.right == 0
        return self.left ** self.right if self.right.is_a? Number
      end
      return self.left.val ** self.right if self.left.is_a? Negative and self.right.is_a? Number and self.right.even
      return Negative.new(self.left.val ** self.right) if self.left.is_a? Negative and self.right.is_a? Number and self.right.odd
      return Number.new(1) / (self.left ** self.right.val) if self.right.is_a? Negative
      return Number.new 0 if self.left == 0
      return self
    end
    
    # Inverts the sign of the class
    #
    # * **returns**: Negative or Prod
    def invert
      ret = Negative.new self
      ret.top = self.top
      return ret
    end
    
    # Performs the differential of a power:
    # d(x^y) = (x ^ y) * (d(y) * ln(x) + y * d(x)/x)
    #
    # * **argument**: variable according to the differential must be done
    # * **returns**: Children of BinaryOp or Function element
    def diff(var)
      return Number.new(0) unless self.depend? var
      lft, rht = self.left, self.right
      lft.top, rht.top = true, true
      d_lft = lft.diff(var)
      d_rht = rht.diff(var)
      if d_rht == 0
        return lft ** (rht - Number.new(1)) * rht * d_lft
      elsif d_lft == 0
        return (lft ** rht) * d_rht * Log.new(lft)
      else 
        return (lft ** rht) * (d_rht * Log.new(lft) + rht * d_lft / lft)
      end
    end
    
    # * **returns**: string representation of the class
    def to_s
      lft = (self.left.is_a? Sum or self.left.is_a? Diff) ? "(#{self.left.to_s})" : self.left.to_s
      rht = (self.right.is_a? Sum or self.right.is_a? Diff) ? "(#{self.right.to_s})" : self.right.to_s
      return "#{lft}^#{rht}"
    end
    
    # * **returns**: string representation of the class for a block
    def to_b
      lft = (self.left.is_a? Sum or self.left.is_a? Diff) ? "(#{self.left.to_b})" : self.left.to_b
      rht = (self.right.is_a? Sum or self.right.is_a? Diff) ? "(#{self.right.to_b})" : self.right.to_b
      return "#{lft}**#{rht}"
    end
    
  end

end





