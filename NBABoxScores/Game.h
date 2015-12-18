//
//  Game.h
//  NBABoxScores
//
//  Created by Paul Kitchener on 12/10/15.
//  Copyright © 2015 Paul Kitchener. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Game : NSObject

// Info from JSON

@property NSMutableArray *games;
@property NSDictionary *homeTeamDictionary;
@property NSDictionary *awayTeamDictionary;
@property NSString *homeTeamName;
@property NSString *awayTeamName;
@property NSMutableArray *homePlayers;
@property NSMutableArray *awayPlayers;
@property NSDictionary *statsDictionary;
@property NSMutableArray *minutesArray;
@property NSMutableArray *pointsArray;
@property NSMutableArray *fgmaArray;
@property NSMutableArray *threepmaArray;
@property NSMutableArray *ftmaArray;
@property NSMutableArray *offRebArray;
@property NSMutableArray *defRebArray;
@property NSMutableArray *totRebArray;
@property NSMutableArray *assistsArray;
@property NSMutableArray *stealsArray;
@property NSMutableArray *blocksArray;
@property NSMutableArray *turnoversArray;
@property NSMutableArray *foulsArray;
@property NSMutableArray *plusMinusArray;

-(instancetype)initWithDictionary:(NSDictionary *)jsonDictionary;

@end
