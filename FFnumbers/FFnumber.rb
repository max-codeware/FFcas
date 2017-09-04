#! /usr/bin/env ruby

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module Function
  
  class Number
    
    def initialize(val)
      @val = val
      self.top = true
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
      return nil unless (self.top) || (obj.is_a? Number) || (obj.is_a? Negative and obj.val.is_a? Number)
      return Number.new(self.val + obj.val) if obj.is_a? Number
      return self - obj.val if obj.is_a? Negative
      return obj + self  if obj.is_a? BinaryOp
      return Sum.new(obj,self) 
    end
    
    def -(obj)
      return nil unless (self.top) || (obj.is_a? Number)
      if obj.is_a? Number
        if self.val > obj.val
          return Number.new(self.val - obj.val) 
        else
          return Negative.new(obj - self) 
        end
      end
      if obj.is_a? BinaryOp
        obj = obj.invert
        return self + obj
      end
      return Number.new(self.val + obj.val) if obj.is_a? Negative
      return Diff.new(obj.invert,self)       
    end
    
    def *(obj)
      return nil unless (self.top) || (obj.is_a? Number)
      return Number.new(self.val * obj.val) if obj.is_a? Number
      return obj * self if obj.is_a? BinaruOp
      return Negative.new(self * obj.val) if obj.is_a? Negative
      return Prod.new(obj,self) 
    end
    
    def /(obj)
      return nil unless (self.top) || (obj.is_a? Number)
      return Negative.new(Div.new(self,obj.val)) if obj.is_a? Negative
      return Div.new(self,obj)
    end
    
    def **(obj)
      return nil unless (self.top) || (obj.is_a? Number)
      return Number.new(self.val ** obj.val) if obj.is_a? Number
      return Pow.new(self,obj)
    end
    
    def invert
      return Negative.new self
    end
    
    def reduce
      return self
    end
    
    def diff(var)
      return Number.new 0
    end
    
    def ==(obj)
      return false unless (obj.is_a? Number) || (obj.is_a? Numeric)
      return self.val == obj if obj.is_a? Numeric
      return self.val == obj.val
    end
    
    def depend?(obj)
      return false
    end
    
    def to_s
      return val.to_s
    end
    
    def to_b
      return val
    end
    
  end

end







