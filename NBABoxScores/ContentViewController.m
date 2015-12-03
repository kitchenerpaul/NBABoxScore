//
//  DateViewController.m
//  NBABoxScores
//
//  Created by Paul Kitchener on 12/2/15.
//  Copyright © 2015 Paul Kitchener. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController () {

    NSDate *previousDay;
    NSDate *nextDay;
    NSDateFormatter *dateFormatter;
    NSTimeInterval oneDay;
    int secondsInDay;

}


@end

@implementation ContentViewController

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

    self.arrayForBool = [[NSMutableArray alloc]init];
    self.sectionTitleArray = [[NSMutableArray alloc]initWithObjects: @"Game 1", @"Game 2", @"Game 3", @"Game 4", @"Game 5", @"Game 6", @"Game 7", @"Game 8", nil];

    for (int i = 0; i < self.sectionTitleArray.count; i++) {
        [self.arrayForBool addObject:[NSNumber numberWithBool:NO]];
    }

    self.expandableTableView.dataSource = self;
    self.expandableTableView.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[self.arrayForBool objectAtIndex:section] boolValue]) {
        return section + 2;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

//    static NSString *cellid;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];

    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellid"];
    }

    BOOL manyCells  = [[self.arrayForBool objectAtIndex:indexPath.section] boolValue];

    //closed
    if(!manyCells)
    {
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.text=@"";
    }
    //opened
    else
    {
        cell.textLabel.text=[NSString stringWithFormat:@"%@ Statline:%ld",[self.sectionTitleArray objectAtIndex:indexPath.section],indexPath.row + 1];
        cell.textLabel.font=[UIFont systemFontOfSize:15.0f];
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone ;
    }
    cell.textLabel.textColor=[UIColor blackColor];

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitleArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // Close section
    [self.arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:NO]];

    [self.expandableTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([[self.arrayForBool objectAtIndex:indexPath.section] boolValue]) {
        return 60;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.expandableTableView.frame.size.width, 60)];
    sectionView.tag = section;
    UILabel *viewLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.expandableTableView.frame.size.width, 60)];
    viewLabel.backgroundColor = [UIColor lightGrayColor];
    viewLabel.textColor = [UIColor whiteColor];
    viewLabel.font = [UIFont systemFontOfSize:18];
    viewLabel.textAlignment = NSTextAlignmentCenter;
    viewLabel.text = [NSString stringWithFormat:@"%@",[self.sectionTitleArray objectAtIndex:section]];
    [sectionView addSubview:viewLabel];

    UIView *separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59.5, self.view.frame.size.width, 0.5)];
    separatorLineView.backgroundColor = [UIColor whiteColor];
    separatorLineView.alpha = 0.5f;
    [sectionView addSubview:separatorLineView];

    UITapGestureRecognizer *headerTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [sectionView addGestureRecognizer:headerTapped];

    return sectionView;
}

- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
        BOOL collapsed  = [[self.arrayForBool objectAtIndex:indexPath.section] boolValue];
        for (int i = 0; i < self.sectionTitleArray.count; i++) {
            if (indexPath.section == i) {
                [self.arrayForBool replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
            }
        }
        [self.expandableTableView reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


- (IBAction)onLeftArrowPressed:(id)sender {

    previousDay = [NSDate dateWithTimeInterval:-oneDay sinceDate:self.date];
    self.dateLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:previousDay]];
    self.date = previousDay;
    oneDay++;
}

- (IBAction)onRightArrowPressed:(id)sender {
    nextDay = [NSDate dateWithTimeInterval:oneDay sinceDate:self.date];
    self.dateLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:nextDay]];
    self.date = nextDay;
    oneDay++;
}

- (IBAction)onCalendarButtonPressed:(id)sender {
}


@end
