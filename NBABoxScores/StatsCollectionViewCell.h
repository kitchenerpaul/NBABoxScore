//
//  StatsCollectionViewCell.h
//  NBABoxScores
//
//  Created by Paul Kitchener on 12/9/15.
//  Copyright © 2015 Paul Kitchener. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatsCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *statsLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UIView *bottomSeparatorView;

@end
