#! /usr/bin/env ruby

# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module Function

  ##
  # This class represents the natural logarithm, describing its behaviour
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class Log < Math_Funct
    
    alias :red :reduce
  
    # Same of Math_Funct
    def initialize(arg)
      super
    end
    
    # Performs the differential of the logarithm
    # ```
    #  d(log(x))      d(x)/dx
    # ----------- = ----------
    #     dx             x
    # ```
    #
    # * **argument**: variable according to the differential must be done
    # * **returns**: result of the operation.
    def diff(var)
      d = self.arg.diff(var) 
      d.top = true
      return d / self.arg
    end
    
    # Simplifies the logarithm, simplifying the argument first, then according
    # to the cases:
    # * log(x^n)  => n*log(x)
    # * log(∞)    => ∞
    # * log(-∞)   => 0
    # * log(1)    => 0
    # * log(0)    => raises an error
    # * log(e)    => 1
    def reduce
      self.red
      if self.arg.is_a? Pow
        exp, exp.top = self.arg.right, true
        return exp * Log.new(self.arg.left)
      elsif self.arg == P_infinity
        return P_Infinity
      elsif (self.arg == M_Infinity) || (self.arg == 1)
        return Number.new 0
      elsif self.arg == 0
        raise "Math Error: log(0)"
      elsif self.arg == E
        return Number.new 1
      end
      return self
    end
    
    # * **returns**: string representation of the logarithm
    def to_s
      return "log(#{self.arg.to_s})"
    end
    
    # * **returns**: string representation of the logarithm in ruby language
    def to_b
      return "Math::log(#{self.arg.to_b})"
    end
  end
  
  ##
  # This class represents the exponential, describing its behaviour
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class Exp < Math_Funct
    
    alias :red :reduce
    
    # Same of Math_Funct
    def initialize(arg)
      super
    end
    
    # Performs the differential of exponential
    # ```
    #  d(exp(x))      exp(x)
    # ---------- = -----------
    #    dx          d(x)/dx
    # ```
    #
    # * **argument**: variable according to the differential must be done
    # * **returns**: result of the operation.
    def diff(var)
      s = self.clone
      s.top = true
      return s * self.arg.diff(var)
    end
    
    # Simplifies the logarithm, simplifying the argument first, then according
    # to the cases:
    # * exp(0)  => 1
    # * exp(1)  => e
    # * exp(∞)  => ∞
    # * exp(-∞) => 0
    def reduce
      self.red
      if self.arg == 0
        return Number.new 1
      elsif self.arg == 1
        return E
      elsif self.arg == P_infinity
        return P_Infinity
      elsif self.arg == M_Infinity
        return Number.new 0
      end
      return self
    end
    
    # * **returns**: string representation of exponential
    def to_s
      return "exp(#{self.arg.to_s})"
    end
    
    # * **returns**: string representation of exponential in ruby language
    def to_b
      return "Math::exp(#{self.arg.to_b})"
    end
  
  end
  
  ##
  # This class represents the sin, describing its behaviour
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class Sin < Math_Funct
    
    alias :red :reduce
    
    # Same of Math_Funct
    def initialize(arg)
      super
    end
    
    # Performs the differential of sin
    # ```
    #  d(sin(x))    d(x) 
    # ---------- = ------ * cos(x)
    #    dx          dx
    # ```
    #
    # * **argument**: variable according to the differential must be done
    # * **returns**: result of the operation.
    def diff(var)
      return Cos.new(self.arg) * self.arg.diff(var)
    end
    
    # Simplifies the logarithm, simplifying the argument first, then according
    # to the cases:
    # * sin(π/2) => 1
    # * sin(3π)  => 1
    # * sin(0)   => 0
    # * sin(π)   => 0
    # * sin(∞)   => raises an error
    # * sin(-∞)  => raises an error
    def reduce
      self.red
      if self.arg == (PI / Number.new(3)) or self.arg == (Number.new(3) * PI)
        return Number.new 1
      elsif self.arg == 0 or self.arg == PI
        return Number.new 0
      elsif self.arg == P_Infinity or self.arg == M_Infinity
        raise "Math Error: sin(#{P_Infinity.to_s})"
      end
      return self
    end
    
    # * **returns**: string representation of sin
    def to_s
      return "sin(#{self.arg.to_s})"
    end
    
    # * **returns**: string representation of sin in ruby language
    def to_b
      return "Math::sin(#{self.arg.to_b})"
    end
    
  end
  
  ##
  # This class represents the cos, describing its behaviour
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class Cos < Math_Funct
    
    alias :red :reduce
    
    # Same of Math_Funct
    def initialize(arg)
      super
    end
    
    # Performs the differential of cos
    # ```
    #  d(sin(x))    d(x) 
    # ---------- = ------ * (- sin(x))
    #    dx          dx
    # ```
    #
    # * **argument**: variable according to the differential must be done
    # * **returns**: result of the operation.
    def diff(var)
      return Negative.new(Sin.new(self.arg) * self.arg.diff(var))
    end
    
    # Simplifies the logarithm, simplifying the argument first, then according
    # to the cases:
    # * cos(π/2) => 0
    # * cos(3π)  => 0
    # * cos(0)   => 1
    # * cos(π)   => 1
    # * cos(∞)   => raises an error
    # * cos(-∞)  => raises an error
    def reduce
      self.red
      if self.arg == (PI / Number.new(3)) or self.arg == (Number.new(3) * PI)
        return Number.new 0
      elsif self.arg == 0 or self.arg == PI
        return Number.new 1
      elsif self.arg == P_Infinity or self.arg == M_Infinity
        raise "Math Error: sin(#{P_Infinity.to_s})"
      end
      return self
    end
    
    # * **returns**: string representation of cos
    def to_s
      return "cos(#{self.arg.to_s})"
    end
    
    # * **returns**: string representation of cos in ruby language
    def to_b
      return "Math::cos(#{self.arg.to_b})"
    end
    
  end
  
  ##
  # This class represents the arcsin, describing its behaviour
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class Asin < Math_Funct
    
    alias :red :reduce
    
    # Same of Math_Funct
    def initialize(arg)
      super
    end
    
    # Performs the differential of arcsin
    # ```
    #                        
    #  d(asin(x))   d(x)           1
    # ---------- = ------ * ---------------
    #    dx          dx     sqrt(1 - x ^ 2)
    # ```
    #
    # * **argument**: variable according to the differential must be done
    # * **returns**: result of the operation.
    def diff(var)
      _arg = self.arg
      _arg.top = true
      d_arg = self.arg.diff(var)
      d_arg.top = true
      return d_arg / Sqrt.new(Number.new(1) - _arg ** Number.new(2))
    end
    
    # Simplifies the logarithm, simplifying the argument first, then according
    # to the cases:
    # * asin(x), |x| > 1 => raises an error
    # * asin(1)          => π/2
    # * asin(-1)         => -π/2
    # * asin(0)          => 0
    def reduce
      self.red     
      if (self.arg.is_a? Number) || (self.arg == P_Infinity) || (self.arg == M_Infinity)
        raise "Math Error: asin(x) => |x| > 1" (if self.arg > 1) || (self.arg == P_Infinity) || (self.arg == M_Infinity)
        return PI / Number.new 2 if self.arg == 1
      end
      return Negative.new(PI / Number.new(2)) if self.arg.is_a? Negative and self.arg.arg == 1
      return Number.new 0 if sel.arg == 0
      return self
    end
    
    # * **returns**: string representation of arcsin
    def to_s
      return "asin(#{self.arg.to_s})"
    end
    
    # * **returns**: string representation of arcsin in ruby language
    def to_b
      return "Math::asin(#{self.arg.to_b})"
    end
    
  end
  
  ##
  # This class represents the arccos, describing its behaviour
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class Acos < Math_Funct
    
    alias :red :reduce
    
    # Same of Math_Funct
    def initialize(arg)
      super
    end
    
    # Performs the differential of sin
    # ```
    #                        
    #  d(acos(x))   d(x)          -1
    # ---------- = ------ * ---------------
    #    dx          dx     sqrt(1 - x ^ 2)
    # ```
    #
    # * **argument**: variable according to the differential must be done
    # * **returns**: result of the operation.
    def diff(var)
      _arg = self.arg
      _arg.top = true
      d_arg = self.arg.diff(var)
      d_arg.top = true
      return Negative.new(d_arg / Sqrt.new(Number.new(1) - _arg ** Number.new(2))).reduce
    end
    
    # Simplifies the logarithm, simplifying the argument first, then according
    # to the cases:
    # * acos(x), |x| > 1 => raises an error
    # * acos(1)          => 0
    # * acos(-1)         => π
    # * acos(0)          => 0
    def reduce
      self.red     
      if (self.arg.is_a? Number) || (self.arg == P_Infinity) || (self.arg == M_Infinity)
        raise "Math Error: asin(x) => |x| > 1" (if self.arg > 1) || (self.arg == P_Infinity) || (self.arg == M_Infinity)
        return Number.new 1 if self.arg == 1
      end
      return PI if self.arg.is_a? Negative and self.arg.arg == 1
      return Number.new 0 if sel.arg == 0
      return self
    end
    
    # * **returns**: string representation of arccos
    def to_s
      return "acos(#{self.arg.to_s})"
    end
    
    # * **returns**: string representation of arccos in ruby language
    def to_b
      return "Math::acos(#{self.arg.to_b})"
    end
    
  end
  
  ##
  # This class represents the tangent, describing its behaviour
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class Tan < Math_Funct
    
    alias :red :reduce
    
    # Same of Math_Funct
    def initialize(arg)
      super
    end
    
    # Performs the differential of tan()
    # ```
    #                        
    #  d(tan(x))    d(x)        1
    # ---------- = ------ * ---------
    #    dx          dx     cos(x)^2
    # ```
    #
    # * **argument**: variable according to the differential must be done
    # * **returns**: result of the operation.
    def diff(var)
      d_arg = self.arg.diff(var)
      d_arg.top = true
      return d_arg / Cos.new(self.arg) ** Number.new(2)
    end
    
    # Simplifies the logarithm, simplifying the argument first, then according
    # to the cases:
    # * tan(0)   => 0
    # * tan(∞)   => ∞
    # * tan(-∞)  => -∞
    def reduce
      self.red
      if self.arg == 0
        return Number.new 0
      elsif self.arg == P_Infinity
        return P_Infinity
      elsif self.arg == M_Infinity
        return M_Infinity
      end
      return self
    end
    
    # * **returns**: string representation of tangent
    def to_s
      return "tan(#{self.arg.to_s})"
    end
    
    # * **returns**: string representation of tangent in ruby language
    def to_b
      return "Math::tan(#{self.arg.to_b})"
    end
    
  end
  
  ##
  # This class represents the arctan, describing its behaviour
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class Atan < Math_Funct
    
    alias :red :reduce
    
    # Same of Math_Funct
    def initialize(arg)
      super
    end
    
    # Performs the differential of arctan
    # ```
    #                        
    #  d(atan(x))   d(x)       1
    # ---------- = ------ * --------
    #     dx         dx     1 - x^2
    # ```
    #
    # * **argument**: variable according to the differential must be done
    # * **returns**: result of the operation. 
    def diff(var)
      _arg = self.arg
      _arg.top = true
      d_arg = self.arg.diff(var)
      d_arg.top = true
      return d_arg / (Number.new(1) - _arg ** Number.new(2))
    end
    
    # Simplifies the logarithm, simplifying the argument first, then according
    # to the cases:
    # * atan(0)   => 0
    # * atan(∞)   => π/2
    # * atan(-∞)  => -π/2
    def reduce
      self.red
      if self.arg == M_Infinity
        return Negative.new(PI / Number.new(2))
      elsif self.arg == P_Infinity
        return PI / Number.new 2
      elsif self.arg == 0
        return 0
      end
      return self
    end
    
    # * **returns**: string representation of arctan
    def to_s
      return "atan(#{self.arg.to_s})"
    end
    
    # * **returns**: string representation of arctan in ruby language
    def to_b
      return "Math::atan(#{self.arg.to_b})"
    end
    
  end
  
  ##
  # This class represents the squared root, describing its behaviour
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class Sqrt < Math_Funct
    
    alias :red :reduce
    
    # Same of Math_Funct
    def initialize(arg)
      super
    end
    
    # Performs the differential of sin
    # ```
    #                        
    #  d(sqrt(x))   d(x)         1
    # ---------- = ------ * -----------
    #      dx        dx     2 * sqrt(x)
    # ```
    #
    # * **argument**: variable according to the differential must be done
    # * **returns**: result of the operation.
    def diff(var)
      d_arg = self.arg.diff(var)
      d_arg.top = true
      return d_arg / (Number.new(2) * self)
    end
    
    
    # Simplifies the logarithm, simplifying the argument first, then according
    # to the case:
    # * sqrt(n^2k) => n^k
    def reduce
      self.red
      if self.arg.is_a? Number
         return Number.new(Math.sqrt(self.arg)) if self.arg == Math.sqrt(sel.arg).to_i ** 2
      if self.arg.is_a? Pow
        if self.arg.right.is_a? Number
          return Pow.new(self.arg.left,Number.new((Self.arg.right.val / 2.0).to_i)).reduce if self.arg.right.val % 2 == 0
        end
      end
      return self
    end
    
    # * **returns**: string representation of squared root
    def to_s
      return "sqrt(#{self.arg.to_s})"
    end
    
    # * **returns**: string representation of squared root in ruby language
    def to_b
      return "Math::sqrt(#{self.arg.to_b})"
    end
    
  end
  
end
