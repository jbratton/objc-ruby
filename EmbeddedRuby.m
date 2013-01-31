#import "EmbeddedRuby.h"

#define PIPE_READ_END 0
#define PIPE_WRITE_END 1

@implementation EmbeddedRuby : NSObject

- (void)run {
	char *cScriptName = nil;
	char *cFileName = nil;

	if (_scriptName) {
		cScriptName = [self cStringFromNSString:_scriptName];
		if (!cScriptName) {
			// learn exceptions
			return;
		}
	}
	if (_fileName) {
		cFileName = [self cStringFromNSString:_fileName];
		if (!cFileName) {
			return;
		}
	}

	RUBY_INIT_STACK;
	{
		ruby_init();
		ruby_init_loadpath();
		if (_scriptName)  ruby_script(cScriptName);
		if (_fileName) rb_load_file(cFileName);
		ruby_run();
		ruby_finalize();
	}

	free(cScriptName);
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
		return nil;
	}

	switch (fork()) {
	case -1:
		return nil;

	case 0: // ruby
		if (close(rubySTDIN[PIPE_WRITE_END]) == -1
				|| close(rubySTDOUT[PIPE_READ_END]) == -1
				|| close(rubySTDERR[PIPE_READ_END]) == -1) {
			return nil;
		}
		if (dup2(rubySTDIN[PIPE_READ_END], STDIN_FILENO) == -1
				|| dup2(rubySTDOUT[PIPE_WRITE_END], STDOUT_FILENO) == -1
				|| dup2(rubySTDERR[PIPE_WRITE_END], STDERR_FILENO) == -1) {
			return nil;
		}

		[self run];
		return nil;

	default: //parent
		if (close(rubySTDIN[PIPE_READ_END]) == -1
				|| close(rubySTDOUT[PIPE_WRITE_END]) == -1
				|| close(rubySTDERR[PIPE_WRITE_END]) == -1) {
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
	if (cArray == nil) {
		return nil;
	}
	NSString *tmpString;
	for (int i = 0; i < [array count]; i++) {
		tmpString = [array objectAtIndex:i];
		cArray[i] = [self cStringFromNSString:tmpString];
		if (!cArray[i]) {
			return nil;
		}
	}
	return cArray;
}

- (char *)cStringFromNSString:(NSString *)string {
	char *cString = strndup([string UTF8String], [string length]);
	return cString;
}
		
@end

