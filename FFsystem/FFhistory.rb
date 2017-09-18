#! /usr/bin/env ruby

##
# Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
# License:: Distributed under MIT license
module Function

  ##
  # This class provides a useful object to store the command history 
  # of linmeric
  #
  #
  # Author:: Massimiliano Dal Mas (mailto:max.codeware@gmail.com)
  # License:: Distributed under MIT license
  class Archive
    # Creates a new Archive objects
    def initialize
      @myArray = []
      @i = 0
    end
  
    # Adds a new item to the archive (it keeps the last 20 items
    # which have been inserted).
    #
    # * **argument**: item to be added (mainly a String)
    def store(str)
      if @myArray.size == 20
        @myArray = @myArray[1...@myArray.size] + [str]
        # @i = @myArray.size
      else
        @myArray[@myArray.size] = str
        @i = @myArray.size
      end
    end
  
    # Returns the previous item compared to the pointer position
    #
    # * **returns**: saved object; "" if the pointer is already at the 
    # beginning of the archive 
    def previous
      if not @i == 0 then
        @i -= 1
        return @myArray[@i].clone
      else
        @i = 0
        return ""
      end
      @i = 0
      return ""
    end
  
    # Returns the next item compared to the pointer position
    #
    # * **returns**: saved object; "" if the pointer is already at the 
    # end of the Archive
    def next_
      if  @i < (@myArray.size - 1) 
        @i += 1
        return @myArray[@i].clone
      else
        @i = @myArray.size
        return ""
      end
      @i = @myArray.size
      return ""
    end
  
    # Moves the pointer to the top of the archive (the last element inserted)
    def top
      @i = @myArray.size
    end
  
  end

  FFhistory = Archive.new

end



