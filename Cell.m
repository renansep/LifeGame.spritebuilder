//
//  Cell.m
//  LifeGame
//
//  Created by Renan Benevides Cargnin on 2/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Cell.h"

@implementation Cell

@synthesize alive, neighbors, willDie, willLive;

- (void)didLoadFromCCB
{
    [self setAlive:NO];
    [self setNeighbors:[[NSMutableArray alloc] init]];
}

- (float)width
{
    return self.contentSize.width * self.scale;
}

- (float)height
{
    return self.contentSize.height * self.scale;
}

- (void)changeState
{
    if ([self alive])
    {
        [self die];
    }
    else
    {
        [self live];
    }
}

- (void)die
{
    [self setAlive:NO];
    [self setColor:[CCColor colorWithRed:1 green:1 blue:1]];
    [self setWillLive:NO];
    [self setWillDie:NO];
}

- (void)live
{
    [self setAlive:YES];
    [self setColor:[CCColor colorWithRed:1 green:0 blue:0]];
    [self setWillLive:NO];
    [self setWillDie:NO];
}

@end
