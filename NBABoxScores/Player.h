//
//  Player.h
//  NBABoxScores
//
//  Created by Paul Kitchener on 12/17/15.
//  Copyright © 2015 Paul Kitchener. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

@property NSString *name;
@property NSDictionary *statsDictionary;

-(instancetype)initWithDictionary:(NSDictionary *)jsonDictionary;

@end
