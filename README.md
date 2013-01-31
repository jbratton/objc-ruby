Objective-C Ruby
================
An Objective-C class (EmbeddedRuby for now) providing access to the Ruby interpreter. It relies on 
the Ruby and Foundation frameworks.

Currently works at a basic level with ruby 1.8.7 - can load a file, fork ruby, and give
access to ruby's stdin/out/err. Untested with ruby 1.9.

---
Basic Example
-------------
		#import "EmbeddedRuby.h"

		EmbeddedRuby *ruby = [[EmbeddedRuby alloc] init];
		[ruby setFileName:@"reverse_stdin.rb"]; // pretend this exists, reads stdin, reverses & prints it to stdout

		EmbeddedRubyIO *io = [ruby forkRuby];
		NSFilehandle *stdin = [io rubyStandardInput];
		NSData *input = [@"This string should be reversed." dataUsingEncoding:NSASCIIStringEncoding];
		[stdin writeData:input];
		[stdin closeFile];

		NSFilehandle *stdout = [io rubyStandardOutput];
		NSString *output = [[NSString alloc] initWithData:[stdout readDataToEndOfFile] encoding:NSASCIIStringEncoding];
		[io close]; // closes stdin/out/err

		NSLog(@"%@", output);

Output:
			.desrever eb dluohs gnirts sihT
			
