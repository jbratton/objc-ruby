#import "EmbeddedRuby.h"

int main(int argc, char *argv[]) {
	EmbeddedRubyIO *io;
	EmbeddedRuby *ruby = [[EmbeddedRuby alloc] init];
	NSString *someRuby = @"0.upto(10) {|i| puts i}; puts 'done.'";
	io = [ruby forkRubyString:someRuby];
/*	
	[ruby setScriptName:@"embedded-ruby"];
	[ruby setFileName:@"test.rb"];
	io = [ruby forkRuby];
	NSData *tmp = [@"QUACK" dataUsingEncoding:NSASCIIStringEncoding];
	[[io rubyStandardInput] writeData:tmp];
	[[io rubyStandardInput] closeFile];
*/
	NSLog(@"ruby stdout:\n'%@'",
				[[NSString alloc] initWithData:[[io rubyStandardOutput] readDataToEndOfFile] encoding:NSASCIIStringEncoding]);
	NSLog(@"ruby stderr:\n'%@'",
				[[NSString alloc] initWithData:[[io rubyStandardError] readDataToEndOfFile] encoding:NSASCIIStringEncoding]);
	[io close];
	return 0;
}
	
