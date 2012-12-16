
#import "cocos2d.h"
#import "Common.h"

@class CDSoundSource;

typedef enum
{
    PS_Undefined = -1,
    PS_Running,
    PS_Jumping,
    PS_Tumbling,
    PS_Dodging,
    PS_Dead
}PlayerState;

typedef enum
{
    PCS_Clean,
    PCS_Collided,
    PCS_RunningAway
}PlayerCollisionState;

@interface Player: CCNode
{
    PlayerState state;
    PlayerCollisionState collisionState;
    
    CCNode *body;
    
    id<GameDelegate> gameDelegate;
    
    BOOL canTumble;
    BOOL collided;
    
    CGPoint positionBeforeAction;
    
    CDSoundSource *runningSound;
}

@property (nonatomic, assign) id<GameDelegate> gameDelegate;
@property (nonatomic, readonly) PlayerState state;
@property (nonatomic, readonly) CCNode *body;
@property (nonatomic, readonly) BOOL collided;


- (id) initWithGameDelegate: (id<GameDelegate>) delegate;

- (void) jump;
- (void) dodge;
- (void) tumble;
- (void) run;

- (void) onCollide;
- (void) clearCollision;

@end
