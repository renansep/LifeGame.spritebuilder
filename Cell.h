//
//  Cell.h
//  LifeGame
//
//  Created by Renan Benevides Cargnin on 2/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Cell : CCSprite
{
    BOOL alive;
    NSMutableArray *neighbors;
    BOOL willLive;
    BOOL willDie;
}

@property BOOL alive, willLive, willDie;
@property NSMutableArray *neighbors;

- (float)width;
- (float)height;
- (void)changeState;
- (void)die;
- (void)live;

@end
