
#import "Player.h"
#import "GameConfig.h"

@interface Player ()

@end

@implementation Player

@synthesize gameDelegate;
@synthesize state;

- (void) dealloc
{
    [super dealloc];
}

- (id) initWithGameDelegate: (id<GameDelegate>) delegate
{
    if((self = [super init]))
    {
        
    }
    
    body = [CCSprite spriteWithFile: @"res/player0.png"];
    body.position = ccp(0, 0);
    
    self.contentSize = [body boundingBox].size;
    
    [self addChild: body];
    
    self.gameDelegate = delegate;
    
    state = PS_Undefined;
    
    return self;
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
    
    [self runAction:
                    [CCSequence actions:
                                        [CCEaseBackIn actionWithAction:
                                                                        [CCMoveBy actionWithDuration: kPlayerDodgeTime
                                                                                            position: kPlayerDodgeDelta
                                                                        ]
                                        ],
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
                                                                             [self run];
                                                                             self.rotation = 0;
                                                                         }
                                            ],
                                            nil
                        ]
        ];
    }
    else
    {
        return;
    }
}

- (void) run
{
    
    state = PS_Running;
}

@end