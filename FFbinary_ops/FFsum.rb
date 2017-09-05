#! /usr/bin/env ruby

#require "pry-byebug"

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module Function

  ##
  # This class represents a sum between two algebric elements
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class Sum < BinaryOp
  
    alias :red :reduce 
  
    # Same of  BinaryOp
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
    # * **returns**: one of these
    #   * Negative
    #   * BinaryOp and children
    #   * Numeric  
    #   * Variable 
    #   * P_Infinity_Val
    #   * M_Infinity_Val
    #   * +nil+ if the operation can't be performed 
    def +(obj)
      if obj.is_a? Sum then
        return self + obj.left + obj.right
      elsif obj.is_a? Diff
        return self + obj.left - obj.right
      # elsif obj.is_a? BinaryOp 
      #  return nil unless self.top
      #  return Sum.new(self,obj).reduce   
      end
      lft = self.left + obj
      if !(lft == nil) then
        return Sum.new(lft,self.right).reduce
      else
        rht = self.right + obj
        if !(rht == nil) then
          Sum.new(self.left,rht).reduce
        else
          return nil unless self.top
          return Sum.new(self,obj).reduce
        end
      end
    end
    
    # * **argument**:
    #   * Negative
    #   * BinaryOp and children
    #   * Variable
    #   * Math_Funct
    #   * Numeric
    #   * P_Infinity_Val
    #   * M_Infinity_Val
    # * **returns**: one of these
    #   * Negative
    #   * BinaryOp and children
    #   * Numeric  
    #   * Variable
    #   * P_Infinity_Val
    #   * M_Infinity_Val 
    #   * +nil+ if the operation can't be performed
    def -(obj)
      unless !(obj.is_a? BinaryOp)
        if (obj.is_a? Sum) || (obj.is_a? Diff)
          obj = obj.invert
          return (self + obj).reduce
        # else
        #  return nil unless self.top
        #  return Diff.new(self,obj)
        end
      end
      lft = self.left - obj
      if !(lft == nil) then
        return Sum.new(lft,self.right).reduce
      else
        rht = self.right - obj
        if !(rht == nil) then
          return Sum.new(self.left,rht).reduce
        else
          return nil unless self.top
          return Diff.new(self,obj).reduce
        end
      end
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
    #   * Prod
    #   * +nil+ if the operation can't be performed
    def *(obj)
      return nil unless self.top
      return Prod.new(self,obj).reduce
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
    #   * Div
    #   * +nil+ if the operation can't be performed
    def /(obj)
      return nil unless self.top
      return Div.new(self,obj).reduce
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
    #   * Pow
    #   * +nil+ if the operation can't be performed
    def **(obj)
      return nil unless self.top
      return Pow.new(self,obj).reduce
    end
    
    # Calls reduce of BinaryOp and then simplifies the sum according to the cases:
    # * 0 + y    => y
    # * x + 0    => x
    # * x + x    => 2*x
    # * x + (-y) => x - y
    # * x + y    => x + y
    # * ∞ - ∞    => raises an error
    # * -∞ + ∞   => raises an error
    # * ∞ + ∞    => ∞
    # * -∞ + (-∞)=> -∞
    #
    # * **returns**: one of these
    #   * Variable
    #   * BinaryOp and children
    #   * Negative
    #   * Number
    #   * P_Infinity_Val
    #   * M_Infinity_Val
    def reduce
      self.red
      if (self.left == P_Infinity) && (self.right == P_Infinity)
        return P_Infinity
      elsif (self.left == M_Infinity) && (self.right == M_Infinity)
        return M_Infinity
      elsif ((self.left == P_Infinity) && (self.right == M_Infinity)) || 
            ((self.left == M_Infinity) && (self.right == P_Infinity))
        raise "Math Error: ∞-∞"
      elsif self.right == M_Infinity
        return Diff.new(self.left,P_Infinity).reduce
      elsif self.left == 0
        return self.right
      elsif self.right == 0
        return self.left
      elsif self.left == self.right
        return Prod.new(Number.new(2),self.left)
      elsif self.right.is_a? Negative
        return Diff.new(self.left,self.right.val)#.reduce
      else
        return self
      end
    end
    
    # Inverts all the signs
    # (x + y).invert = -x - y
    #
    # * **returns**: Diff
    def invert
      inv = Diff.new(self.left.invert,self.right).reduce
      inv.top = self.top
      return inv
    end
    
    # Calculates the differential
    #
    # * **argument**: variable according to the differential must be calculated
    # * **returns**: result of the differential
    def diff(var)
      return Number.new 0 unless self.depend? var
      lft = self.left.diff(var)
      rht = self.right.diff(var)
      return Sum.new(lft,rht).reduce
    end
    
    # * **returns**: string representation of the class
    def to_s
      return "#{self.left.to_s}+#{self.right.to_s}"
    end
    
    # * **returns**: string representation of a block
    def to_b
      return "#{self.left.to_b}+#{self.right.to_b}"
    end
    
  end
#binding.pry  
end













