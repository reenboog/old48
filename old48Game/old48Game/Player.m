
#import "Player.h"
#import "GameConfig.h"
#import "CCBReader.h"
#import "CCBAnimationManager.h"
#import "SimpleAudioEngine.h"

@interface Player ()

@end

@implementation Player

@synthesize gameDelegate;
@synthesize state;
@synthesize body;

@synthesize collided;

- (void) dealloc
{
    [runningSound release];
    
    [super dealloc];
}

- (id) initWithGameDelegate: (id<GameDelegate>) delegate
{
    if((self = [super init]))
    {
        
    }
    
    body = [CCBReader nodeGraphFromFile: @"hero.ccbi"];
    body.position = ccp(0, 0);
    
    self.contentSize = CGSizeMake(128, 128);
    
    [self addChild: body];
    
    self.gameDelegate = delegate;
    
    state = PS_Undefined;
    
    [self scheduleUpdate];
    
    collisionState = PCS_Clean;
    
    [self run];
    
    return self;
}

 - (void) update: (ccTime) dt
{
    if(collisionState == PCS_Collided)
    {
        CGPoint pos = self.position;
        pos.x -= dt * 200;
        
        self.position = pos;
    }
}

#pragma mark - Action logic

- (void) jump
{
    if(state != PS_Running)
    {
        //can't jump while jumping or tumbling
        CCLOG(@"wrong state. can't jump");
        return;
    }
    
    CCLOG(@"jumping");
    
    state = PS_Jumping;

    positionBeforeAction = self.position;
    
    CCBAnimationManager *animationManager = body.userObject;
    
    [animationManager runAnimationsForSequenceNamed: @"jump"
                                      tweenDuration: 0.1
    ];
    
    [self runAction:
                    [CCSequence actions:
                                        [CCJumpTo actionWithDuration: kPlayerJumpTime
                                                            position: positionBeforeAction
                                                              height: kPlayerJumpHeight
                                                               jumps: 1
                                        ],
                                        //[CCMoveTo actionWithDuration: 0.2 position: positionBeforeJump],
                                        [CCCallBlock actionWithBlock: ^(void)
                                                                     {
                                                                         //state = PS_Running;
                                                                         [self run];
                                                                     }
                                        ],
                                        nil
                    ]
    ];
    
    [runningSound stop];
    [runningSound release];
    
    runningSound = nil;
    
    [[SimpleAudioEngine sharedEngine] playEffect: @"jump.mp3"];
}

- (void) dodge
{
    if(state != PS_Running)
    {
        return;
    }
    
    CCLOG(@"dodging");
    
    state = PS_Dodging;
    
    positionBeforeAction = self.position;
    
    CCBAnimationManager *animationManager = body.userObject;
    
    [animationManager runAnimationsForSequenceNamed: @"dodge"
                                      tweenDuration: 0.1
    ];
    
    [self runAction:
                    [CCSequence actions:
                                        [CCEaseBackIn actionWithAction:
                                                                        [CCMoveBy actionWithDuration: kPlayerDodgeTime
                                                                                            position: kPlayerDodgeDelta
                                                                        ]
                                        ],
                                        [CCDelayTime actionWithDuration: 0.7],
                                        [CCMoveTo actionWithDuration: kPlayerDodgeTime / 2.0
                                                            position: positionBeforeAction
                                        ],
                                        [CCCallBlock actionWithBlock: ^(void)
                                                                     {
                                                                         [self run];
                                                                     }
                                        ],
                                        nil
                    ]
    ];
    
    [runningSound stop];
    [runningSound release];
    
    runningSound = nil;
    
    [[SimpleAudioEngine sharedEngine] playEffect: @"slide.mp3"];
}

- (void) tumble;
{
    if(!canTumble)
    {
        //CCLOG(@"can't tumble yet.");
        //return;
    }
    
    CCLOG(@"tumbling");
    
    CGPoint delta = ccpSub(positionBeforeAction, self.position);
    
    if(state == PS_Jumping)
    {
        //tumble
        
        [self stopAllActions];

        state = PS_Tumbling;
        
        CCBAnimationManager *animationManager = body.userObject;
    
        [animationManager runAnimationsForSequenceNamed: @"tumble"
                                          tweenDuration: 0.1
        ];

        [self runAction:
                        [CCSequence actions:
                                            [CCSpawn actions:
                                                            [CCRotateTo actionWithDuration: kPlayerTumbleTime
                                                                                     angle: 720
                                                            ],
                                                            [CCJumpBy actionWithDuration: kPlayerTumbleTime
                                                                                position: delta
                                                                                  height: kPlayerTumbleHeight
                                                                                   jumps: 1
                                                            ],
                                                            nil
                                            ],
                                            [CCCallBlock actionWithBlock: ^(void)
                                                                         {
                                                                             //state = PS_Running;
                                                                             self.rotation = 0;
                                                                             [self run];
                                                                         }
                                            ],
                                            nil
                        ]
        ];
        
        [runningSound stop];
        [runningSound release];
        
        runningSound = nil;
        
        [[SimpleAudioEngine sharedEngine] playEffect: @"tumble.mp3"];
    }
    else
    {
        return;
    }
}

- (void) run
{
    CCBAnimationManager *animationManager = body.userObject;
    
    [animationManager runAnimationsForSequenceNamed: @"run"
                                      tweenDuration: 0.1
    ];
    
    [runningSound stop];
    [runningSound release];
    
    runningSound = nil;
    runningSound = [[SimpleAudioEngine sharedEngine] soundSourceForFile: @"run.mp3"];
    
    runningSound.looping = YES;
    [runningSound play];
    [runningSound retain];
    
    //[[SimpleAudioEngine sharedEngine] playEffect: ];
    
//    [self runAction:
//                    [CCRepeatForever actionWithAction:
//                                                    [CCSequence actions:
//                                                                        [CCMoveTo actionWithDuration: 0.1
//                                                                                            position: ccpAdd(kPlayerPos, ccp(0, 5))
//                                                                        ],
//                                                                        [CCMoveTo actionWithDuration: 0.1 position: kPlayerPos],
//                                                                        nil
//                                                    ]
//                    ]
//    ];
    
    state = PS_Running;
}

- (void) onCollide
{
    collided = YES;

    [self schedule: @selector(clearCollision) interval: 2];
    
    [self runAction:
                    [CCBlink actionWithDuration: 0.7 blinks: 3]
    ];
}

- (void) clearCollision
{
    [self unschedule: _cmd];
    [gameDelegate clearCollision];
    
    collided = NO;
}

@end