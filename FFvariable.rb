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
      return false unless (obj.is_a? Variable) or (obj.is_a? Negative)
      return self == obj.val if obj.is_a? Negative
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
        self.top = false
        return Prod.new(2,self)
      else
        obj.top = false
        self.top = false
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
        # obj.top = false
        # self.top = false
        return (self + obj.val).reduce
      elsif self == obj then
        return 0
      else
        obj.top = false
        self.top = false
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
      return nil unless self.top
      if obj.is_a? BinaryOp then
        return (obj * self).reduce
      elsif obj.is_a? Negative then
        self.top = false
        return Negative.new(self * obj.val).reduce
      elsif self == obj
        self.top = false
        obj.top = false 
        return Pow.new(self,2)
      else
        self.top = false
        obj.top = false
        return Prod.new(self,obj)
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
      return nil unless self.top
      if obj.is_a? BinaryOp then
        self.top = false
        obj.top = false
        return Div.new(self,obj).reduce
      elsif obj.is_a? Negative then
        self.top = false
        return Negative.new(self,obj.val).reduce
      elsif self == obj then
        return 1
      else
        self.top = false
        obj.top = false
        return Div.new(self,obj)
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
    
    # Calculates the differential
    #
    # * **argument**: variable according to the differential must be calculated
    # * **returns**: result of the differential
    def diff(var)
      return 1 if self.depend? var
      return 0
    end
    
    # Inverts the sign of the variable
    #
    # * **returns**: new Negative
    def invert
      return Negative.new(self)
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




