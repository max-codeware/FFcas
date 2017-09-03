#! /usr/bin/env ruby

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module Function

  class Sum < BinaryOp
  
    def initialize(l,r)
      super
    end
        
    def +(obj)
      obj.top = false
      if obj.is_a? Sum then
        op = self + obj.left + obj.right
        return op
      elsif obj.is_a? Diff
        op = self + obj.left - obj.right
        return op
      elsif obj.is_a? BinaryOp 
        return nil unless self.top
        self.top = false
        return Sum.new(self,obj).reduce   
      end
      lft = self.left + obj
      if !(lft == nil) then
        self.left = lft
      else
        rht = self.right + obj
        if !(rht == nil) then
          self.right = rht
        else
          return nil unless self.top
          self.top = false
          return Sum.new(self,obj)
        end
      end
    end
    
    def -(obj)
      obj.top = false
      unless obj.is_a? BinaryOp
        if (obj.is_a? Sum) || (obj.is_a? Diff)
          obj = obj.invert
          return self + obj
        else
          return nil unless self.top
          self.top = false
          return Diff.new(self,obj)
        end
      end
      lft = self.left - obj
      if !(lft == nil) then
        self.left = lft
      else
        rht = self.right - obj
        if !(rht == nil) then
          self.right = rht
        else
          return nil unless self.top
          return Diff.new(self,obj)
        end
      end
    end
    
    def *(obj)
      return nil unless self.top
      self.top = false
      obj.top = false
      return Prod.new(self,obj)
    end
    
    def /(obj)
      return nil unless self.top
      self.top = false
      obj.top = false
      return Div.new(self,obj)
    end
    
    def **(obj)
      return nil unless self.top
      self.top = false
      obj.top = false
      return Pow.new(self,obj)
    end
    
  end

end
