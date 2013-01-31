Objective-C Ruby
================
An Objective-C class (EmbeddedRuby for now) providing access to the Ruby interpreter.

notes
--------------
2013-01-30
* lol I don't know how to use ruby\_options() apparently. removed that and EmbeddedRuby works fine.
* so now I need to figure out how ruby\_options() works.

2013-01-30
* doesn't seem like I'm getting the NSString -> NSData conversion done correctly
* using write(data, [nsfilehandle fileDescriptor], datalength) gets data to Ruby, but:
	* Ruby complains like it's trying to parse the data rather than just read it
	* it's not getting valid ASCII characters
* using [nsfilehandle writeData:data] doesn't get the data to Ruby - STDIN.read.length == 0

2013-01-29
* writing to rubyStandardInput does not work - in Ruby STDIN.read.length == 0 - even though STDIN.read will block 
until rubyStandardInput is closed
* an attempt to set the Ruby options to "-d" (debug flag) didn't work ($DEBUG == false)
* an attempt to set the Ruby script name ($0) didn't work - seemed to be set to "-" (stdin?)
* reading from rubyStandardOutput & rubyStandardError is working
