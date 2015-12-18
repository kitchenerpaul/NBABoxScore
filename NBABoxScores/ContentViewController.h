//
//  DateViewController.h
//  NBABoxScores
//
//  Created by Paul Kitchener on 12/2/15.
//  Copyright © 2015 Paul Kitchener. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContentViewController;

@protocol ContentViewControllerDelegate <NSObject>

-(void)goForwardOneDay;
-(void)goBackOneDay;

@end

@interface ContentViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITableView *expandableTableView;
@property NSDate *date;
@property NSMutableArray *sectionTitleArray;
@property NSMutableArray *arrayForBool;
@property NSInteger page;
@property NSDate *previousDay;
@property NSDate *nextDay;
@property NSDateFormatter *dateFormatter;
@property NSTimeInterval oneDay;
@property int secondsInDay;
@property BOOL isHomeTeam;

@property (nonatomic, assign) id<ContentViewControllerDelegate> delegate;

@end
