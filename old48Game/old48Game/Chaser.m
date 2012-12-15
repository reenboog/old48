//
//  Chaser.m
//  old48Game
//
//  Created by Alex Gievsky on 15.12.12.
//  Copyright (c) 2012 spotGames. All rights reserved.
//

#import "Chaser.h"

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
    
    body = [CCSprite spriteWithFile: @"res/chaser0.png"];
    
    self.contentSize = [body boundingBox].size;
    
    [self addChild: body];
    
    self.gameDelegate = delegate;
    
    return self;
}

@end