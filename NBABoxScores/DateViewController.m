//
//  DateViewController.m
//  NBABoxScores
//
//  Created by Paul Kitchener on 12/2/15.
//  Copyright © 2015 Paul Kitchener. All rights reserved.
//

#import "DateViewController.h"

@interface DateViewController () <UITableViewDelegate, UITableViewDataSource> {

    NSDate *previousDay;
    NSDate *nextDay;
    NSDateFormatter *dateFormatter;
    NSTimeInterval oneDay;
    int secondsInDay;

}

@property (weak, nonatomic) IBOutlet UITableView *expandableTableView;


@end

@implementation DateViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.date = [NSDate new];
    NSLocale *currentLocale = [NSLocale currentLocale];
    [self.date descriptionWithLocale:currentLocale];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];

    secondsInDay = 24 * 60 * 60;
    oneDay = secondsInDay;

    self.dateLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:self.date]];
}

- (IBAction)onLeftArrowPressed:(id)sender {

    previousDay = [NSDate dateWithTimeInterval:-oneDay sinceDate:self.date];
    self.dateLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:previousDay]];
    self.date = previousDay;
    oneDay ++;
}

- (IBAction)onRightArrowPressed:(id)sender {
    nextDay = [NSDate dateWithTimeInterval:oneDay sinceDate:self.date];
    self.dateLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:nextDay]];
    self.date = nextDay;
    oneDay ++;
}

- (IBAction)onCalendarButtonPressed:(id)sender {
}


@end
