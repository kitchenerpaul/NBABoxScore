//
//  StatsTableViewCell.h
//  NBABoxScores
//
//  Created by Paul Kitchener on 12/4/15.
//  Copyright © 2015 Paul Kitchener. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *fgmaLabel;


@end
