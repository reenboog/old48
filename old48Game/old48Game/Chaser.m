//
//  Chaser.m
//  old48Game
//
//  Created by Alex Gievsky on 15.12.12.
//  Copyright (c) 2012 spotGames. All rights reserved.
//
#import "GameConfig.h"

#import "Chaser.h"
#import "CCBReader.h"
#import "CCBAnimationManager.h"

@interface Chaser ()

@end

@implementation Chaser

- (void) dealloc
{
    [super dealloc];
}

- (id) initWithGameDelegate: (id<GameDelegate>) delegate
{
    if((self = [super init]))
    {
        
    }
    
    body = [CCBReader nodeGraphFromFile: @"chaser.ccbi"];
    
    self.contentSize = [body boundingBox].size;
    
    [self addChild: body];
    
    self.gameDelegate = delegate;
    
    CCBAnimationManager *mngr = body.userObject;
    
    [mngr runAnimationsForSequenceNamed: @"chase"];
    
    return self;
}

- (void) onCollide
{
    [self runAction:
                    [CCMoveTo actionWithDuration: 1
                                        position: kChaserCollidedPosition
                    ]
    ];
}

- (void) clearCollision
{
    [self runAction:
                    [CCMoveTo actionWithDuration: 2
                                        position: kChaserPos
                    ]
    ];
}

@end