
#import "GameLayer.h"
#import "Player.h"
#import "Chaser.h"

#import "GameConfig.h"

@interface GameLayer ()

- (void) initGestures;

@end

@implementation GameLayer

+ (id) scene
{
    CCScene *scene = [CCScene node];
    
    GameLayer *gameLayer = [GameLayer node];
    
    [scene addChild: gameLayer];
    
    return scene;
}

- (void) dealloc
{
    [chaser dealloc];
    [player dealloc];
    
    [swipeDownRecognizer release];
    [swipeDownRecognizer release];
    
    [super dealloc];
}

- (id) init
{
    if((self = [super init]))
    {
        self.isTouchEnabled = YES;
        
        [self loadPlayer];
        
        [self loadChaser];
        
        [self initGestures];
        
        [self start];
        
    }
    
    return self;
}


- (void) loadPlayer
{
    //player
    player = [[Player alloc] initWithGameDelegate: self];
    player.position = kPlayerPos;
    player.tag = kPlayerTag;
    
    [self addChild: player z: zPlayer];
}

- (void) loadChaser
{
    //chaser
    chaser = [[Chaser alloc] initWithGameDelegate: self];
    chaser.position = kChaserPos;
    
    [self addChild: chaser z: zChaser];
}

#pragma mark - Game logic

- (void) start
{
    [player run];
}

#pragma mark - Gestures

- (void) initGestures
{
    //swipe up
    swipeDownRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget: self
                                                                    action: @selector(swipeUp:)];
    [swipeDownRecognizer setDirection: UISwipeGestureRecognizerDirectionUp];

    [[CCDirector sharedDirector].view addGestureRecognizer: swipeDownRecognizer];
    
    //swipe dowbn
    swipeDownRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget: self
                                                                    action: @selector(swipeDown:)];

    [swipeDownRecognizer setDirection: UISwipeGestureRecognizerDirectionDown];

    [[CCDirector sharedDirector].view addGestureRecognizer: swipeDownRecognizer];
}

- (void) swipeUp: (UIGestureRecognizer *) gestureRecognizer
{
    [player jump];
}

- (void) swipeDown: (UIGestureRecognizer *) gestureRecognizer
{
    [player dodge];
}

#pragma mark - Touches

- (void) registerWithTouchDispatcher
{
    [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate: self priority: 0 swallowsTouches: YES];
}

- (BOOL) ccTouchBegan: (UITouch *) touch withEvent: (UIEvent *) event
{
    [player tumble];
    
    return YES;
}

- (void) ccTouchMoved: (UITouch *) touch withEvent: (UIEvent *) event
{
    
}

- (void) ccTouchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
    
}

@end
