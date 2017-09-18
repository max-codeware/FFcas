#! /usr/bin/env ruby

files = Dir["*.rb","../FFbinary_ops/*.rb","FFvalues/*.rb","FFinterpreters/*.rb","FFsystem/*.rb"]
files.each do |file|
  require_relative file unless Dir["FFtests.rb","FFfunction.rb"].include? file
end

include Function

if ARGV[0]
  FFenv.iMode    = Enabled
  FFenv.scanning = Enabled
  FFscan.set(ARGV[0])
  line = FFscan.next_line
  while line != :EOF
    out = FFParser.parse line
    puts "=> #{out}" if out
    line = FFscan.next_line
  end
else
  FFenv.iMode = Enabled
  begin
    print ">>> "; line = FFsys.gets    
    while line != "exit\n"
      out = FFParser.parse line
      puts "=> #{out}" if out
      puts "=> nil" unless out
      print ">>> "; line = FFsys.gets
    end
  rescue SystemExit
    retry
  end
  exit 0
end
