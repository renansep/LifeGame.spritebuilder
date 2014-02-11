//
//  Level.m
//  LifeGame
//
//  Created by Renan Benevides Cargnin on 2/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Level.h"
#import "Cell.h"

@implementation Level

@synthesize cells, gameSize, animating;

- (void)didLoadFromCCB
{
    gameSize = 20;
    cells = [[NSMutableArray alloc] initWithCapacity:gameSize];
    for (int i=0; i<gameSize; i++)
    {
        cells[i] = [[NSMutableArray alloc] initWithCapacity:gameSize];
    }
    
    for (int i=0; i<gameSize; i++)
    {
        for (int j=0; j<gameSize; j++)
        {
            cells[i][j] = [CCBReader load:@"Cell"];
            Cell *c = cells[i][j];
            [c setScale:self.contentSize.width / c.contentSize.width / gameSize];
            [c setPosition:ccp(i * [c width] + [c width] / 2,
                               self.contentSize.height - j * [c height] - [c height] / 2)];
            [self addChild:c];
        }
    }
    
    for (int i=0; i<gameSize; i++)
    {
        for (int j=0; j<gameSize; j++)
        {
            [self setUpNeighborsForCellWithLine:i andColumn:j];
        }
    }
    [self setAnimating:NO];
    self.userInteractionEnabled = YES;
}

- (void)clear:(id)sender
{
    for (int i=0; i<gameSize; i++)
    {
        for (int j=0; j<gameSize; j++)
        {
            Cell *c = cells[i][j];
            [c die];
        }
    }
    [self setAnimating:NO];
}

- (void)next:(id)sender
{
    [self gameIteration];
}

- (void)animate:(id)sender
{
    [self setAnimating:YES];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    Cell *c = [self getTouchedCell:[touch locationInWorld]];
    if (c != nil)
    {
        [c live];
    }
}

- (void)update:(CCTime)delta
{
    if ([self animating])
    {
        [self gameIteration];
    }
}

- (void)random:(id)sender
{
    for (int i=0; i<gameSize; i++)
    {
        for (int j=0; j<gameSize; j++)
        {
            if (arc4random() % 2 == 1)
            {
                Cell *c = cells[i][j];
                [c live];
            }
        }
    }
}

- (Cell *)getTouchedCell:(CGPoint)pos
{
    for (int i=0; i<gameSize; i++)
    {
        for (int j=0; j<gameSize; j++)
        {
            Cell *c = cells[i][j];
            if
                (
                 (pos.x > c.position.x - [c width] / 2) &&
                 (pos.x < c.position.x + [c width] / 2) &&
                 (pos.y > c.position.y - [c height] / 2) &&
                 (pos.y < c.position.y + [c height] / 2)
                 )
            {
                return c;
            }
        }
    }
    return nil;
}
/*
 There is a grid of cells.
 A cell is either alive or dead.
 If a cell has less than two live neighbors, it dies.
 If it has more than three neighbors, it dies.
 If a dead cell has exactly three neighbors, it comes to life.
 */
- (void)gameIteration
{
    for (int i=0; i<gameSize; i++)
    {
        for (int j=0; j<gameSize; j++)
        {
            Cell *cell = cells[i][j];
            
            //If a cell has less than two live neighbors, it dies.
            if ([cell alive])
            {
                int aliveNeighbors = 0;
                for (Cell *c in [cell neighbors])
                {
                    if ([c alive])
                        aliveNeighbors++;
                }
                if (aliveNeighbors < 2 || aliveNeighbors > 3)
                    [cell setWillDie:YES];
            }
            //cell is dead
            else
            {
                int aliveNeighbors = 0;
                for (Cell *c in [cell neighbors])
                {
                    if ([c alive])
                        aliveNeighbors++;
                }
                if (aliveNeighbors == 3)
                    [cell setWillLive:YES];
            }
            
            
        }
    }
    
    for (int i=0; i<gameSize; i++)
    {
        for (int j=0; j<gameSize; j++)
        {
            Cell *cell = cells[i][j];
            
            if ([cell willLive])
            {
                [cell live];
            }
            if ([cell willDie])
            {
                [cell die];
            }
        }
    }
}

- (void)setUpNeighborsForCellWithLine:(int)line andColumn:(int)column
{
    Cell *c = cells[line][column];
    //Top-left corner
    if (line == 0 && column == 0)
    {
        [[c neighbors] addObject:cells[gameSize-1][gameSize-1]];
        [[c neighbors] addObject:cells[line][gameSize-1]];
        [[c neighbors] addObject:cells[line+1][gameSize-1]];
        [[c neighbors] addObject:cells[gameSize-1][column]];//2 3
        [[c neighbors] addObject:cells[line+1][column]];//2 3
        [[c neighbors] addObject:cells[gameSize-1][column+1]];//2
        [[c neighbors] addObject:cells[line][column+1]];//2
        [[c neighbors] addObject:cells[line+1][column+1]];//2
    }
    //Top line
    else if (line == 0 && column != gameSize - 1)
    {
        [[c neighbors] addObject:cells[gameSize-1][column-1]];
        [[c neighbors] addObject:cells[line][column-1]];
        [[c neighbors] addObject:cells[line+1][column-1]];
        [[c neighbors] addObject:cells[gameSize-1][column]];//1 3
        [[c neighbors] addObject:cells[line+1][column]];//1 3
        [[c neighbors] addObject:cells[gameSize-1][column+1]];//1
        [[c neighbors] addObject:cells[line][column+1]];//1
        [[c neighbors] addObject:cells[line+1][column+1]];//1
    }
    //Top-right corner
    else if (line == 0 && column == gameSize - 1)
    {
        [[c neighbors] addObject:cells[gameSize-1][column-1]];//2
        [[c neighbors] addObject:cells[line][column-1]];//2
        [[c neighbors] addObject:cells[line+1][column-1]];//2
        [[c neighbors] addObject:cells[gameSize-1][column]];//1 2
        [[c neighbors] addObject:cells[line+1][column]];//1 2
        [[c neighbors] addObject:cells[gameSize-1][0]];
        [[c neighbors] addObject:cells[line][0]];
        [[c neighbors] addObject:cells[line+1][0]];
    }
    //Left column
    else if (column == 0 && line != gameSize - 1)
    {
        [[c neighbors] addObject:cells[line-1][gameSize-1]];
        [[c neighbors] addObject:cells[line][gameSize-1]];
        [[c neighbors] addObject:cells[line+1][gameSize-1]];
        [[c neighbors] addObject:cells[line-1][column]];
        [[c neighbors] addObject:cells[line+1][column]];//1 2 3
        [[c neighbors] addObject:cells[line-1][1]];
        [[c neighbors] addObject:cells[line][1]];
        [[c neighbors] addObject:cells[line+1][1]];
    }
    //Bottom-left corner
    else if (column == 0 && line == gameSize - 1)
    {
        [[c neighbors] addObject:cells[line-1][gameSize-1]];
        [[c neighbors] addObject:cells[line][gameSize-1]];
        [[c neighbors] addObject:cells[0][gameSize-1]];
        [[c neighbors] addObject:cells[line-1][column]];
        [[c neighbors] addObject:cells[0][column]];
        [[c neighbors] addObject:cells[line-1][1]];
        [[c neighbors] addObject:cells[line][1]];
        [[c neighbors] addObject:cells[0][1]];
    }
    //Bottom line
    else if (column != gameSize - 1 && line == gameSize - 1)
    {
        [[c neighbors] addObject:cells[line-1][column-1]];
        [[c neighbors] addObject:cells[line][column-1]];
        [[c neighbors] addObject:cells[0][column-1]];
        [[c neighbors] addObject:cells[line-1][column]];
        [[c neighbors] addObject:cells[0][column]];
        [[c neighbors] addObject:cells[line-1][column+1]];
        [[c neighbors] addObject:cells[line][column+1]];
        [[c neighbors] addObject:cells[0][column+1]];
    }
    //Bottom-right corner
    else if (column == gameSize - 1 && line == gameSize - 1)
    {
        [[c neighbors] addObject:cells[line-1][column-1]];
        [[c neighbors] addObject:cells[line][column-1]];
        [[c neighbors] addObject:cells[0][column-1]];
        [[c neighbors] addObject:cells[line-1][column]];
        [[c neighbors] addObject:cells[0][column]];
        [[c neighbors] addObject:cells[line-1][0]];
        [[c neighbors] addObject:cells[line][0]];
        [[c neighbors] addObject:cells[0][0]];
    }
    //Right column
    else if (column == gameSize - 1 && line != gameSize - 1)
    {
        [[c neighbors] addObject:cells[line-1][column-1]];
        [[c neighbors] addObject:cells[line][column-1]];
        [[c neighbors] addObject:cells[line+1][column-1]];
        [[c neighbors] addObject:cells[line-1][column]];
        [[c neighbors] addObject:cells[line+1][column]];
        [[c neighbors] addObject:cells[line-1][0]];
        [[c neighbors] addObject:cells[line][0]];
        [[c neighbors] addObject:cells[line+1][0]];
    }
    //Middle
    else
    {
        [[c neighbors] addObject:cells[line-1][column-1]];
        [[c neighbors] addObject:cells[line][column-1]];
        [[c neighbors] addObject:cells[line+1][column-1]];
        [[c neighbors] addObject:cells[line-1][column]];
        [[c neighbors] addObject:cells[line+1][column]];
        [[c neighbors] addObject:cells[line-1][column+1]];
        [[c neighbors] addObject:cells[line][column+1]];
        [[c neighbors] addObject:cells[line+1][column+1]];
    }
}

@end
