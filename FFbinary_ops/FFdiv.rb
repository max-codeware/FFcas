#! /usr/bin/env ruby

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module Function

  class Div < BinaryOp
  
    alias :red :reduce
    
    # See BinaryOp
    def initialize(l,r)
      super
    end
    
    def +(obj)
      return nil unless (self.top) || (self =~ obj) || (self == obj)
      if self == obj
        lft = self.left
        lft.top = true
        lft *= Number.new 2
        return Div.new(lft,self.right).reduce
      end
      if self =~ obj
        if obj.is_a? Div
          lft = self.left
          lft.top = true
          lft += obj.left if obj.is_a? BinaryOp
          lft += obj unless obj.is_a? BinaryOp
          return Div.new(lft,self.right).reduce
        else
          lft,rht = self.left, self.right
          lft.top, rht.top = true, true
          lft += rht * obj
          return Div.new(lft,self.right).reduce
        end
      end
      return Sum.new(self,obj)
    end
    
    def -(obj)
      return nil unless (self.top) || (self =~ obj) || (self == obj)
      return Number.new 0 if self == obj
      if self =~ obj
        if obj.is_a? Div
          lft = self.left
          lft.top = true
          lft -= obj.left if obj.is_a? BinaryOp
          lft -= obj unless obj.is_a? BinaryOp
          return Div.new(lft,self.right).reduce
        else
          lft,rht = self.left, self.right
          lft.top, rht.top = true, true
          lft -= rht * obj
          return Div.new(lft,self.right).reduce
        end
      end
      return Diff.new(self,obj).reduce
    end
    
    def *(obj)
      return nil unless (self.top) || (self =~ obj) || (self == obj) || (obj.is_a? Constant) || (obj.is_a? Number)
      return Pow.new(self,Number.new(2)) if self == obj
      if self =~ obj
        if obj.is_a? Div
          lft = self.left
          lft.top = true
          lft *= obj.left if obj.is_a? BinaryOp
          lft *= obj unless obj.is_a? BinaryOp
          rreturn Div.new(lft,Pow.new(self.right,Number.new(2)))
        else
          lft = self.left
          lft.top = true
          lft *= obj
          return Div.new(lft,self.right).reduce
        end
      end
      if (obj.is_a? Constant) || (obj.is_a? Number)
        lft = self.left * obj
        if lft != nil
          return Div.new(lft,self.right)
        else
          rht = self.right * obj
          if rht != nil
            return Div.new(self.left,rht)
          else
            return nil unless self.top
          end
        end
      end
      return Prod.new(self,obj) unless obj.is_a? Number
      return Prod.new(obj,self)
    end
    
    def /(obj)
      if obj.is_a? Div
        return self * Div.new(obj.right,obj.left).reduce
      else
        return self * (Number.new(1) / obj)
      end
    end
    
    def **(obj)
      return nil unless self.top
      return Pow.new(self,obj).reduce
    end
    
    def =~(obj)
      return self.left == obj.left if obj.is_a? Div
      return self.left == obj
    end
    
    def reduce
      self.red
      return Number.new 0 if self.left == 0
      return Negative.new(Div.new(self.left.val,self.right)).reduce if self.left.is_a? Negative
      return Negative.new(Div.new(self.left,self.right.val)).reduce if self.right.is_a? Negative
      return self.left if self.right == 1
      return P_Infinity if self.right == 0
      return self
    end
    
    def invert
      ret = Negative.new(self).reduce
      ret.top = self.top
      return ret
    end
    
    def diff(var)
      lft, rht = self.left, self.right
      lft.top, rht.top = true, true
      d_lft = lft.diff(var) * rht
      d_rht = lft * rht.diff(var)
      rht **= Number.new(2)
      return Div.new(d_lft - d_rht, rht).reduce
    end
    
    def to_s
      lft = (self.left.is_a? Sum or self.left.is_a? Diff) ? "(#{self.left.to_s})" : self.left.to_s
      rht = (self.right.is_a? Sum or self.right.is_a? Diff) ? "(#{self.right.to_s})" : self.right.to_s
      return "#{lft}/#{rht}"
    end
    
    def to_b
      lft = (self.left.is_a? Sum or self.left.is_a? Diff) ? "(#{self.left.to_b})" : self.left.to_b
      lft = (self.right.is_a? Sum or self.right.is_a? Diff) ? "(#{self.right.to_b})" : self.right.to_b
      return "#{lft}/#{rht}"
    end
      
  end

end










