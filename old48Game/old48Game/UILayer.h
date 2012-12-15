
#import "cocos2d.h"
#import "Common.h"

@interface UILayer: CCLayer
{
    id<GameDelegate> gameDelegate;
    
    CCMenu *pauseMenu;
    CCMenuItemImage *pauseBtn;
}

@property (nonatomic, assign) id<GameDelegate> gameDelegate;

@end
