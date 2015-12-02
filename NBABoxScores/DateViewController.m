//
//  DateViewController.m
//  NBABoxScores
//
//  Created by Paul Kitchener on 12/2/15.
//  Copyright © 2015 Paul Kitchener. All rights reserved.
//

#import "DateViewController.h"

@interface DateViewController ()

@end

@implementation DateViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.date = [NSDate new];
    NSLocale *currentLocale = [NSLocale currentLocale];
    [self.date descriptionWithLocale:currentLocale];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    NSLog(@"%@",[dateFormatter stringFromDate:self.date]);

    self.dateLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:self.date]];
}

- (IBAction)onLeftArrowPressed:(id)sender {

    NSLog(@"%@", self.date);
}

- (IBAction)onRightArrowPressed:(id)sender {
}

- (IBAction)onCalendarButtonPressed:(id)sender {
}


@end
