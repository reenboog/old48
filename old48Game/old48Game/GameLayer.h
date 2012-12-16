
#import "cocos2d.h"
#import "Common.h"

@class Player;
@class Chaser;
@class Level;

@interface GameLayer: CCLayer <GameDelegate>
{
    Player *player;
    Chaser *chaser;
    
    CCNode *backLayers;
    
    CCSprite *ground;
    CCSprite *back;
    CCSprite *sky;
    
    UISwipeGestureRecognizer *swipeUpRecognizer;
    UISwipeGestureRecognizer *swipeDownRecognizer;
    
    Level *currentLevel;
    
    //obstacles and others
    NSMutableArray *objects;
}

- (void) loadPlayer;
- (void) loadChaser;

//- (void) apply;

+ (id) sceneWithLevelIndex: (NSInteger) levelIndex;

- (id) initWithLevelIndex: (NSInteger) levelIndex;

- (void) loadLevel: (NSInteger) levelIndex;
- (CCNode *) nodeForId: (NSInteger) Id andData: (NSDictionary *) data;
//- (void)
- (void) reset;

@end