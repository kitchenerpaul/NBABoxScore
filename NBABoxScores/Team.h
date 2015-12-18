//
//  Team.h
//  NBABoxScores
//
//  Created by Paul Kitchener on 12/17/15.
//  Copyright © 2015 Paul Kitchener. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Team : NSObject

@property BOOL isHomeTeam;
@property NSString *name;
@property NSArray *players;

-(void)getStatTotals: (NSArray *)playerStats;

@end
