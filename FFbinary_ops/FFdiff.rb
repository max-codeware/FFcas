#! /usr/bin/env ruby

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module Function

  ##
  # This class represents a difference between two algebric elements
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class Diff < BinaryOp
  
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
    # * **returns**:
    #   * Negative
    #   * BinaryOp and children
    #   * Numeric  
    #   * Variable 
    #   * +nil+ if the operation can't be performed 
    def +(obj)
      if obj.is_a? Sum then
        return elf + obj.left + self + obj.right
      elsif obj.is_a? Diff then
        obj = obj.invert
        return self + obj
      end
      lft = self.left + obj
      if !(lft == nil) then
        return Diff.new(lft,self.right).reduce
      else
        rht = self.right.invert + obj
        if !(rht == nil)
          return Diff.new(self.left,rht).reduce
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
    # * **returns**:
    #   * Negative
    #   * BinaryOp and children
    #   * Numeric  
    #   * Variable 
    #   * +nil+ if the operation can't be performed 
    def -(obj)
      if (obj.is_a? Sum) || (obj.is_a? Diff) then
        obj = obj.invert
        return self + obj       
      end
      lft = self.left - obj
      if !(lft == nil) then
        return Diff.new(lft,self.right).reduce
      else
        rht = self.right - obj
        if !(rht == nil) then
          return Diff.new(self.left,rht).reduce
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
    # * **returns**:
    #   * Pow
    #   * +nil+ if the operation can't be performed 
    def **(obj)
      return nil unless self.top
      return Pow.new(self,obj).reduce
    end
    
    # Calls reduce of BinaryOp and then simplifies the sum according to the cases:
    # * 0 - y    => -y
    # * x - 0    => x
    # * x - x    => 0
    # * x - (-y) => x + y
    # * x - y    => x - y
    #
    # * **returns**:
    #   * Variable
    #   * BinaryOp and children
    #   * Negative
    #   * Number
    def reduce
      self.red
      if self.left == 0
        return Negative.new(self.right).reduce
      elsif self.right == 0
        return self.left.reduce
      elsif self.right.is_a? Negative
        return Sum.new(self.left,self.right.val).reduce
      elsif self.left == self.right
        return Number.new 0
      else
        return self
      end
    end
    
    # Inverts all the signs
    # (x-y).invert = -x+y
    #
    # * **returns**: Sum
    def invert
      return Sum.new(self.left.invert,self.right).reduce
    end
    
    # Calculates the differential
    #
    # * **argument**: variable according to the differential must be calculated
    # * **returns**: result of the differential
    def diff(var)
      return Number.new 0 unless self.depend? var
      lft = self.left.diff(var)
      rht = self.right.diff(var)
      return Diff.new(lft,rht).reduce
    end
    
    # * **returns**: string representation of the class
    def to_s
      return "#{self.left.to_s}-#{self.right.to_s}"
    end
    
    # * **returns**: string representation of a block
    def to_b
      return "#{self.left.to_b}-#{self.right.to_b}"
    end
  
  end
 
end
