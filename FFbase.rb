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
    # the left and right side
    #
    # * **argument**: left side of the operation
    # * **argument**: right side of the operation
    def initialize(left,right)
      @left  = left
      @right = right
    end
    
    # * **returns**: left side of the operation
    def left
      return @left
    end
    
    # * **returns**: right side of the operation
    def right
      return @right
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
      @arg = arg
      self.top = true
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
      @top = false
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
      @arg = self.arg.reduce
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
      if self.val.is_a? BinaryOp then
        return self.val.invert
      elsif @val == 0
        return 0
      else
        @val = @val.reduce
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
        return 0
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
        return Negative.new(1)
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
      if self.val.is_a? Power then
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
      if self.val.is_a? Power then
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
        return 0
      end
    end
    
  end
end




















