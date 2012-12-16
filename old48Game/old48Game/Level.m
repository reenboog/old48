
#import "Level.h"
#import "GameConfig.h"

@interface Level ()

@end

@implementation Level

@synthesize groundImage;
@synthesize backImage;
@synthesize skyImage;
@synthesize objects;
@synthesize backSound;

@synthesize boxImage;

- (void) dealloc
{
    self.groundImage = nil;
    self.backImage = nil;
    self.skyImage = nil;
    self.backSound = nil;
    self.boxImage = nil;

    [objects release];
    objects = nil;
    
    [super dealloc];
}

- (id) initWithIndex: (NSInteger) levelIndex
{
    if((self = [super init]))
    {
        NSString *fileName = [NSString stringWithFormat: @"%@%i", kLevelPrefix, levelIndex];
        
        NSDictionary *fileData = [NSDictionary dictionaryWithContentsOfFile:
                                                                [[NSBundle mainBundle] pathForResource: fileName ofType: @"plist"]];
        
        
        objects = [[fileData objectForKey: @"objects"] retain];
        
        NSLog(@"loaded objects count: %i", [objects count]);
        
        self.groundImage = [fileData objectForKey: @"groundImage"];
        self.skyImage = [fileData objectForKey: @"skyImage"];
        self.backImage = [fileData objectForKey: @"backImage"];
        self.backSound = [fileData objectForKey: @"backSound"];
        self.boxImage = [fileData objectForKey: @"boxImage"];
    }
    
    return self;
}

@end