
#import "cocos2d.h"
#import "Common.h"

typedef enum
{
    PS_Undefined = -1,
    PS_Running,
    PS_Jumping,
    PS_Tumbling,
    PS_Dodging
}PlayerState;

@interface Player: CCNode
{
    PlayerState state;
    
    CCNode *body;
    
    id<GameDelegate> gameDelegate;
    
    BOOL canTumble;
    
    CGPoint positionBeforeAction;
}

@property (nonatomic, assign) id<GameDelegate> gameDelegate;
@property (nonatomic, readonly) PlayerState state;


- (id) initWithGameDelegate: (id<GameDelegate>) delegate;

- (void) jump;
- (void) dodge;
- (void) tumble;
- (void) run;

@end
