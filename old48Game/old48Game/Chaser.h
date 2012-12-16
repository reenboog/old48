
#import "cocos2d.h"
#import "Common.h"

@interface Chaser: CCNode
{
    CCNode *body;
    
    id<GameDelegate> gameDelegate;
}

@property (nonatomic, assign) id<GameDelegate> gameDelegate;

- (id) initWithGameDelegate: (id<GameDelegate>) delegate;

@end
