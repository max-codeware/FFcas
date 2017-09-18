#! /usr/bin/env ruby

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module Function

  ##
  # This parser analyzes the stream of tokens, makes math operations
  # and creates the AST
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class FFparser
    
    FFparserZero = Number.new 0
  
    BinOpS = {
               "+"    => lambda do |a,b|
                           return (a || FFparserZero) + b
                         end,
                      
               "-"    => lambda do |a,b|
                           return (a || FFparserZero) - b
                         end,
                         
               "*"    => lambda do |a,b|
                           return a * b
                         end,
                         
               "/"    => lambda do |a,b|
                           return a / b
                         end,
                         
               "^"    => lambda do |a,b|
                           return a ** b
                         end,
                         
               "diff" => lambda do |a,b|
                           return a.diff(b)
                         end
             }
    
    
    # Main function which parses the stream of tokens
    #
    # * **argument**: input string to parse
    # * **returns**: AST 
    def parse(input_string)
      @i = 0
      @val = []
      @op  = []
      @st  = []
      @delimited = false
      @pending = nil
      self.state = 0
      @tk = FFlex.tokenize input_string
      if FFlex.err_track?
        FFlex.err_out
        puts "From line: #{FFscan.line}" if FFenv.scanning
        exit 0
      end
      self.proc = switch
      while  @i < @tk.size and current_tk_att != :EOL do
        self.proc = self.send(self.proc)
        # @i +=1
      end
      make_op
      last_val = @val.pop
      FFenv.set_var(@pending,last_val) if @pending
      return last_val # unless @pending and @val.size > 0
    end
    
    def switch
      return nil unless @i < @tk.size
      case compress_tk current_tk_att
        when :math_f
          return :parse_m_f
        when :math_c
          return :parse_m_c
        when :number
          return :parse_number
        when :keyword
          return :parse_diff
        when :LPAR
          return :parse_delimited
        when :op
          return :state2
        when :ID
          return :parse_id
        when :VARIABLE
          return :parse_variable
        when :EOL
          # if state == 2
          #  step
          #  return switch
          #end
        else
           unexpected current_tk unless current_tk_att == :RPAR and @delimited
      end
    end
    
    def parse_delimited
      skip_tk('(')
      @st.push [@val,@op,@delimited]
      @delimited = true
      self.state = 0
      @val = []
      @op  = []
      self.proc = switch
      while current_tk_val != ')'  and current_tk_att != :EOL and @i < @tk.size
        self.send self.proc
      end
      skip_tk ')'
      make_op
      st = @st.pop
      temp = @val[0]
      @val = st[0] + [temp]
      @op = st[1]
      @delimited = st[2]
      self.state = 2
      self.proc = switch
    end
    
    def make_op
      while @op.size > 0 do
        b = @val.pop
        a = @val.pop
        op = @op.pop
        @val.push BinOpS[op][a,b]
      end
    end
    
    def make_eq_op(prec_ref)
       while @op.size > 0 and priority(@op.last) == prec_ref do
        b = @val.pop
        a = @val.pop
        op = @op.pop
        @val.push BinOpS[op][a,b]
      end
    end
    
    
    def state2
      expecting(current_tk,"operator") if self.state == 1
      unexpected current_tk if state == 0 and not [:SUM_OP,:DIFF_OP].include? current_tk_att
      if @op.size == 0 then
        @op.push current_tk_val
      elsif priority(current_tk_val) > priority(@op.last)
        @op.push current_tk_val
      elsif priority(current_tk_val) == priority(@op.last)
        make_eq_op priority(@op.last)
        @op.push current_tk_val
      elsif priority(current_tk_val) < priority(@op.last)
        make_op
        @op.push current_tk_val
      end
      step
      self.state = 1
      self.proc = switch
    end
    
    def parse_m_f
      unexpected current_tk if self.state == 2
      f = current_tk
      step
      parse_delimited
      arg = @val.pop
      
      case f[0]
        when :SIN
          @val.push Sin.new arg
        when :ASIN
          @val.push Asin.new arg
        when :COS
          @val.push Cos.new arg
        when :ACOS
          @val.push Acos.new arg
        when :TAN
          @val.push Tan.new arg
        when :ATAN
          @val.push Atan.new arg
        when :EXP
          @val.push Exp.new arg
        when :LOG
          @val.push Log.new arg
        when :SQRT
          @val.push Sqrt.new arg
      end
      self.state = 2
      self.proc
    end
    
    def parse_m_c
      unexpected current_tk if self.state == 2
      case current_tk_att
        when :E
          @val.push E
        when :PI
          @val.push PI
        when :INF
          @val.push P_Infinity
        when :N_INF
          @val.push M_Infinity
      end
      step
      self.state = 2
      self.proc = switch
    end
    
    def parse_number
      unexpected current_tk if self.state == 2
      @val.push Number.new current_tk_val.to_f if current_tk_att == :FLOAT
      @val.push Number.new current_tk_val.to_i if [:INTEGER,:ZERO].include? current_tk_att
      step
      self.state = 2
      self.proc = switch
    end
    
    def parse_id
      unexpected current_tk if self.state == 2
      out = maybe_assign
      @val.push FFenv.get_var(current_tk_val) unless out
      step unless out
      self.state = out ? 0 : 2
      self.proc = switch
    end
    
    def maybe_assign
      if next_tk_att == :ASSIGN
        raise unexpected next_tk unless self.state == 0
        @pending = current_tk_val
        step
        skip_tk :ASSIGN
        return true
      end
      return false
    end
    
    def parse_variable
      unexpected current_tk if self.state == 2
      @val.push Variable.new current_tk_val
      step
      self.state = 2
      self.proc = switch
    end
    
    def parse_diff      
      unexpected current_tk if self.state == 2
      skip_tk :DIFF
      skip_tk '('
      expecting(current_tk,:VARIABLE) unless current_tk_att == :VARIABLE
      var = Variable.new current_tk_val
      step
      skip_tk ')'
      parse_delimited
      @val.push @val.pop.diff(var)
      state = 2
      self.proc = switch
    end
    
   protected
    
    # Saves the next state of ffparser
    #
    # * **argument**: state (symbol)
    def state=(state)
      @state = state
    end
    
    # * **returns**: current state of ffparser 
    def state
      return @state
    end
    
    def proc=(name)
      @proc = name
    end
    
    def proc
      return @proc
    end
    
    def current_tk_val
      return current_tk[2]
    end
    
    def current_tk_att
      return current_tk[0]
    end
    
    def current_tk
      return @tk[@i]
    end
    
    def next_tk
      return @tk[@i + 1]
    end
    
    def next_tk_val
      return next_tk[2]
    end
    
    def next_tk_att
      return next_tk[0]
    end
    
    def step
      @i += 1
    end
    
    def skip_tk(id)
      unless @i < @tk.size
        found_eol id
      end
      if id.is_a? Symbol
        expecting(current_tk,id) if current_tk_att != id and current_tk_att != :EOL
        found_eol id if current_tk_att != id and current_tk_att == :EOL
      elsif id.is_a? String
        expecting(current_tk,id) if current_tk_val != id and current_tk_att != :EOL
        found_eol id if current_tk_val != id and current_tk_att == :EOL
      end
      step
    end
    
    def compress_tk(tk_att)
      case tk_att
        when :SIN, :COS, :ASIN, :ACOS, :TAN, :ATAN, :LOG, :EXP, :SQRT
          return :math_f
        when :E, :PI, :INF, :N_INF
          return :math_c
        when :INTEGER, :FLOAT, :ZERO
          return :number
        when :SUM_OP, :DIFF_OP, :MUL_OP, :DIV_OP, :POW_OP
          return :op
        when :DIFF
          return :keyword
        else
          return tk_att
      end
    end
    
    # Establishes the operator priority
    #
    # * **argument**: operator (in string format)
    # * **returns**: integer of operator priority:
    #   * +- = 1
    #   * */ = 2
    #   * ^  = 3
    def priority(op)
      case op
        when /[+-]/
          return 1
        when /[*\/]/
          return 2
        when /\^/
          return 3
      end
    end
    
  end
  
  FFParser = FFparser.new
  
end
