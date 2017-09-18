#! /usr/bin/env ruby

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module Function

  ##
  # This lexer scans the function tokenizing each element
  # using regular expressions. 	Returned tokens are arrays having 
  # this structure:
  # * ID
  # * position
  # * value
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class FFlexer
    PATTERNS = { :SIN      => /^[sS][iI][nN]/,
                 :DIFF     => /^[Dd][Ii][Ff][Ff]/,
                 :ID       => /^[#][a-zA-Z_][a-zA-Z0-9_]*/,
                 :COS      => /^[Cc][Oo][Ss]/,
                 :ASIN     => /^[Aa][Ss][Ii][Nn]/,
                 :ACOS     => /^[Aa][Cc][Oo][Ss]/,
                 :TAN      => /^[Tt][Aa][Nn]/,
                 :ATAN     => /^[Aa][Tt][Aa][Nn]/,
                 :LOG      => /^[Ll][Oo][Gg]/,
                 :EXP      => /^[Ee][Xx][Pp]/, 
                 :SQRT     => /^[Ss][Qq][Rr][Tt]/,
                 :PI       => /^[P][I]/,
                 :E        => /^[e]/,
                 :INF      => /^[I][N][F]/,
                 :N_INF    => /^[N][_][I][N][F]/,
                 :VARIABLE => /^[a-zA-Z_][a-zA-Z0-9_]*/, 
                 :INTEGER  => /^[1-9][0-9]*/,
                 :ZERO     => /^[0]/,
                 :FLOAT    => /^[0-9]*[.][0-9]*/,
                 :SUM_OP   => /^[+]/,
                 :DIFF_OP  => /^[-]/,
                 :DIV_OP   => /^[\/]/,
                 :MUL_OP   => /^[*]/,
                 :POW_OP   => /^[\^]/,                 
                 :LPAR     => /^[(]/,
                 :RPAR     => /^[)]/,
                 :SPACE    => /^[" "]/,
                 :EOL      => /^[\n]/,
                 :ASSIGN   => /^[=]/,
                 :UNKNOWN  => /./
               }

    # Main function that tokenizes the input string
    #
    # * **argument**: string to tokenize
    # * **returns**: stream of tokens (array)
    def tokenize(exp)
      self.context = exp
      err_reset
      stream = []
      index  = 0      
      while exp.size > 0 do
        PATTERNS.keys.each do |key|
          matched = PATTERNS[key].match(exp)
          if matched then
            err_track index if key == :UNKNOWN
            stream << [key,index,matched.to_s] unless key == :SPACE
            index += matched.to_s.size
            exp = exp [matched.to_s.size...exp.size]
            break
          end
        end
      end
      stream << [:EOL,index,"\n"] unless stream.last != nil and stream.last[0] == :EOL
      return stream
    end
    
    # Tells whether errors have been encountered
    #
    # * **returns**: +true+ if errors have been encountered; +false+ else
    def err_track?
      return (@bugs.size > 0) ? true : false
    end
    
    # Prints all the tracked errors (unmatched chars)
    def err_out
      @bugs.each do |index|
        begin
          error(context,index)
        rescue => e
          puts e
        end
      end
    end
    
    # * **returns**: current FFlexer context
    def context
      return @context
    end
    
   private 
    
    # Raises a fflex error (when a char can't be matched)
    #
    # * **argument**: string (expression) where the wrong char has been found
    # * **argument**: position of the wrong char 
    def error(exp,index)
      e = "Sintax Error: cannot match char at index #{index + 1}:\n#{exp}\n#{" " * index}^"
      raise e
    end
  
    # Sets the context is being tokenized (expression)
    #
    # * **argument**: expression to tokenize (string)
    def context=(exp)
      @context = exp
    end
    
    # Adds a new error index (error tracking)
    #
    # * **argument**: error index (numeric)
    def err_track(bug_index)
      @bugs << bug_index
    end
    
    # Sets @bugs as a new array 
    def err_reset
      @bugs = []
    end
  end
  
  FFlex = FFlexer.new

end




