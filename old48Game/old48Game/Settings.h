
#import <Foundation/Foundation.h>

@interface Settings: NSObject
{
    BOOL isTumblingAllowed;
}

+ (Settings *) sharedSettings;

- (void) load;
- (void) save;

@property (nonatomic, assign) BOOL isTumblingAllowed;

@end