
#import "UILayer.h"
#import "GameConfig.h"

@interface UILayer ()

- (void) onPauseBtnTapped;

@end

@implementation UILayer

@synthesize gameDelegate;

- (void) dealloc
{
    [super dealloc];
}

- (id) init
{
    if((self = [super init]))
    {
        pauseBtn = [CCMenuItemImage itemWithNormalImage: @"res/pauseBtn.png"
                                          selectedImage: @"res/pauseBtnOn.png"
                                                 target: self
                                               selector: @selector(onPauseBtnTapped)
                   ];
        
        pauseMenu = [CCMenu menuWithItems: pauseBtn, nil];
        
        pauseMenu.position = kPauseMenuPos;
        
        [self addChild: pauseMenu];
        
    }
    
    return self;
}

- (void) onPauseBtnTapped
{
    //[gameDelegate pause];
}

@end