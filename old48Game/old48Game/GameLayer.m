
#import "GameLayer.h"
#import "Player.h"
#import "Chaser.h"

#import "UILayer.h"

#import "Level.h"

#import "GameConfig.h"

@interface GameLayer ()

- (void) initGestures;
- (void) cleanup;

@end

@implementation GameLayer

+ (id) sceneWithLevelIndex: (NSInteger) levelIndex
{
    CCScene *scene = [CCScene node];
    
    GameLayer *gameLayer = [[[GameLayer alloc] initWithLevelIndex: levelIndex] autorelease];
    
    [scene addChild: gameLayer];
    
    UILayer *uiLayer = [UILayer node];
    uiLayer.gameDelegate = gameLayer;
    
    [scene addChild: uiLayer];
    
    return scene;
}

- (void) dealloc
{
    [chaser dealloc];
    [player dealloc];
    
    [currentLevel release];
    
    [objects release];
    
    [swipeDownRecognizer release];
    [swipeDownRecognizer release];
    
    [super dealloc];
}

- (id) initWithLevelIndex: (NSInteger) levelIndex
{
    if((self = [super init]))
    {
        self.isTouchEnabled = YES;
        
        objects = [[NSMutableArray alloc] init];
        
        [self loadPlayer];
        
        [self loadChaser];
        
        [self initGestures];

        [self loadLevel: levelIndex];
        
        //[self start];
        
        [self scheduleUpdate];
    }
    
    return self;
}

- (void) cleanup
{
    for(CCNode *object in objects)
    {
        [self removeChild: object cleanup: YES];
    }
    
    [objects removeAllObjects];
}

- (void) loadLevel: (NSInteger) levelIndex
{
    [currentLevel release];

    currentLevel = [[Level alloc] initWithIndex: levelIndex];
    
    [self reset];
}

- (void) reset
{
    [self cleanup];
    
    //parse levels
    
    NSArray *data = currentLevel.objects;
    
    for(NSDictionary *object in data)
    {
        NSInteger Id = [[object objectForKey: @"id"] intValue];
        
        CCNode *node = [self nodeForId: Id andData: object];
        if(node)
        {
            [self addChild: node z: zObstacle];
        
            [objects addObject: node];
        }
    }
}

- (CCNode *) nodeForId: (NSInteger) Id andData: (NSDictionary *) data
{
    CCNode *node = nil;
    NSString *posStr = [data objectForKey: @"position"];
    NSArray *posAr = [posStr componentsSeparatedByString: @","];
    CGPoint pos = ccp([[posAr objectAtIndex: 0] intValue], [[posAr objectAtIndex: 1] intValue]);
    
    switch(Id)
    {
        case Obj_Coin:
            
            break;
            
        case Obj_ObstacleMayaBox:
            node = [CCSprite spriteWithFile: @"res/star.png"];
            
            node.position = pos;
            node.tag = Id;
            
            CCLOG(@"pbject's pos: %f, %f", node.position.x, node.position.y);
            break;
            
        default:
            break;
    }
    
    return node;
}

//- (void) reset

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

- (void) update: (ccTime) delta
{
    for(CCNode *node in objects)
    {
        //move objects
        node.position = ccpAdd(node.position, ccp(kPlayerSpeed * delta, 0));
    }
    
    for(CCNode *node in objects)
    {
        //check colisions
        if(CGRectContainsPoint([node boundingBox], player.position))
        {
            switch(node.tag)
            {
                case Obj_Coin:
                    CCLOG(@"+1 point");
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    
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
    CGPoint gesturePt = [gestureRecognizer locationInView: gestureRecognizer.view];
    gesturePt = [[CCDirector sharedDirector] convertToGL: gesturePt];

    if(CGRectContainsPoint(kLeftGestureArea, gesturePt) || CGRectContainsPoint(kRightGestureArea, gesturePt))
    {
        [player jump];
    }
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
