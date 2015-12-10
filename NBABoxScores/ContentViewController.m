//
//  DateViewController.m
//  NBABoxScores
//
//  Created by Paul Kitchener on 12/2/15.
//  Copyright © 2015 Paul Kitchener. All rights reserved.
//

#import "ContentViewController.h"
#import "StatsTableViewCell.h"
#import "StatsLayout.h"
#import "PlayerCollectionViewCell.h"
#import "StatsCollectionViewCell.h"
#import "StatsCollectionView.h"

@interface ContentViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property StatsTableViewCell *statsCell;

@property StatsCollectionView *statsCollectionView;



@property PlayerCollectionViewCell *playerCell;
@property StatsCollectionViewCell *statsCollectionCell;
@property StatsLayout *statsLayout;

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.statsCollectionView = [StatsCollectionView new];
//    NSLog(@"SCV height: %f", self.statsCollectionView.bounds.size.height);

    self.date = [NSDate new];
    NSLocale *currentLocale = [NSLocale currentLocale];
    [self.date descriptionWithLocale:currentLocale];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"MMMM dd, yyyy"];

    self.secondsInDay = 24 * 60 * 60;
    self.oneDay = self.secondsInDay;

    self.dateLabel.text = [NSString stringWithFormat:@"%@",[self.dateFormatter stringFromDate:self.date]];

    self.arrayForBool = [[NSMutableArray alloc]init];
    self.sectionTitleArray = [[NSMutableArray alloc]initWithObjects: @"GAME 1", @"GAME 2", @"GAME 3", @"GAME 4", @"GAME 5", @"GAME 6", @"GAME 7", @"GAME 8", nil];

    for (int i = 0; i < self.sectionTitleArray.count; i++) {
        [self.arrayForBool addObject:[NSNumber numberWithBool:NO]];
    }

    self.expandableTableView.dataSource = self;
    self.expandableTableView.delegate = self;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[self.arrayForBool objectAtIndex:section] boolValue]) {
        return 1;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    self.statsCell = [StatsTableViewCell new];
    self.statsCell = [tableView dequeueReusableCellWithIdentifier:@"StatsCellID" forIndexPath:indexPath];

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
//    viewLabel.font = [UIFont systemFontOfSize:15.0];
    viewLabel.font = [UIFont boldSystemFontOfSize:13.0];
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

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 15;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 15;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.playerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayerCollectionViewCellID" forIndexPath:indexPath];
            self.playerCell.backgroundColor = [UIColor colorWithRed:.1 green:.3 blue:.5 alpha:1];
            self.playerCell.playerNameLabel.font = [UIFont systemFontOfSize:11.0];
            self.playerCell.playerNameLabel.textColor = [UIColor whiteColor];
            self.playerCell.playerNameLabel.text = @"Team";
            self.playerCell.separatorView.hidden = YES;
            self.playerCell.bottomSeparatorView.hidden = YES;

            return self.playerCell;

        } else {
            self.statsCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StatsCollectionViewCellID" forIndexPath:indexPath];
            self.statsCollectionCell.statsLabel.font = [UIFont systemFontOfSize:11.0];
            self.statsCollectionCell.statsLabel.textColor = [UIColor darkGrayColor];
            self.statsCollectionCell.statsLabel.text = [NSString stringWithFormat:@"Stat%li", (long)indexPath.row];
            self.statsCollectionCell.separatorView.backgroundColor = [UIColor whiteColor];
            self.statsCollectionCell.backgroundColor = [UIColor colorWithRed:.82 green:.82 blue:.82 alpha:1];
            self.statsCollectionCell.bottomSeparatorView.hidden = YES;

            return self.statsCollectionCell;
        }

    } else {
        if (indexPath.row == 0) {

            self.playerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayerCollectionViewCellID" forIndexPath:indexPath];
            self.playerCell.playerNameLabel.font = [UIFont systemFontOfSize:9.5];
            self.playerCell.playerNameLabel.textColor = [UIColor blackColor];
            self.playerCell.playerNameLabel.text = [NSString stringWithFormat:@"Player %li", (long)indexPath.section];
            if (indexPath.section %2 != 0) {
                self.playerCell.backgroundColor = [UIColor whiteColor];
            } else {
                self.playerCell.backgroundColor = [UIColor whiteColor];
            }

            return self.playerCell;

        } else {

            self.statsCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StatsCollectionViewCellID" forIndexPath:indexPath];
            self.statsCollectionCell.statsLabel.font = [UIFont systemFontOfSize:9.5];
            self.statsCollectionCell.statsLabel.textColor = [UIColor blackColor];
            self.statsCollectionCell.statsLabel.text = @"Number";

            if (indexPath.section % 2 != 0) {
                self.statsCollectionCell.backgroundColor = [UIColor whiteColor];
            } else {
                self.statsCollectionCell.backgroundColor = [UIColor whiteColor];
            }

            return self.statsCollectionCell;
        }
    }

}

//- (void)reloadItemsAtIndexPaths:(NSArray *)indexPaths {
//    BOOL animationsEnabled = [UIView areAnimationsEnabled];
//    [UIView setAnimationsEnabled:NO];
//    [self.collectionView reloadItemsAtIndexPaths:indexPaths];
//    [UIView setAnimationsEnabled:animationsEnabled];
//    
//}


@end
