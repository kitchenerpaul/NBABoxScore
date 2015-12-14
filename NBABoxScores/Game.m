//
//  Game.m
//  NBABoxScores
//
//  Created by Paul Kitchener on 12/10/15.
//  Copyright © 2015 Paul Kitchener. All rights reserved.
//

#import "Game.h"

@implementation Game

-(instancetype)initWithDictionary:(NSDictionary *)jsonDictionary {

    self = [super init];

    if (self) {
 
        self.games = [NSMutableArray new];
        self.games = [jsonDictionary objectForKey:@"Date"];

        for (NSDictionary *dictionary in self.games) {
            self.homeTeamDictionary = [dictionary objectForKey:@"Home Team"];
            self.homeTeamName = [self.homeTeamDictionary objectForKey:@"Team Name"];
            self.homePlayers = [self.homeTeamDictionary objectForKey:@"Players"];
            self.statsDictionary = [self.homeTeamDictionary objectForKey:@"Stats"];
            self.minutesArray = [self.statsDictionary objectForKey:@"MIN"];
            self.pointsArray = [self.statsDictionary objectForKey:@"PTS"];
            self.fgmaArray = [self.statsDictionary objectForKey:@"FGM-A"];
            self.threepmaArray = [self.statsDictionary objectForKey:@"3PM-A"];
            self.ftmaArray = [self.statsDictionary objectForKey:@"FTM-A"];
            self.offRebArray = [self.statsDictionary objectForKey:@"OFF"];
            self.defRebArray = [self.statsDictionary objectForKey:@"DEF"];
            self.totRebArray = [self.statsDictionary objectForKey:@"TOT"];
            self.assistsArray = [self.statsDictionary objectForKey:@"AST"];
            self.stealsArray = [self.statsDictionary objectForKey:@"STL"];
            self.blocksArray = [self.statsDictionary objectForKey:@"BLK"];
            self.turnoversArray = [self.statsDictionary objectForKey:@"TO"];
            self.foulsArray = [self.statsDictionary objectForKey:@"PF"];
            self.plusMinusArray = [self.statsDictionary objectForKey:@"+/-"];

            self.awayTeamDictionary = [dictionary objectForKey:@"Away Team"];
            self.awayTeamName = [self.awayTeamDictionary objectForKey:@"Team Name"];

        }

    }
    return self;
}



@end
