//
//  PlayerCollectionViewCell.h
//  NBABoxScores
//
//  Created by Paul Kitchener on 12/9/15.
//  Copyright © 2015 Paul Kitchener. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UIView *bottomSeparatorView;

@end
