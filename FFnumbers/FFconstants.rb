#! /usr/bin/env ruby

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module Function

  ##
  # This class represents a general constant with the common behaviour
  # of costants
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class Constant < Base
    
    # Creates a new constant object setting top to +true+
    def initialize
      self.top = true
    end
    
    # * **returns* @val
    def val
      return @val
    end
    
    # * **argument**: one of these
    #   * Number
    #   * Children of BinaryOp
    #   * Negative
    #   * Children of Constant
    #   * Variable
    #   * Children of Math_Funct
    # * **returns**: one of these
    #   * +nil+ if the operation can't be performed
    #   * Children of BinaryOp
    #   * Children of Constant
    def +(obj)
      return nil unless self.top or (self.class == obj.class)
      return P_Infinity if obj == P_Infinity
      return M_Infinity if obj == M_Infinity
      return obj + self if obj.is_a? BinaryOp
      return Sum.new(self,obj).reduce unless self.class == obj.class
      return Prod.new(Number.new(2),self)
    end
    
    # * **argument**: one of these
    #   * Number
    #   * Children of BinaryOp
    #   * Negative
    #   * Children of Constant
    #   * Variable
    #   * Children of Math_Funct
    # * **returns**: one of these
    #   * +nil+ if the operation can't be performed
    #   * Children of BinaryOp
    #   * Children of Constant
    #   * Number
    def -(obj)
      return nil unless self.top or (self.class == obj.class)
      return P_Infinity if obj == M_Infinity
      return M_Infinity if obj == P_Infinity
      return obj.invert - self if obj.is_a? BinaryOp
      return Diff.new(self,obj).reduce unless self.class == obj.class
      return Number.new 0
    end
    
    # * **argument**: one of these
    #   * Number
    #   * Children of BinaryOp
    #   * Negative
    #   * Children of Constant
    #   * Variable
    #   * Children of Math_Funct
    # * **returns**: one of these
    #   * +nil+ if the operation can't be performed
    #   * Children of BinaryOp
    #   * Children of Constant
    def *(obj)
      return nil unless self.top or (self.class == obj.class)
      # return obj * self if obj.is_a? BinaryOp
      return P_Infinity if obj == P_Infinity
      return M_Infinity if obj == M_Infinity
      return Prod.new(self,obj).reduce unless self.class == obj.class
      return Pow.new(self,Number.new(2))
    end
    
    # * **argument**: one of these
    #   * Number
    #   * Children of BinaryOp
    #   * Negative
    #   * Children of Constant
    #   * Variable
    #   * Children of Math_Funct
    # * **returns**: one of these
    #   * +nil+ if the operation can't be performed
    #   * Children of BinaryOp
    #   * Children of Constant
    #   * Number
    def /(obj)
      return nil unless self.top or (self.class == obj.class)
      # return obj / self if obj.is_a? BinaryOp
      return Number.new 0 if (obj == P_Infinity) || (obj == M_Infinity)
      return Div.new(self,obj).reduce unless self.class == obj.class
      return Number.new 1
    end
    
    # * **argument**: one of these
    #   * Number
    #   * Children of BinaryOp
    #   * Negative
    #   * Children of Constant
    #   * Variable
    #   * Children of Math_Funct
    # * **returns**: one of these
    #   * +nil+ if the operation can't be performed
    #   * Children of BinaryOp
    #   * Children of Constant
    #   * Number
    def **(obj)
      return nil unless self.top or (self.class == obj.class)
      # return obj / self if obj.is_a? BinaryOp
      return P_Infinity if obj == P_Infinity
      return Number.new 0 if obj == M_Infinity
      return Number.new 1 if obj == 0
      return Pow.new(self,obj).reduce unless self.class == obj.class
      return Pow.new(self,Number.new(2))
    end
    
    # Reduce is adummy method for a constant, as it returns always self
    #
    # * **returns**: self
    def reduce
      return self
    end
    
    # Compares self with another object
    #
    # * **argument**: object for the comparison
    # * **returns**: +true+ if the object has the same class of self; +false+ else
    def ==(obj)
      return self.class == obj.class
    end
    
    # Returns the differential of a constant
    #
    # * **argument** unused argument
    # * **returns**: Number 0
    def diff(var)
      return Number.new 0
    end
    
    # Inverts the sign of the constant
    #
    # * **returns**: Negative of self
    def invert
      inv = Negative.new self
      inv.top = self.top
      return inv
    end
    
    # It's a dummy method for a constant since it does not depend
    # on a variable, so it returns always +false+
    #
    # * **returns**: +false+
    def depend?(var)
      return false
    end
    
  end
  
  ##
  # This class represents the constant e
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class Const_E < Constant
  
    alias :prod  :*
    alias :power :**
    
    # Same of Constant and sets @val to Math::E
    def initialize
      super
      @val = Math::E
    end
    
    # Overload of Constant method. Executes the father one unless obj
    # belongs to the same class of self.
    #
    # * **argument**: one of these
    #   * Number
    #   * Children of BinaryOp
    #   * Negative
    #   * Children of Constant
    #   * Variable
    #   * Children of Math_Funct
    # * **returns**: Exp if obj and self belong to the same class. See Constant else
    def *(obj)
      return self.prod obj unless self.class == obj.class
      return Exp.new(Number.new(2))
    end
    
    # Overload of Constant method. Executes the father one unless obj
    # belongs to the same class of self.
    #
    # * **argument**: one of these
    #   * Number
    #   * Children of BinaryOp
    #   * Negative
    #   * Children of Constant
    #   * Variable
    #   * Children of Math_Funct
    # * **returns**: Exp if obj and self belong to the same class. See Constant else
    def **(obj)
      return self.power obj unless self.class == obj.class
      return Exp.new(obj).reduce
    end
  
    # * **returns**: string representing the constant 
    def to_s
      return "e"
    end
    
    # * **returns**: String representing the constant in ruby language
    def to_b
      return "Math::E"
    end
    
  end
  
  E = Const_E.new
  
  ##
  # This class represents the constant PI
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class Const_PI < Constant
  
    # Same of Constant and sets @val to Math::PI
    def initialize
      super
      @val = Math::PI
    end
    
    # * **returns**: string representing the constant 
    def to_s
      return "π"
    end
    
    # * **returns**: String representing the constant in ruby language
    def to_b
      return "Math::PI"
    end
  
  end
  
  PI = Const_PI.new
  
  ##
  # This class represent positive infinity
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class P_Infinity_Val < Constant
  
    # Same of Constant and sets @val to 1/0.0
    def initialize
      super
      @val = 1/0.0
    end
    
    # Overload of Constant method 
    #
    # * **returns**: P_Infinity; Raises an error if ∞-∞
    def +(obj)
      raise "Math Error: #{self.to_s}#{obj.to_s}" if obj == M_Infinity
      return self - obj.val if obj.is_a? Negative
      return self
    end
    
    # Overload of Constant method 
    #
    # * **returns**: P_Infinity; Raises an error if ∞-∞
    def -(obj)
      raise "Math Error: #{self.to_s}#{self.to_s}" if obj == P_Infinity
      unless obj.is_a? Negative
        return self + M_Infinity if obj == P_Infinity
        return self + obj.val
      end
      return P_Infinity 
    end
    
    # Overload of Constant method 
    #
    # * **returns**: M_Infinity if obj is a Negative; P_Infinity else
    def *(obj)
      return Negative.new(self * obj.val).reduce if obj.is_a? Negative
      return self 
    end
    
    # Overload of Constant method 
    #
    # * **returns**: Negative if obj is a Negative; P_Infinity else.
    # Raises an error if ∞/∞
    def /(obj)
      raise "Math Error: ∞/∞" if (obj == P_Infinity) || (obj == M_Infinity)
      return Negative.new(self / obj.val).reduce if obj.is_a? Negative
      return P_Infinity
    end
    
    ## Oferload of Constant method
    #
    # * **returns**: Number 0 if obj is a Negative or M_Infinity;
    # Raises an error if ∞^0
    def **(obj)
      raise "Math Error: ∞^0" if obj == 0
      return Number.new 0 if (obj.is_a? Negative) || (obj == M_Infinity)
      return P_Infinity
    end
    
    # Inverts the sign of P_Infinity
    #
    # * **returns**: M_Infinity
    def invert
      inv = M_Infinity
      inv.top = self.top
      return inv
    end
  
    # * **returns**: string representation of infinity
    def to_s
      return "∞"
    end
    
    # * **returns**: Numeric representation of infinity
    def to_b
      return "1/0.0"
    end
    
  end
  
  P_Infinity = P_Infinity_Val.new
  
  ##
  # This class represent minus infinity
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class M_Infinity_Val < Constant
  
    # Same of Constant and sets @val to 1/0.0
    def initialize
      super
      @val = -1/0.0
    end
    
    # Overload of Constant method 
    #
    # * **returns**: M_Infinity; Raises an error if ∞-∞
    def +(obj)
      raise "Math Error: ∞-∞" if obj == P_Infinity
      return Sum.new(self,obj).reduce if (obj.is_a? Math_Funct) || (obj.is_a? Variable) 
      return M_Infinity 
    end
    
    # Overload of Constant method 
    #
    # * **returns**: M_Infinity; Raises an error if ∞-∞
    def -(obj)
      raise "Math Error: -∞+∞" if obj == M_infinity
      return M_Infinity
    end
    
    # Overload of Constant method 
    #
    # * **returns**: P_Infinity if obj is M_Infinity; M_INfinity else; 
    # Raises an error if ∞*0
    def *(obj)
      raise "Math Error: ∞*0" if obj == 0
      return P_Infinity if obj == M_Infinity
      return M_Infinity
    end
    
    # Overload of Constant method 
    #
    # * **returns**: P_Infinity if obj is a Negative; M_Infinity else;
    # Raises an error if ∞/∞
    def /(obj)
      raise "Math Error: ∞/∞" if (obj == P_Infinity) || (obj == M_Infinity)
      return P_infinity if obj.is_a? Negative
      return M_infinity
    end
    
    # Overload of Constant method 
    #
    # * **returns**: 
    #   * P_Infinity if obj is a even Number or if obj is P_Infinity;
    #   * Number 0 if obj is a Negative or M_Infinity;
    #   * M_Infinity else
    #   * Raises an error if ∞^0
    def **(obj)
      raise "Math Error: ∞^0" if obj == 0
      return Number.new 0 if (obj.is_a? Negative) || (obj == M_Infinity)   
      return P_Infinity if (obj.is_a? Number and obj.val.even?) || (obj == P_Infinity)
      return M_Infinity
    end
    
    # Inverts the sign of P_Infinity
    #
    # * **returns**: P_Infinity
    def invert
      inv = P_Infinity
      inv.top = self.top
      return inv
    end
  
    # * **returns**: string representation of minus infinity
    def to_s
      return "-∞"
    end
    
    # * **returns**: Numeric representation of minus infinity
    def to_b
      return "-1/0.0"
    end
       
  end
  
  M_Infinity = M_Infinity_Val.new

end
