//
//  DateViewController.h
//  NBABoxScores
//
//  Created by Paul Kitchener on 12/2/15.
//  Copyright © 2015 Paul Kitchener. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DateViewController;

@protocol DateViewControllerDelegate <NSObject>

-(void)goForwardOneDay;


@end

@interface DateViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property NSDate *date;

@property (nonatomic, assign) id<DateViewControllerDelegate> delegate;

@end
