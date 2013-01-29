#import <Foundation/Foundation.h>
#import <ruby.h>
#import "EmbeddedRubyIO.h"

// this part should just be a low level wrapper around embedded ruby - enough to load and run a file
// possibly methods for changing std file handles before/after ruby_run
@interface EmbeddedRuby : NSObject

@property (retain) NSString *scriptName;
@property (retain) NSArray *options;
@property (retain) NSString *fileName;

- (void)run;
- (void)runFile:(NSString *)fileName;
- (EmbeddedRubyIO *)forkRuby;

- (char **)cStringArrayFromNSArray:(NSArray *)array;
- (char *)cStringFromNSString:(NSString *)string;
@end
