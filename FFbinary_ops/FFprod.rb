#! /usr/bin/env ruby

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module Function
  
  ##
  # This class represents an abstract product between two algebric elements
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class Prod < BinaryOp
    
    alias :red :reduce
    
    # See BinaryOp
    def initialize(l,r)
      super
    end
    
    # * **argument**:
    #   * Negative
    #   * BinaryOp and children
    #   * Variable
    #   * Math_Funct
    #   * Numeric
    #   * P_Infinity_Val
    #   * M_Infinity_Val
    # * **returns**: 
    #   * Children of Constant
    #   * Children of BinaryOp
    #   * +nil+ if the operation can't be performed
    def +(obj)
      return nil unless (self.top) || (self == obj) || (self =~ obj)
      return self - obj.val if obj.is_a? Negative
      return Prod.new(Number.new(2),self) if self == obj
      lft = (obj.is_a? Prod) ? (self.left + obj.left) : (self.left + Number.new(1))
      return Prod.new(lft,self.right) if self =~ obj
      return Sum.new(self,obj).reduce
    end
    
    # * **argument**:
    #   * Negative
    #   * BinaryOp and children
    #   * Variable
    #   * Math_Funct
    #   * Numeric
    #   * P_Infinity_Val
    #   * M_Infinity_Val
    # * **returns**: 
    #   * Children of Constant
    #   * Children of BinaryOp
    #   * +nil+ if the operation can't be performed
    def -(obj)
      return nil unless (self.top) || (self == obj) || (self =~ obj)
      return self + obj.val if obj.is_a? Negative
      return Number.new 0 if self == obj
      lft = ((self =~ obj) && (obj.is_a? Prod)) ? (self.left - obj.left) : (self.left - Number.new(1))
      return Prod.new(lft,self.right) if self =~ obj
      return Diff.new(self,obj)
    end
    
    # This method has been splitted into other two ones due to the code lenght;
    # See :first_chk, :second_chk
    #
    # * **argument**:
    #   * Negative
    #   * BinaryOp and children
    #   * Variable
    #   * Math_Funct
    #   * Numeric
    #   * P_Infinity_Val
    #   * M_Infinity_Val
    # * **returns**: 
    #   * Children of Constant
    #   * Children of BinaryOp
    #   * +nil+ if the operation can't be performed
    def *(obj)
      return nil unless (self.top) || (self == obj) || (self =~ obj) || 
                                                             (obj == 0) || 
                                                                (obj.is_a? Number) || 
                                                                   (obj == P_Infinity) || 
                                                                     (obj == M_Infinity)
      return Pow.new(self,Number.new(2)).reduce if self == obj
      chk = first_chk(obj)
      return chk unless chk == nil
      return self * obj.left * obj.right if obj.is_a? Prod
      chk = second_chk(obj)
      return chk unless chk == nil
      return Prod.new(self,obj).reduce unless obj.is_a? Number
      return Prod.new(obj,self).reduce
    end
    
    # * **argument**:
    #   * Negative
    #   * BinaryOp and children
    #   * Variable
    #   * Math_Funct
    #   * Numeric
    #   * P_Infinity_Val
    #   * M_Infinity_Val
    # * **returns**: one of these
    #   * Number
    #   * Variable
    #   * Children of Math_Funct
    #   * Children of Constant
    #   * Children of BinaryOp
    #   * +nil+ if the operation can't be performed
    def /(obj)
      return nil unless (self.top) || (self == obj) || (self =~ obj) || 
                                                            (obj == 0) || 
                                                              (obj.is_a? Number) ||
                                                                (obj == P_Infinity) ||
                                                                  (obj == M_Infinity)
      if self =~ obj
        ret = self.left
        ret.top = self.top
        return ret
      end 
      if (obj.is_a? Number) || (obj == P_Infinity) || (obj == M_Infinity)
        lft = self.left
        lft.top = true
        lft /= obj
        puts lft
        return Prod.new(lft,self.right).reduce unless lft == nil
        return nil unless self.top
      end
      return Div.new(self,obj).reduce
    end
    
    # * **argument**:
    #   * Negative
    #   * BinaryOp and children
    #   * Variable
    #   * Math_Funct
    #   * Numeric
    #   * P_Infinity_Val
    #   * M_Infinity_Val
    # * **returns**: one of these
    #   * Children of Constant
    #   * Children of BinaryOp
    #   * +nil+ if the operation can't be performed
    def **(obj)
      return nil unless (self.top) || (self == obj) || (obj == 0) || (obj.is_a? Number) ||
                                                                        (obj == P_Infinity) ||
                                                                          (obj == M_Infinity)
                                                                          
      if  (self.left != P_Infinity) || (self.left != M_Infinity) || (self.right != P_Infinity) || (self.right != M_Infinity)
        return Number.new 1 if obj == 0
      else
        raise "Math Error: ∞^0" if obj == 0
      end
      if (obj.is_a? Number) || (obj == P_infinity) || (obj == M_Infinity)
        lft = self.left ** obj
        return Prod.new(lft,Pow.new(self.right,obj)).reduce unless lft == nil
        return nil unless self.top
      end
      return Pow.new(self,obj).reduce
    end
    
    # Implementation of unary plus
    #
    # * **returns**: self
    def +@
      return self
    end
    
    # Implementation of unary minus
    #
    # * **returns**: same of #invert
    def -@
      return self.invert
    end
    
    # Thells whether obj is similar so self. That is: 2*x =~ x (x is in common)
    def =~(obj)
      return false unless self.left.is_a? Number
      if obj.is_a? Prod
        return false unless obj.left.is_a? Number
        return self.right == obj.right
      end    
      return self.right == obj  
    end
    
    # Simplifies the product:
    # * 0 * ∞     => raises an error
    # * ∞ * ∞     => ∞
    # * -∞ * (-∞) => ∞
    # * -∞ * ∞    => -∞
    # * ∞ * (-∞)  => -∞
    # * n * n     => n * n (n == Number)
    # * q * q     => q ^ 2
    # * 1 * y     => y
    # * x * 1     => x
    # * 0 * y     => y
    # * x * 0     => 0
    # * -x * y    => -(x * y)
    # * x * (-y)  => -(x * y)
    # * x * x^2   => x^3
    # * x^2 * x   => x^3
    def reduce
      self.red
      if (self.left == 0) && ((self.right == P_Infinity) || (self.right == M_Infinity))
        raise "Math Error: 0*∞"
      elsif (self.right == 0) && ((self.left == P_Infinity) || (self.left == M_Infinity))
        raise "Math Error: 0*∞"
      elsif (self.left == P_Infinity && self.right == P_Infinity) || (self.left == M_Infinity && self.right == M_Infinity)
        return P_Infinity
      elsif (self.left == P_Infinity or self.left == M_Infinity) && (self.right == M_Infinity or self.right == P_Infinity)
        return M_Infinity
      elsif self.left == 0 or self.right == 0
        return Number.new 0
      elsif self.left.is_a? Number and self.right.is_a? Number
        return self.left * self.right
      elsif self.left == self.right
        return Pow.new(self.left,Number.new(2))
      elsif self.left == 1
        return self.right
      elsif self.right == 1
        return self.left
      elsif self.left.is_a? Negative
        return Negative.new(Prod.new(self.left.val,self.right)).reduce
      elsif self.right.is_a? Negative
        return Negative.new(Prod.new(self.left,self.right.val)).reduce
      elsif self.left.is_a? Pow
        return self.left * self.right if self.left =~ self.right
      elsif self.right.is_a? Pow
        return self.right * self.left if self.right =~ self.left
      end
      return self
    end
    
    # Inverts the sign of the class
    #
    # * **returns**: Negative or Prod
    def invert
      self.red
      if self.left.is_a? Negative
        ret = Prod.new(self.left.val,self.right)
        ret.top = self.top
        return ret
      elsif self.right.is_a? Negative
        ret = Prod.new(self.left,self.right.val)
        ret.top = self.top
        return ret
      end
      ret = Negative.new(self)
      ret.top = self.top
      return ret
    end
    
    # Performs the differential of a product:
    # dx*y + x*dy
    #
    # * **argument**: variable according to the differential must be done
    # * **returns**: Children of BinaryOp or Function element
    def diff(var)
      return Number.new 0 unless self.depend? var
      lft, rht = self.left, self.right
      lft.top = true
      rht.top = true
      d_lft = lft.diff(var); d_lft.top = true
      d_lft *= rht
      d_rht = rht.diff(var); d_rht.top = true
      d_rht *= lft
      return Sum.new(d_lft,d_rht).reduce
    end
    
    # * **returns**: string representation of the class
    def to_s
      lft = self.left.to_s if self.left.is_a? Pow or !(self.left.is_a? BinaryOp)
      lft = "(#{self.left.to_s})" unless self.left.is_a? Pow or !(self.left.is_a? BinaryOp)
      rht = self.right.to_s if self.right.is_a? Pow or !(self.right.is_a? BinaryOp)
      rht = "(#{self.right.to_s})" unless self.right.is_a? Pow or !(self.right.is_a? BinaryOp)
      return "#{lft}*#{rht}"
    end
    
    # * **returns**: string representation of the class for a block
    def to_b
      lft = self.left.to_b if self.left.is_a? Pow or !(self.left.is_a? BinaryOp)
      lft = "(#{self.left.to_b})" unless self.left.is_a? Pow or !(self.left.is_a? BinaryOp)
      rht = self.right.to_b if self.right.is_a? Pow or !(self.right.is_a? BinaryOp)
      rht = "(#{self.right.to_b})" unless self.right.is_a? Pow or !(self.right.is_a? BinaryOp)
      return "#{lft}*#{rht}"
    end
   
   
   private
   
     # First splitting of :* method
     #
     # * **argument**: see :*
     # * **returns**: new Prod; +nil+ if there's nothing to do
     def first_chk(obj)
       if (self =~ obj) && (obj.is_a? Pow)
        if self.right.is_a? Pow
          myExp, objExp = self.right.right, obj.right
          myExp.top, objExp.top = true, true
          exp = myExp + objExp
          rht = Pow.new(obj.left,exp).reduce
          return Prod.new(self.left,rht).reduce
        end
          objExp = obj.right
          objExp.top = true
          objExp += Number.new 1
          rht = Pow.new(obj.left,objExp).reduce
          return Prod.new(self.left,rht).reduce
       elsif self =~ obj
         return Prod.new(self.left,Pow.new(self.right,Number.new(2))).reduce
       end
       return nil
     end 
     
     # Second splitting of the method :*
     #
     # * **argument**: see :*
     # * **returns**: new Prod; +nil+ if there's nothing to do
     def second_chk(obj)
         lft = self.left * obj
         if lft != nil
           return Prod.new(lft,self.right).reduce
         else
           rht = self.right * obj
           if rht != nil
             return Prod.new(self.left,rht).reduce
           else
             return nil unless self.top
             return Prod.new(Number.new(2),self).reduce
           end
         end
       # return nil
     end
     
     # Third Splitting of the method :*
     #
     # * **argument**: see :*
     # * **returns**: new Prod; +nil+ if there's nothing to do 
#     def third_chk(obj)
#       if obj.is_a? Prod
#         res = self * obj.left
#         if res != nil
#           res *= obj.right
#           if res != nil
#             return res
#           else
#             return nil unless self.top
#             return Prod.new(prod,obj.right)
#           end
#         else
#           res = Prod.new(self,obj.left) * obj.right
#           if res != nil
#             return res
#           else
#             return nil unless self.top
#             return Prod.new(self,obj)
#           end
#         end
#       end
#       return nil
#     end
#    
  end

end

















