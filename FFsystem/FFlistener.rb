#! /usr/bin/env ruby

require 'io/console'

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module Function

  ##
  # This class works on the command line interface to allow the user to move
  # the cursor, modify the input string in each point and retrieve commands from the history
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  module Listener
    CSI = "\e["
    LETTERS = "abcdefghijklmnopqrstuvwxyz"
    NUMBERS = "0123456789"
    SPECIAL_CHARS = "#|!$%&/()=?'^~+-*<>-_,:;. " + '"'
    CHARS = LETTERS + LETTERS.upcase + SPECIAL_CHARS + NUMBERS
  
    # Creates the main variables
    def initialize
      @final_string = ""
      @i = 0
      @s = 0
      @exit = false
    end
  
    # reinitializates three main variables
    def reset
      @final_string = ""
      @i = 0
      @exit = false
    end
  
    # Reads a single char from the command line
    def read_char
      STDIN.echo = false
      STDIN.raw!

      input = STDIN.getc.chr
      if input == "\e" then
        input << STDIN.read_nonblock(3) rescue nil
        input << STDIN.read_nonblock(2) rescue nil
      end
    ensure
      STDIN.echo = true
      STDIN.cooked!

      return input
    end
  
    # according to the collected key decides what to do: moving the cursor,
    # surfing the history, or simply store chars in a variable
    def collect_single_key()
      c = read_char
      case c
      
        # "TAB"
        when "\t"        
      
        # "RETURN"
        when "\r"
          puts c
          @final_string += "\n"
          @exit = true
        when "\n"
          # "LINE FEED"
        when "\e"
          # "ESCAPE"
    
        # "UP ARROW"
        when "\e[A"      	
          temp = FFhistory.previous
          unless temp == ""
            clear_line
            @final_string = temp
            @i = @final_string.size
            print @final_string
          end
        
        # "DOWN ARROW"    
        when "\e[B" 
          clear_line
          @final_string = FFhistory.next_
          @i = @final_string.size
          print @final_string

        # "RIGHT ARROW"
        when "\e[C"
          FFhistory.top
          unless @i == @final_string.size
            $stdout.write "#{CSI}1C"
            @i += 1
          end 
      
        # "LEFT ARROW"  
        when "\e[D"
          FFhistory.top
          unless @i == 0
            $stdout.write "#{CSI}1D" 
            @i -= 1
          end
     
        # Delete char 
        when "\177" 
          FFhistory.top
          unless @i == 0
            $stdout.write "#{CSI}1D"
            for i in (@i)...@final_string.size do
              $stdout.write "#{@final_string[i]}"
            end
            $stdout.write " "
            @final_string = @final_string.remove(@i-1)
            for i in (@i-2)...@final_string.size do
              $stdout.write "#{CSI}1D"
            end
            @i -= 1
          end

        when "\004"
          # "DELETE"
        when "\e[3~"
          # "ALTERNATE DELETE"
      
        # "Ctrl + C"
        when "\u0003"        
#          puts
#          exit 0
        when /^.$/
          FFhistory.top
          if CHARS.include? c
            if @i < @final_string.size then
              last_i = @i + 2
              @final_string.insert @i, c
              clear_line
              $stdout.write "#{@final_string}"
              cursor_to(last_i)
              @i = last_i - 1
            else
              print c
              @final_string += c
              @i += 1
            end
          elsif c == "\f" then
            @i = 0
            print "\e[H\e[2J"
            print ">>> "
          end
      end
    end
  
    # main function that can be used. It returns the stream the user wrote on the command
    # line after they pressed return.
    def gets()
      collect_single_key while(!@exit)
      FFhistory.store(@final_string.chomp) unless @final_string == "\n"
      return @final_string.clone
    ensure
      reset
    end
  
   private
 
    # Clears the current line (deletes the typed input)
    def clear_line
      if @i < @final_string.size
        for i in @i...@final_string.size do
          $stdout.write "#{CSI}1C"
        end
      end
      @i = (@final_string == nil or @final_string == "") ? 0 : @final_string.size
      for i in 0...@i do
        $stdout.write "#{CSI}1D"
        $stdout.write " "
        $stdout.write "#{CSI}1D"
      end
      @i = 0
    end
  
    # Moves the cursor backward of the number of specified position
    #
    # * **argument**: number of position the cursor must be moved backward
    def cursor_to(pos)
      return nil if pos < 0
      for i in pos..@final_string.size
        $stdout.write "#{CSI}1D"
      end
    end
  
  end
  
  
end






