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
#import "Game.h"

@interface ContentViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property StatsTableViewCell *statsCell;

@property StatsCollectionView *statsCollectionView;

@property PlayerCollectionViewCell *playerCell;
@property StatsCollectionViewCell *statsCollectionCell;
@property StatsLayout *statsLayout;

@property Game *game;

@property NSMutableArray *statTitlesArray;




@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    /////// Game JSON

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"game" ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:filePath];

    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];

    self.game = [[Game alloc] initWithDictionary:jsonDict];

    // Date & Time Related

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
    viewLabel.font = [UIFont boldSystemFontOfSize:13.0];
    viewLabel.textAlignment = NSTextAlignmentCenter;
    viewLabel.text = [NSString stringWithFormat:@"%@ VS Away Team",self.game.homeTeamName];
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
    return self.game.statsDictionary.count + 1;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.game.homePlayers.count + 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.playerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayerCollectionViewCellID" forIndexPath:indexPath];
            self.playerCell.backgroundColor = [UIColor colorWithRed:.1 green:.3 blue:.5 alpha:1];
            self.playerCell.playerNameLabel.font = [UIFont systemFontOfSize:12.0];
            self.playerCell.playerNameLabel.textColor = [UIColor whiteColor];
            self.playerCell.playerNameLabel.text = [NSString stringWithFormat:@"%@", self.game.homeTeamName];
            self.playerCell.separatorView.hidden = YES;
            self.playerCell.bottomSeparatorView.hidden = YES;

            return self.playerCell;

        } else {
            self.statsCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StatsCollectionViewCellID" forIndexPath:indexPath];

            self.statTitlesArray = [[NSMutableArray alloc] initWithObjects:@"", nil];
            NSArray *tempArray = [self.game.statsDictionary allKeys];
            [self.statTitlesArray addObjectsFromArray:tempArray];
            self.statsCollectionCell.statsLabel.text = [self.statTitlesArray objectAtIndex:indexPath.row];

            NSLog(@"Stat Titles: %@", self.statTitlesArray);


            self.statsCollectionCell.statsLabel.font = [UIFont systemFontOfSize:11.0];
            self.statsCollectionCell.statsLabel.textColor = [UIColor darkGrayColor];
            self.statsCollectionCell.separatorView.backgroundColor = [UIColor whiteColor];
            self.statsCollectionCell.backgroundColor = [UIColor colorWithRed:.82 green:.82 blue:.82 alpha:1];
            self.statsCollectionCell.bottomSeparatorView.hidden = YES;

            return self.statsCollectionCell;
        }

    } else {
        if (indexPath.row == 0) {

            self.playerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayerCollectionViewCellID" forIndexPath:indexPath];

            NSMutableArray *tempHomePlayersArray = [[NSMutableArray alloc] initWithObjects:@"", nil];
            [tempHomePlayersArray addObjectsFromArray:self.game.homePlayers];
            self.playerCell.playerNameLabel.text = [NSString stringWithFormat:@"%@", [tempHomePlayersArray objectAtIndex:indexPath.section]];

            self.playerCell.playerNameLabel.font = [UIFont systemFontOfSize:9.5];
            self.playerCell.playerNameLabel.textColor = [UIColor blackColor];
            self.playerCell.backgroundColor = [UIColor whiteColor];

            return self.playerCell;

        } else {

            self.statsCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StatsCollectionViewCellID" forIndexPath:indexPath];

            if (indexPath.row == 1) {
                    self.statsCollectionCell.statsLabel.text = [NSString stringWithFormat:@"%@", [self.game.minutesArray objectAtIndex:indexPath.section]];
            } else if (indexPath.row == 2) {
                self.statsCollectionCell.statsLabel.text = [NSString stringWithFormat:@"%@", [self.game.pointsArray objectAtIndex:indexPath.section]];
            } else if (indexPath.row == 3) {
                self.statsCollectionCell.statsLabel.text = [NSString stringWithFormat:@"%@", [self.game.fgmaArray objectAtIndex:indexPath.section]];
            }



            self.statsCollectionCell.statsLabel.font = [UIFont systemFontOfSize:9.5];
            self.statsCollectionCell.statsLabel.textColor = [UIColor blackColor];
            self.statsCollectionCell.backgroundColor = [UIColor whiteColor];

            return self.statsCollectionCell;
        }
    }
}

@end