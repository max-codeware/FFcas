#! /usr/bin/env ruby

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module Function

  class Constant
    
    def initialize
      self.top = false
    end
    
    def val
      return @val
    end
  
    def top=(val)
      @top = val
    end
    
    def top
      return @top
    end
    
    def +(obj)
      return nil unless self.top or (self.class == obj.class)
      return obj + self if obj.is_a? BinaryOp
      return Sum.new(self,obj).reduce unless self.class == obj.class
      return Prod.new(2,self)
    end
    
    def -(obj)
      return nil unless self.top or (self.class == obj.class)
      return obj - self if obj.is_a? BinaryOp
      return Diff.new(self,obj).reduce unless self.class == obj.class
      return Number.new 0
    end
    
    def *(obj)
      return nil unless self.top or (self.class == obj.class)
      # return obj * self if obj.is_a? BinaryOp
      return Prod.new(self,obj).reduce unless self.class == obj.class
      return Pow.new(self,2)
    end
    
    def /(obj)
      return nil unless self.top or (self.class == obj.class)
      # return obj / self if obj.is_a? BinaryOp
      return Div.new(self,obj).reduce unless self.class == obj.class
      return Number.new 1
    end
    
    def **(obj)
      return nil unless self.top or (self.class == obj.class)
      # return obj / self if obj.is_a? BinaryOp
      return Pow.new(self,obj).reduce unless self.class == obj.class
      return Pow.new(self,2)
    end
    
    def reduce
      return self
    end
    
    def ==(obj)
      return false unless self.class = obj.class
    end
    
    def diff(var)
      return Number.new 0
    end
    
    def invert
      return Negative.new self
    end
    
  end
  
  class E < Constant
  
    alias :prod  :*
    alias :power :**
  
    def initialize
      super
      @val = Math::E
    end
    
    def *(obj)
      return self.prod unless self.class == obj.class
      return Exp.new(2)
    end
    
    def **(obj)
      return self.power obj unless self.class == obj.class
      return Exp.new(obj).reduce
    end
  
    def to_s
      return "e"
    end
    
    def to_b
      return "Math::E"
    end
    
  end
  
  class PI < Constant
  
    def initialize
      super
      @val = Math::PI
    end
  
    def to_s
      return "π"
    end
    
    def to_b
      return "Math::PI"
    end
  
  end
  
  class P_Infinity_Val < Constant
  
    def initialize
      super
      @val = 1/0.0
    end
    
    def +(obj)
      raise "Math Error: #{self.to_s}#{obj.to_s}" if obj.is_a? M_Infinity_Val
      return self - obj.val if obj.is_a? Negative
      return self
    end
    
    def -(obj)
      raise "Math Error: #{self.to_s}#{self.to_s}" if obj.is_a? P_Infinity_Val
      unless obj.is_a? Negative
        return self + M_Infinity if obj.val.is_a? P_Infinity_val
        return self + obj.val
      return self 
    end
    
    def *(obj)
      return Negative.new(self * obj.val).reduce if obj.is_a? Negative
      return self 
    end
    
    def /(obj)
      raise "Math Error: ∞/∞" if obj.is_a? P_Infinity_Val
      return Negative.new(self / obj.val).reduce if obj.is_a? Negative
      return self 
    end
    
    def **(obj)
      raise "Math Error: ∞^0"
      return Number.new 0 if obj.is_a? Negative
      return self
    end
    
    def invert
      return M_Infinity
    end
  
    def to_s
      return "∞"
    end
    
    def to_b
      return "1/0.0"
    end
    
  end
  
  P_Infinity = P.Infinity_Val.new
  
  class M_Infinity_Val < P_Infinity_Val
  
    def initialize
      self.top = true
      @val = -1/0.0
    end
    
    def +(obj)
      return obj - P_Infinity
    end
    
    def -(obj)
      raise "Math Error: -∞+∞" if obj.is_a? M_infinity_Val
      return M_Infinity
    end
    
    def *
      
    end
    
    def invert
      return P_Infinity
    end
  
    def to_s
      return "-∞"
    end
    
    def to_b
      return "-1/0.0"
    end
       
  end
  
  M_Infinity = M_Infinity_Val

end
