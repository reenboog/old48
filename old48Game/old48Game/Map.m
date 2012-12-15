//
//  Map.m
//  old48Game
//
//  Created by Vlad on 15.12.12.
//  Copyright 2012 spotGames. All rights reserved.
//

#import "Map.h"
#import "CCBReader.h"
#import "GameConfig.h"

@implementation Map


- (void) didLoadFromCCB
{
    
    
    CCArray *arr = [self children];
    for(CCNode *mynode in arr)
    {
        if(mynode.tag == kParentTag)
        {
            CCArray *arrMenu = [mynode children];
            for(CCNode *menuNode in arrMenu)
            {
                if(menuNode.tag = kMenuTag)
                {
                    CCArray *arrMenuElements = [menuNode children];
//                    for(CCNode *menuElement in arrMenuElements)
//                    {
                        [self checkAvaiability: arrMenuElements];
//                    }
                }
            }
        }
    }
}

- (void) checkAvaiability: (CCArray *) elementsArray
{
    for(int i = 0; i < countOfOpenedLevels; i++)
    {
        CCNode *curElement = [elementsArray objectAtIndex: i];
        curElement.visible = YES;
    }
}

- (void) pressedPlay: (CCMenuItemImage *) sender
{
    if(sender.tag % kMultiplier == 0)
    {
        if(countOfBrilliant < (sender.tag - kMultiplier) * kMultiplier)
        {
            CCLOG(@"No!");
        }
        else
        {
            CCLOG(@"curLevel: %i", sender.tag);
        }
    }
    else
    {
        CCLOG(@"curLevel: %i", sender.tag);
    }
}


@end
