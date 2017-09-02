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
  class Parser
  
    BinOpS = {
               "+" => lambda do |a,b|
                        return a+b
                      end,
               "-" => lambda do |a,b|
                        return (a || 0) - b
                      end,
               "*" => lambda do |a,b|
                        return a * b
                      end,
               "/" => lambda do |a,b|
                        return a / b
                      end
               "^" => lambda do |a,b|
                        return a ^ b
                      end
             }
    
    # Creates a new object and initializes new variables
    def initialize()
      @i = 0
      @val = []
      @op  = []
    end
    
    # Main function which parses the stream of tokens
    #
    # * **argument**: stream (array) of tokens
    # * **returns**: AST 
    def parse(stream)
      self.state = state0_1(0)
      while @i < stream.size do
        self.state = self.send(self.state,stream)
        @i +=1
      end
    end
    
    def parse_delimited(stream)
    
    end
    
    def make_op
      
    end
    
    def state0_1(stream,state = 1)
    
    end
    
    def state2(stream)
    
    end
    
    private
    
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
        when /[^]/
          return 3
      end
    end
  end
  
end
