#import "EmbeddedRuby.h"

#define PIPE_READ_END 0
#define PIPE_WRITE_END 1

@implementation EmbeddedRuby : NSObject

- (void)run {
	// check main.c for possible platform specific code needed

	char *cScriptName = nil;
	char **cOptions = nil;
	char *cFileName = nil;

	if (_scriptName) {
		cScriptName = [self cStringFromNSString:_scriptName];
		if (!cScriptName) {
			NSLog(@"error creating C script name");
			return;
		}
	}
	if (_options) {
		cOptions = [self cStringArrayFromNSArray:_options];
		if (!cOptions) {
			NSLog(@"error creating C option array");
			return;
		}
	}
	if (_fileName) {
		cFileName = [self cStringFromNSString:_fileName];
		if (!cFileName) {
			NSLog(@"error creating C filename");
			return;
		}
	}

	RUBY_INIT_STACK;
	{
		ruby_init();
		ruby_init_loadpath();
		if (_scriptName)  ruby_script(cScriptName);
		if (_options) ruby_options([_options count], cOptions);
		if (_fileName) rb_load_file(cFileName);
		ruby_run();
		ruby_finalize();
	}

		
	free(cScriptName);
	if (cOptions) {
		for (int i = 0; i < [_options count]; i++) {
			free(cOptions[i]);
		}
		free(cOptions);
	}
	free(cFileName);
}

- (void)runFile:(NSString *)fileName {
	[self setFileName:fileName];
	[self run];
}

// exceptions instead of returning nil?
- (EmbeddedRubyIO *)forkRuby {
	int rubySTDIN[2];
	int rubySTDOUT[2];
	int rubySTDERR[2];
	EmbeddedRubyIO *rubyIO;
	
	if (pipe(rubySTDIN) == -1 || pipe(rubySTDOUT) == -1 || pipe(rubySTDERR) == -1) {
		NSLog(@"error creating pipes");
		return nil;
	}

	switch (fork()) {
	case -1:
		NSLog(@"broken fork");
		return nil; // exception?

	case 0: // ruby
		if (close(rubySTDIN[PIPE_WRITE_END]) == -1
				|| close(rubySTDOUT[PIPE_READ_END]) == -1
				|| close(rubySTDERR[PIPE_READ_END]) == -1) {
			NSLog(@"error closing ruby's unused pipe ends");
			return nil;
		}
		if (dup2(rubySTDIN[PIPE_READ_END], STDIN_FILENO) == -1
				|| dup2(rubySTDOUT[PIPE_WRITE_END], STDOUT_FILENO) == -1
				|| dup2(rubySTDERR[PIPE_WRITE_END], STDERR_FILENO) == -1) {
			NSLog(@"error duping to ruby's stdin/out/err");
			return nil;
		}

		[self run];
		return nil;

	default: //parent
		if (close(rubySTDIN[PIPE_READ_END]) == -1
				|| close(rubySTDOUT[PIPE_WRITE_END]) == -1
				|| close(rubySTDERR[PIPE_WRITE_END]) == -1) {
			NSLog(@"error closing unused pipe ends");
			return nil;
		}
		
		rubyIO = [[EmbeddedRubyIO alloc] initWithInput:rubySTDIN[PIPE_WRITE_END]
								andOutput:rubySTDOUT[PIPE_READ_END]
								andError:rubySTDERR[PIPE_READ_END]];
		return rubyIO;
	}
}

- (char **)cStringArrayFromNSArray:(NSArray *)array {
	char **cArray = malloc([array count] * sizeof(char*));
	if (cArray == NULL) {
		NSLog(@"out of memory");
		return nil; // exception?
	}
	NSString *tmpString;
	for (int i = 0; i < [array count]; i++) {
		tmpString = [array objectAtIndex:i];
		cArray[i] = [self cStringFromNSString:tmpString];
		if (!cArray[i]) {
			NSLog(@"couldn't strndup while making a C array");
			return nil; // exception?
		}
	}
	return cArray;
}

- (char *)cStringFromNSString:(NSString *)string {
	char *cString = strndup([string UTF8String], [string length]); // possibly wrong
	return cString;
}
		
@end

