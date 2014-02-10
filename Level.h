//
//  Level.h
//  LifeGame
//
//  Created by Renan Benevides Cargnin on 2/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Level : CCNode
{
    NSMutableArray *cells;
    int gameSize;
    BOOL animating;
}

@property int gameSize;
@property NSMutableArray *cells;
@property BOOL animating;

@end
