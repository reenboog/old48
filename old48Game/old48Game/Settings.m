
#import "Settings.h"
#import "GameConfig.h"

@implementation Settings

Settings *sharedSettings    = nil;

@synthesize isTumblingAllowed;

+ (Settings *) sharedSettings
{
    if(!sharedSettings)
    {
        sharedSettings = [[Settings alloc] init];
    }
    
    return sharedSettings;
}

- (id) init
{
    if((self = [super init]))
    {
        //
    }
    
    return self;
}

- (void) dealloc
{
    [self save];
    [super dealloc];
}

#pragma mark -
#pragma mark load/save

- (void) load
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber *isTumblingAllowedData = [defaults objectForKey: kTumblingAllowed];
    if(isTumblingAllowedData)
    {
        self.isTumblingAllowed = [isTumblingAllowedData boolValue];
    }
    else
    {
        self.isTumblingAllowed = NO;
    }
}

- (void) save
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject: [NSNumber numberWithBool: self.isTumblingAllowed] forKey: kTumblingAllowed];
    
    [defaults synchronize];
}

@end
