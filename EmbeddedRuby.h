#import <Foundation/Foundation.h>
#import <ruby.h>
#import "EmbeddedRubyIO.h"

@interface EmbeddedRuby : NSObject

@property (retain) NSString *scriptName;
@property (retain) NSString *fileName;

- (void)run;
- (void)runFile:(NSString *)fileName;
- (EmbeddedRubyIO *)forkRuby;

- (char **)cStringArrayFromNSArray:(NSArray *)array;
- (char *)cStringFromNSString:(NSString *)string;
@end
