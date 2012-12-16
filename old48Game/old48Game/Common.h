
#import "cocos2d.h"

typedef enum
{
    Obj_Coin = 1,
    Obj_Bonus = 2,
    Obj_ObstacleMayaBox = 31,
    Obj_ObstacleSpikes = 32,
    Obj_ObstacleSpears = 33,
    Obj_ObstacleCrow = 34,
} Objects;

@protocol GameDelegate

- (void) onCollide;
- (void) clearCollision;

@end

@interface Common: NSObject

+ (CCAnimation *) loadAnimationWithPlist: (NSString *) file andName: (NSString *) name;

@end



