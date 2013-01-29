Objective-C Ruby
================
An Objective-C class (EmbeddedRuby for now) providing access to the Ruby interpreter.

notes
--------------
2013-01-29
* writing to rubyStandardInput does not work - in Ruby STDIN.read.length == 0 - even though STDIN.read will block 
until rubyStandardInput is closed
* an attempt to set the Ruby options to "-d" (debug flag) didn't work ($DEBUG == false)
* an attempt to set the Ruby script name ($0) didn't work - seemed to be set to "-" (stdin?)
* reading from rubyStandardOutput & rubyStandardError is working
