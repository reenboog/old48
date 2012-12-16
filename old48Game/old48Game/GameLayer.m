
#import "GameLayer.h"
#import "Player.h"
#import "Chaser.h"

#import "SimpleAudioEngine.h"

#import "CCBReader.h"
#import "CCBAnimationManager.h"

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
        //preload some common animations and plists
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: @"energy.plist"];
        [Common loadAnimationWithPlist: @"animations" andName: @"energy"];
        
        starsBatch = [CCSpriteBatchNode batchNodeWithFile: @"energy.png"];
        starsBatch.position = ccp(0, 0);
        
        [self addChild: starsBatch z: zObstacle];
                
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
    
    [starsBatch removeAllChildrenWithCleanup: YES];
    [boxBatch removeAllChildrenWithCleanup: YES];
    
    [objects removeAllObjects];
}

- (void) loadLevel: (NSInteger) levelIndex
{
    [currentLevel release];

    currentLevel = [[Level alloc] initWithIndex: levelIndex];
    
    if(!backLayers)
    {
        backLayers = [CCNode node];
        backLayers.position = ccp(0, 0);
        [self addChild: backLayers z: zBackLayers];
        
        //ground
        ground = [CCSprite spriteWithFile: currentLevel.groundImage];
        ground.anchorPoint = ccp(0, 0);
        ground.position = ccp(0, kBackgroundLayerVerticalDisplacement);
        
        ccTexParams tp = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_CLAMP_TO_EDGE};
        
        [ground.texture setTexParameters: &tp];
        [backLayers addChild: ground z: zGround];
        
        back = [CCSprite spriteWithFile: currentLevel.backImage];
        back.anchorPoint = ccp(0, 0);
        back.position = ccp(0, 0);
        
        ccTexParams tb = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_CLAMP_TO_EDGE};
        
        [back.texture setTexParameters: &tb];
        [backLayers addChild: back z: zBack];
      
        //sky
        sky = [CCSprite spriteWithFile: currentLevel.skyImage];
        sky.anchorPoint = ccp(0, 0);
        sky.position = ccp(0, 0);
        
        ccTexParams ts = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_CLAMP_TO_EDGE};
        
        [sky.texture setTexParameters: &ts];
        [backLayers addChild: sky z: zSky];
        
        //box batch
        boxBatch = [CCSpriteBatchNode batchNodeWithFile: currentLevel.boxImage];
        boxBatch.position = ccp(0, 0);
        
        [self addChild: boxBatch z: zObstacle];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic: currentLevel.backSound loop: YES];
    }
    
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
            if(Id == Obj_Coin)
            {
                [starsBatch addChild: node];
                
                //CCLOG(@"star pos: %f %f", node.position.x, node.position.y);
            }
            else if(Id == Obj_ObstacleMayaBox)
            {
                [boxBatch addChild: node];
            }
            else
            {
                [self addChild: node z: zObstacle];
            }
        
            [objects addObject: node];
        }
    }
    
//    [self stopAllActions];
//    [self runAction:
//                        [CCFollow actionWithTarget: player worldBoundary: CGRectMake(0, -kBackgroundLayerVerticalDisplacement, 1024, 1024)]
//    ];
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
            CCLOG(@"coin created");
            
            node = [CCSprite spriteWithSpriteFrameName: @"energy0.png"];
            node.position = pos;
            node.tag = Id;
            
            [node runAction:
                            [CCRepeatForever actionWithAction:
                                                [CCAnimate actionWithAnimation:
                                                            [[CCAnimationCache sharedAnimationCache] animationByName: @"energy"]
                                                ]
                            ]
            ];
            
            break;
            
        case Obj_ObstacleMayaBox:
            node = [CCSprite spriteWithFile: @"mayaBox.png"];
            
            node.position = pos;
            node.tag = Id;
            
            CCLOG(@"pbject's pos: %f, %f", node.position.x, node.position.y);
            break;
            
        case Obj_ObstacleSpikes:
            node = [CCSprite spriteWithFile: @"mayaHole.png"];
            node.position = pos;
            node.tag = Id;
            break;
            
        case Obj_ObstacleCrow:
            node = [CCBReader nodeGraphFromFile: @"crow.ccbi"];
            node.position = pos;
            node.tag = Id;
            node.visible = NO;
            
            node.contentSize = kRavenSize;
            CCBAnimationManager *mngr = node.userObject;
            
            [mngr runAnimationsForSequenceNamed: @"fly"];
            break;
            
        default:
            break;
    }
    
    node.visible = YES;
    
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

- (void) onCollide
{
    if(player.collided == NO)
    {
        [player onCollide];
        
        [chaser onCollide];
    }
    else
    {
        //game over
    }
}

- (void) clearCollision
{
    [chaser clearCollision];
}

- (void) update: (ccTime) delta
{
    //update camera
    CGPoint cameraPos = self.position;
    cameraPos.y = kPlayerPos.y - player.position.y;
    
    if(cameraPos.y > abs(kBackgroundLayerVerticalDisplacement))
    {
        cameraPos.y = abs(kBackgroundLayerVerticalDisplacement);
    }
    else if(cameraPos.y < kScreenHeight - kSkyHeight)
    {
        cameraPos.y = kScreenHeight - kSkyHeight;
    }
    
    self.position = cameraPos;
    
    //transform textures
    //ground
    CGRect textureRect = ground.textureRect;
    float textureOffsetX = textureRect.origin.x;
    
    float textureWidth = textureRect.size.width;
    
    textureOffsetX += delta * kPlayerSpeed;
    
    if(textureOffsetX >= textureWidth)
    {
        textureOffsetX -= textureWidth;
    }
    
    textureRect = CGRectMake(textureOffsetX, 0, textureRect.size.width, textureRect.size.height);
    [ground setTextureRect: textureRect];
    
    //back
    textureRect = back.textureRect;
    textureOffsetX = textureRect.origin.x;
    
    textureWidth = textureRect.size.width;
    
    textureOffsetX += delta * kPlayerSpeed * 0.3;
    
    if(textureOffsetX >= textureWidth)
    {
        textureOffsetX -= textureWidth;
    }
    
    textureRect = CGRectMake(textureOffsetX, 0, textureRect.size.width, textureRect.size.height);
    [back setTextureRect: textureRect];
    
    //sky
    textureRect = sky.textureRect;
    textureOffsetX = textureRect.origin.x;
    
    textureWidth = textureRect.size.width;
    
    textureOffsetX += delta * kPlayerSpeed * 0.1;
    
    if(textureOffsetX >= textureWidth)
    {
        textureOffsetX -= textureWidth;
    }
    
    textureRect = CGRectMake(textureOffsetX, 0, textureRect.size.width, textureRect.size.height);
    [sky setTextureRect: textureRect];

    
    //visible optimizations
    for(CCNode *node in objects)
    {
        //move objects
        node.position = ccpAdd(node.position, ccp(-kPlayerSpeed * delta, 0));
        
        //if(node.tag == Obj_ObstacleCrow || node.tag == )
        {
            if(node.visible == NO && node.position.x >= 1100 && node.position.x <= 1200)
            {
                node.visible = YES;
            }
            else if(node.visible == YES && node.position.x <= -100)
            {
                node.visible = NO;
            }
        }
    }
    
    //collisions
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
        
        if(ccpDistance(player.position, node.position) < 50)
        {
            switch(node.tag)
            {
                case Obj_ObstacleMayaBox:
                    [self onCollide];
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

