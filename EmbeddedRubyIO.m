#import "EmbeddedRubyIO.h"

@implementation EmbeddedRubyIO : NSObject

- (id)initWithInput:(int)inputHandle andOutput:(int)outputHandle andError:(int)errorHandle {
	[self init];
	_rubyStandardInput = [[NSFileHandle alloc] initWithFileDescriptor:inputHandle closeOnDealloc:YES];
	_rubyStandardOutput = [[NSFileHandle alloc] initWithFileDescriptor:outputHandle closeOnDealloc:YES];
	_rubyStandardError = [[NSFileHandle alloc] initWithFileDescriptor:errorHandle closeOnDealloc:YES];
	return self;
}

- (void)close {
	[_rubyStandardInput closeFile];
	_rubyStandardInput = nil;
	[_rubyStandardOutput closeFile];
	_rubyStandardOutput = nil;
	[_rubyStandardError closeFile];
	_rubyStandardError = nil;
}
@end
