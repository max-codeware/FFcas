#! /usr/bin/env ruby

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module Function

  ##
  # This class is the base for all the binary operations
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class BinaryOp
  
    # Creates a new object of a binary operation initializing 
    # the left and right side and top
    #
    # * **argument**: left side of the operation
    # * **argument**: right side of the operation
    def initialize(lft,rht)
      lft = lft.clone; rht = rht.clone
      lft.top = false
      rht.top = false
      self.left  = lft
      self.right = rht
      self.top = true
    end
    
    # * **returns**: left side of the operation
    def left
      return @left
    end
    
    # * **returns**: right side of the operation
    def right
      return @right
    end
    
    # Sets the value of the left side
    #
    # * **argument**: left side value
    def left=(obj)
      @left = obj
    end
    
    # Sets the value of the right side
    #
    # * **returns**: right side value
    def right=(obj)
      @right = obj
    end
    
    # Sets the position of the binary op: if top is true means that 
    # this binary op contains the top root
    #
    # * **argument**: boolean value
    def top=(val)
      @top = val
    end
    
    # * **returns**: top state (boolean value)
    def top
      return @top
    end  
    
    # Semplifies the left and right side
    #
    def reduce
      temp = self.left.clone
      self.left = self.left.reduce
      while temp != self.left do
        temp = self.left.clone
        self.left = self.left.reduce
      end
      temp = self.right.clone
      self.right = self.right.reduce
      while temp != self.left do
        temp = self.left.clone
        self.left = self.left.reduce
      end
      
      def ==(obj)
        return false unless self.class == obj.class
        return (self.left == obj.left) && (self.right == obj.right)
      end
    end
    
    # Tells if this binary op depends on a specific variable
    #
    # * **argument**: object to check for dependencies
    # * **returns**: +true+ if Negative depends on obj; +false+ else
    def depend?(obj)
      return false unless obj.is_a? Variable
      return true if self.left.depend? obj
      return self.right.depend? obj
    end
    
  end

  ##
  # This class is the base for all the math functions
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class Math_Funct
  
    # Creates a new base object for a math_function
    #
    # * **argument**: argument of the function
    def initialize(arg)
      arg.top = false
      self.arg = arg
      self.top = true
    end
    
    # Sets the argument of the math function
    def arg=(obj)
      @arg = obj
    end
    
    # * **returns**: argument of the function
    def arg
      return arg
    end
    
    # Sets the position of negative: if top is true means that negative
    # is not in a BinOp
    #
    # * **argument**: boolean value
    def top=(val)
      @top = val
    end
    
    # * **returns**: top state (boolean value)
    def top
      return @top
    end
    
    # Checks if obj equals tho the Function
    #
    # * **argument**: object for the comparison
    # * **returns**: +true+ if obj is the same funtion and has the same arguments;
    # +false+ else
    def ==(obj)
      return false unless self.class == obj.class
      return self.arg == obj.arg
    end
    
    def reduce
      self.arg = self.arg.reduce
    end
    
    def depend?(obj)
      return false unless obj.is_a? Variable
      return self.arg.depend? obj
    end
  end
  
  ##
  # This class represents a negative value (-x)
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class Negative
    
    # Creates a new `Negative` objects
    #
    # * **argument**:
    #   * Variable
    #   * Math_Funct
    #   * Numeric
    #   * Costant
    #   * BinaryOp and children
    def initialize(val)
      val.top = false
      @val = val
      self.top = true
    end
    
    # * **returns**: value (eg. -x = Negative(x) => x)
    def val
      return @val
    end
    
    # Sets the position of negative: if top is true means that negative
    # is not in a BinOp
    #
    # * **argument**: boolean value
    def top=(val)
      @top = false
    end
    
    # * **returns**: top state (boolean value)
    def top
      return @top
    end
    
    # Semplifies itself
    #
    # * **returns**:
    #   * BinaryOp if val is a binary operation
    #   * 0 if val is 0
    #   * Negative if there's nothing to change
    def reduce
      @val = self.val.reduce
      if self.val.is_a? BinaryOp then
        return self.val.invert
      elsif self.val == 0
        return Number.new 0
      elsif self.val.is_a? Negative
        return self.val.val.reduce
      else
        val = @val
        @val = @val.reduce
        while val != @val
          val = @val
          @val = @val.reduce
        end  
        return self
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
    def +(obj)
      if not self.top then
        return nil unless self.depend? obj      
      end
      if obj.is_a? Negative then
        if self.val == obj.val
          return Negative.new((self.val + obj.val))
        else
          self.top = false
          return Diff.new(self,obj.val)
        end
      elsif obj.is_a? BinaryOp then
        return (obj - self.val).reduce
      elsif self.val == obj
        return Number.new 0
      else
        obj.top = false
        return Diff.new(obj,self.val)
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
      if obj.is_a? Negative then
        return (self + obj.val).reduce
      elsif obj.is_a? BinaryOp
        return (obj.invert - self.val).reduce
      elsif self.val == obj
        return Negative.new(self.val + obj)
      else
        self.top = false
        obj.top = false
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
      if not self.top then
        return nil unless self.depend? obj      
      end
      if obj.is_a? Negative then
        return (self.val * obj.val).reduce
      elsif obj.is_a? BinaryOp then
        return (obj * self.val).invert.reduce
      elsif self.val == obj
        return Negative.new(self.val * obj).reduce
      else
        self.top = false
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
      if not self.top then
        return nil unless self.depend? obj      
      end
      if obj.is_a? Negative then
        return (self.val / obj.val).reduce
      elsif obj.is_a? BinaryOp then
        return Negative.new(self.val / obj).reduce
      elsif self.val == obj then
        return Negative.new(Number.new(1))
      else
        self.top = false
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
      if not self.top then
        return nil unless self.depend? obj      
      end
      if obj.is_a? Numeric then
        return (self.val ** obj).reduce if obj.even
        return Negative.new(self.val ** obj)
      else
        self.top = false
        return Pow.new(self,obj)
      end
    end
    
    # * **returns**: Negative class in string format
    def to_s
      if self.val.is_a? Pow then
        left =  "(-#{self.val.left.to_s})"
        right = (self.val.right.is_a? Numeric) ? (self.val.right.to_s) : ("(#{self.val.right.to_s})")
        return "#{left}^#{right}"
      elsif self.val.is_a? BinaryOp then
        return "-(#{self.val.to_s})"
      else
        return "-#{self.val.to_s}"
      end
    end
    
    # * **returns**: Negative class in block format (string)
    def to_b
      if self.val.is_a? Pow then
        left =  "(-#{self.val.left.to_b})"
        right = (self.val.right.is_a? Numeric) ? (self.val.right.to_b) : ("(#{self.val.right.to_b})")
        return "#{left}**#{right}"
      elsif self.val.is_a? BinaryOp then
        return "-(#{self.val.to_b})"
      else
        return "-#{self.val.to_b}"
      end
    end
    
    # Tells if Negative depends on a specific variable
    #
    # * **argument**: object to check for dependencies
    # * **returns**: +true+ if Negative depends on obj; +false+ else
    def depend?(obj)
      return false unless (obj.is_a? Variable) or (obj.is_a? Negative)
      return self.val.depend? obj unless (obj.is_a? Negative)
      return self.val.depend? obj.val
    end
    
    # Calculates the differential
    #
    # * **argument**: variable according to the differential must be calculated
    # * **returns**: result of the differential
    def diff(var)
      if self.depend? var
        diff = Negative.new(self.arg.diff(var).reduce) 
        diff.top = false
        return diff
      else
        return Number.new 0
      end
    end
    
    # Inverts the sign, that is -x => x
    #
    # * **returns**: self.arg
    def invert
      return self.arg
    end
    
    # Verifies if two negatives have the same value
    #
    # * **argument**: object for the comparison
    # * **returns**: +true+ if the values are equal; +false+ else
    def ==(obj)
      return false unless obj.is_a? Negative
      return self.val == obj.val
    end
  end
end




















