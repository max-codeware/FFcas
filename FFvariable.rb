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
    
    # Sets the position of variable: if top is true means that negative
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
    
    # Tells if Variable depends on a specific one (if self == variable)
    #
    # * **argument**: object to check for dependencies
    # * **returns**: +true+ if Negative depends on obj; +false+ else
    def depend?(obj)
      return false unless (obj.is_a? Variable) or (obj.is_a? Negative)
      return self == obj.val if obj.is_a? Negative
      return self == obj
    end
  
    def +(obj)
      if not self.top then
        return nil unless (obj.is_a? Variable) && (self.depend? obj)
      end
      if obj.is_a? BinaryOp then
        return (obj + self).reduce
      elsif obj.is_a? Negative then
        obj.top = false
        self.top = false
        return Diff.new(self,obj.val)
      elsif self == obj then
        self.top = false
        return Prod.new(2,self)
      else
        obj.top = false
        self.top = false
        return Sum.new(self,obj)
      end
    end
  
    def -(obj)
      if not self.top then
        return nil unless (obj.is_a? Variable) && (self.depend? obj)
      end
      if obj.is_a? BinaryOp then
        obj = obj.invert
        return (self + obj).reduce
      elsif obj.is_a? Negative then
        obj.top = false
        self.top = false
        return Sum.new(self,obj.val)
      elsif self == obj then
        return 0
      else
        obj.top = false
        self.top = false
        return Diff.new(self,obj)
      end
    end
  
    def *(obj)
      if not self.top then
        return nil unless (obj.is_a? Variable) && (self.depend? obj)
      end
    end
  
    def /(obj)
      if not self.top then
        return nil unless (obj.is_a? Variable) && (self.depend? obj)
      end
    end
  
    def **(obj)
      if not self.top then
        return nil unless (obj.is_a? Variable) && (self.depend? obj)
      end
    end
    
    # Calculates the differential
    #
    # * **argument**: variable according to the differential must be calculated
    # * **returns**: result of the differential
    def diff(var)
      return 1 if self.depend? var
      return 0
    end
    
    # * **returns**: self
    def reduce
      return self
    end

  end
end
