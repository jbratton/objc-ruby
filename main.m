#import "EmbeddedRuby.h"

int main(int argc, char *argv[]) {
	EmbeddedRubyIO *io;
	EmbeddedRuby *ruby = [[EmbeddedRuby alloc] init];
	[ruby setScriptName:@"embedded-ruby"];
	[ruby setOptions:@[@"-d"]];
	[ruby setFileName:@"test.rb"];
	io = [ruby forkRuby];
	NSData *tmp = [@"QUACK" dataUsingEncoding:NSASCIIStringEncoding];
	[[io rubyStandardInput] writeData:tmp];
	[[io rubyStandardInput] closeFile];
	NSLog(@"ruby stdout:\n'%@'",
				[[NSString alloc] initWithData:[[io rubyStandardOutput] readDataToEndOfFile] encoding:NSASCIIStringEncoding]);
	NSLog(@"ruby stderr:\n'%@'",
				[[NSString alloc] initWithData:[[io rubyStandardError] readDataToEndOfFile] encoding:NSASCIIStringEncoding]);
	[io close];
	return 0;
}
	
