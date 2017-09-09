#! /usr/bin/env ruby

# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module Function
  class Log < Math_Funct
  
    def initialize(arg)
      super
    end
    
    def diff(var)
      d = self.arg.diff(var) 
      d.top = true
      return d / self.arg
    end
    
    def to_s
      return "log(#{self.arg.to_s})"
    end
    
    def to_b
      return "Math::log(#{self.arg.to_b})"
    end
  end
  
  class Exp < Math_Funct
  
    def initialize(arg)
      super
    end
    
    def diff(var)
      s = self.clone
      s.top = true
      return s * self.arg.diff(var)
    end
    
    def to_s
      return "exp(#{self.arg.to_s})"
    end
    
    def to_b
      return "Math::exp(#{self.arg.to_b})"
    end
  
  end
  
  class Sin < Math_Funct
  
    def initialize(arg)
      super
    end
    
    def diff(var)
      return Cos.new(self.arg) * self.arg.diff(var)
    end
    
    def to_s
      return "sin(#{self.arg.to_s})"
    end
    
    def to_b
      return "Math::sin(#{self.arg.to_b})"
    end
    
  end
  
  class Cos < Math_Funct
  
    def initialize(arg)
      super
    end
    
    def diff(var)
      return Negative.new(Sin.new(self.arg) * self.arg.diff(var))
    end
    
    def to_s
      return "cos(#{self.arg.to_s})"
    end
    
    def to_b
      return "Math::cos(#{self.arg.to_b})"
    end
    
  end
  
  class Asin < Math_Funct
  
    def initialize(arg)
      super
    end
    
    def diff(var)
      _arg = self.arg
      _arg.top = true
      d_arg = self.arg.diff(var)
      d_arg.top = true
      return d_arg / Sqrt.new(Number.new(1) - _arg ** Number.new(2))
    end
    
    def to_s
      return "asin(#{self.arg.to_s})"
    end
    
    def to_b
      return "Math::asin(#{self.arg.to_b})"
    end
    
  end
  
  class Acos < Math_Funct
  
    def initialize(arg)
      super
    end
    
    def diff(var)
      _arg = self.arg
      _arg.top = true
      d_arg = self.arg.diff(var)
      d_arg.top = true
      return Negative.new(d_arg / Sqrt.new(Number.new(1) - _arg ** Number.new(2))).reduce
    end
    
    def to_s
      return "acos(#{self.arg.to_s})"
    end
    
    def to_b
      return "Math::acos(#{self.arg.to_b})"
    end
    
  end
  
  class Tan < Math_Funct
    
    def initialize(arg)
      super
    end
    
    def diff(var)
      d_arg = self.arg.diff(var)
      d_arg.top = true
      return d_arg / Cos.new(self.arg) ** Number.new(2)
    end
    
    def to_s
      return "tan(#{self.arg.to_s})"
    end
    
    def to_b
      return "Math::tan(#{self.arg.to_b})"
    end
    
  end
  
  class Atan < Math_Funct
  
    def initialize(arg)
      super
    end
    
    def diff(var)
      _arg = self.arg
      _arg.top = true
      d_arg = self.arg.diff(var)
      d_arg.top = true
      return d_arg / (Number.new(1) - _arg ** Number.new(2))
    end
    
    def to_s
      return "atan(#{self.arg.to_s})"
    end
    
    def to_b
      return "Math::atan(#{self.arg.to_b})"
    end
    
  end
  
  class Sqrt < Math_Funct
  
    def initialize(arg)
      super
    end
    
    def diff(var)
      d_arg = self.arg.diff(var)
      d_arg.top = true
      return d_arg / (Number.new(2) * self)
    end
    
    def to_s
      return "sqrt(#{self.arg.to_s})"
    end
    
    def to_b
      return "Math::sqrt(#{self.arg.to_b})"
    end
    
  end
  
end
