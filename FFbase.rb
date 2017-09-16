#! /usr/bin/env ruby

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module Function

  ##
  # This class is the base for all the elements of Function
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class Base
    
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
    
  end

  ##
  # This class is the base for all the binary operations
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class BinaryOp < Base
  
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
    
    # Simplifies the left and right side
    def reduce
      temp = self.left.clone
      self.left = self.left.reduce
      while temp != self.left do
        temp = self.left.clone
        self.left = self.left.reduce
      end
      temp = self.right.clone
      self.right = self.right.reduce
      while temp != self.right do
        temp = self.right.clone
        self.right = self.right.reduce
      end
    end
    
    # Verifies if two binary ops are equal, that is both belong to
    # the same class and they have equal arguments (left and right side)
    #
    # * **argument**: object for the comparison
    # * **returns**: +true+ if the values are equal; +false+ else
    def ==(obj)
      return false unless self.class == obj.class
      return (self.left == obj.left) && (self.right == obj.right)
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
  class Math_Funct < Base
  
    # Creates a new base object for a math_function
    #
    # * **argument**: argument of the function
    def initialize(arg)
      arg = arg.clone
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
      return @arg
    end
    
    def +(obj)
      return nil unless self.top or self == obj
      return Prod.new(Number.new(2)) if self == obj
      return Sum.new(self,obj)
    end
    
    def -(obj)
      return nil unless self.top or self == obj
      return Number.new 0 if self == obj
      return Diff.new(self,obj)
    end
    
    def *(obj)
      return nil unless self.top or self == obj
      return Pow.new(self,Number.new(2)).reduce if self == obj
      return  Prod.new(self,obj).reduce unless obj.is_a? Number
      return Prod.new(obj,self).reduce
    end
    
    def /(obj)
      return nil unless self.top or self == obj
      return Number.new 1 if self == obj
      return Div.new(self,obj).reduce
    end
    
    def **(obj)
      return nil unless self.top or self == obj
      return Pow.new(self,obj)
    end
    
    # Inmplementation of unary plus
    #
    # * **returns**: self
    def +@
      return self
    end
    
    # Inmplementation of unary minus
    #
    # * **returns**: new Negative (arg -> self)
    def -@
      return self.invert
    end
    
    # Checks if obj equals to the Function
    #
    # * **argument**: object for the comparison
    # * **returns**: +true+ if obj is the same funtion and has the same arguments;
    # +false+ else
    def ==(obj)
      return false unless self.class == obj.class
      return self.arg == obj.arg
    end
    
    # Simplifies the left and right side
    #
    def reduce
      self.arg = self.arg.reduce
      return self
    end
    
    # Inverts the sign of the function
    #
    # * **returns**: new Negative
    def invert
      inv = Negative.new(self)
      inv.top = self.top
      return inv
    end
    
    # Tells if the current function depends on a specific variable
    #
    # * **argument**: object to check for dependencies
    # * **returns**: +true+ if Negative depends on obj; +false+ else
    def depend?(obj)
      return false unless obj.is_a? Variable
      return self.arg.depend? obj
    end
  end
  
end




















