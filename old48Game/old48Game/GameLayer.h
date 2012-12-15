
#import "cocos2d.h"
#import "Common.h"

@class Player;
@class Chaser;

@interface GameLayer: CCLayer <GameDelegate>
{
    Player *player;
    Chaser *chaser;
    
    UISwipeGestureRecognizer *swipeUpRecognizer;
    UISwipeGestureRecognizer *swipeDownRecognizer;
}

- (void) loadPlayer;
- (void) loadChaser;

//- (void) apply;

+ (id) scene;

- (void) start;

@end
