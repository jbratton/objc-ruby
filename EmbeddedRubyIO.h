#import <Foundation/Foundation.h>

@interface EmbeddedRubyIO : NSObject

@property (readonly) NSFileHandle* rubyStandardInput;
@property (readonly) NSFileHandle* rubyStandardOutput;
@property (readonly) NSFileHandle* rubyStandardError;

- (id)initWithInput:(int)inputHandle andOutput:(int)outputHandle andError:(int)errorHandle;
- (void)close;
@end
