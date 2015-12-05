//
//  DateViewController.m
//  NBABoxScores
//
//  Created by Paul Kitchener on 12/2/15.
//  Copyright © 2015 Paul Kitchener. All rights reserved.
//

#import "ContentViewController.h"
#import "StatsTableViewCell.h"

@interface ContentViewController () <UIScrollViewDelegate>

@property StatsTableViewCell *statsCell;
@property UIScrollView *scrollView;

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.date = [NSDate new];
    NSLocale *currentLocale = [NSLocale currentLocale];
    [self.date descriptionWithLocale:currentLocale];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"MMMM dd, yyyy"];

    self.secondsInDay = 24 * 60 * 60;
    self.oneDay = self.secondsInDay;

    self.dateLabel.text = [NSString stringWithFormat:@"%@",[self.dateFormatter stringFromDate:self.date]];

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
        return 20;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    self.statsCell = [StatsTableViewCell new];
    self.statsCell = [tableView dequeueReusableCellWithIdentifier:@"StatsCellID" forIndexPath:indexPath];

    self.statsCell.playerNameLabel.text = @"Test Player";

    self.scrollView = [[UIScrollView alloc] initWithFrame:self.statsCell.frame];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.delegate = self;
    [self.scrollView setUserInteractionEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(1000, 23)];
    [self.statsCell.contentView addSubview:self.scrollView];

    return self.statsCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.expandableTableView.frame.size.width, 40)];
    sectionView.tag = section;
    UILabel *viewLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.expandableTableView.frame.size.width, 40)];
    viewLabel.backgroundColor = [UIColor lightGrayColor];
    viewLabel.textColor = [UIColor whiteColor];
    viewLabel.font = [UIFont systemFontOfSize:15.0];
    viewLabel.textAlignment = NSTextAlignmentCenter;
    viewLabel.text = [NSString stringWithFormat:@"%@",[self.sectionTitleArray objectAtIndex:section]];
    [sectionView addSubview:viewLabel];

    UIView *separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, self.view.frame.size.width, 0.5)];
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

    [self goBackOneDay];
}

- (IBAction)onRightArrowPressed:(id)sender {

    [self goForwardOneDay];
}

- (IBAction)onCalendarButtonPressed:(id)sender {
}

//-(void)scrollForCell:(UITableViewCell *)cell {
//
//    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, self.expandableTableView.frame.size.width, cell.frame.size.height)];
////    [self.scrollView bringSubviewToFront:self.scrollView];
//    self.scrollView.backgroundColor = [UIColor redColor];
//    self.scrollView.scrollEnabled = YES;
//    self.scrollView.delegate = self;
//    [self.scrollView setUserInteractionEnabled:YES];
//    [self.scrollView setContentSize:CGSizeMake(cell.frame.origin.x + 500, cell.frame.origin.y)];
//    [cell.contentView addSubview:self.scrollView];
//
//    frame = (0 200; 375 23);
//}

- (void)goForwardOneDay {

    self.nextDay = [NSDate dateWithTimeInterval:self.oneDay sinceDate:self.date];
    self.dateLabel.text = [NSString stringWithFormat:@"%@",[self.dateFormatter stringFromDate:self.nextDay]];
    self.date = self.nextDay;
    self.oneDay++;
}

-(void)goBackOneDay {

    self.previousDay = [NSDate dateWithTimeInterval:-self.oneDay sinceDate:self.date];
    self.dateLabel.text = [NSString stringWithFormat:@"%@",[self.dateFormatter stringFromDate:self.previousDay]];
    self.date = self.previousDay;
    self.oneDay++;
}


@end
