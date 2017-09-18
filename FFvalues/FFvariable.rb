#! /usr/bin/env ruby

# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module Function

  ##
  # This class provides a representation for a math variable
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class Variable < String
 
    def initialize(name)
      super
      self.top = true
    end
    
    # Sets the position of variable: if top is true means that variable
    # is a child
    #
    # * **argument**: boolean value
    def top=(val)
      @top = val
    end
    
    # * **returns**: top state (boolean value)
    def top
      return @top
    end
    
    # Tells if Variable depends on a specific one (if self == variable)
    #
    # * **argument**: object to check for dependencies
    # * **returns**: +true+ if Negative depends on obj; +false+ else
    def depend?(obj)
      return false unless obj.is_a? Variable
      return self == obj
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
    def +(obj)
      if not self.top then
        return nil unless self.depend? obj
      end
      if obj.is_a? BinaryOp then
        return (obj + self).reduce
      elsif obj.is_a? Negative then
        # obj.top = false
        # self.top = false
        return (self - obj.val).reduce
      elsif self == obj then
        # self.top = false
        return Prod.new(Number.new(2),self)
      else
        # obj.top = false
        # self.top = false
        return Sum.new(self,obj)
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
    def -(obj)
      if not self.top then
        return nil unless self.depend? obj
      end
      if obj.is_a? BinaryOp then
        obj = obj.invert
        return (self + obj).reduce
      elsif obj.is_a? Negative then
        return (self + obj.val).reduce
      elsif self == obj then
        return Number.new 0
      else
        return Diff.new(self,obj)
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
    def *(obj)
      return nil unless self.top or self == obj
      if obj.is_a? BinaryOp then
        return (obj * self).reduce
      elsif obj.is_a? Negative then
        return Negative.new(self * obj.val).reduce
      elsif self == obj
        return Pow.new(self,Number.new(2))
      else
        return Prod.new(self,obj) unless obj.is_a? Number
        return Prod.new(obj,self)
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
    def /(obj)
      return nil unless self.top or self == obj
      if obj.is_a? Negative then
        return Negative.new(self / obj.val).reduce
      elsif self == obj then
        return Number.new 1
      else
        return Div.new(self,obj).reduce
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
    def **(obj)
      return nil unless self.top
      return Pow.new(self,obj)
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
    
    # Calculates the differential
    #
    # * **argument**: variable according to the differential must be calculated
    # * **returns**: result of the differential
    def diff(var)
      return Number.new 1 if self.depend? var
      return Number.new 0
    end
    
    # Inverts the sign of the variable
    #
    # * **returns**: new Negative
    def invert
      inv = Negative.new(self)
      inv.top = self.top
      return inv
    end
    
    # Tells if the variable is similar to another object (eg. x =~ x^2)
    #
    # * **argument**: object for the comparison
    # * **returns**: +true+ if obj == self or obj is a power of self; +false+ else.
    def =~(obj)
      if obj.is_a? Pow
        return true if self == obj.left
      end
      return self == obj
    end
    
    # * **returns**: self
    def reduce
      return self
    end
    
    # * **returns**: variable to block (self)
    def to_b
      return self
    end
    
  end
end




