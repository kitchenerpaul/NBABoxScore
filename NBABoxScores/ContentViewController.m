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
#import "HomeCollectionView.h"
#import "Game.h"

@interface ContentViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property StatsTableViewCell *statsCell;

@property HomeCollectionView *statsCollectionView;

@property PlayerCollectionViewCell *playerCell;
@property StatsCollectionViewCell *statsCollectionCell;
@property StatsLayout *statsLayout;

@property Game *game;

@property NSMutableArray *statTitlesArray;

@property NSInteger gameSection;




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
    self.sectionTitleArray = [[NSMutableArray alloc] initWithArray:self.game.games];


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

    for (int i = 0; i < self.game.games.count; i++) {
        if (section == i) {
            NSDictionary *homeDict = [[self.game.games objectAtIndex:i] objectForKey:@"Home Team"];
            self.game.homeTeamName = [homeDict objectForKey:@"Team Name"];
            NSDictionary *awayDict = [[self.game.games objectAtIndex:i] objectForKey:@"Away Team"];
            self.game.awayTeamName = [awayDict objectForKey:@"Team Name"];
            viewLabel.text = [NSString stringWithFormat:@"%@ VS %@", self.game.homeTeamName, self.game.awayTeamName];
        }
    }

    [sectionView addSubview:viewLabel];

    UIView *separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, self.view.frame.size.width, 0.5)];
    separatorLineView.backgroundColor = [UIColor whiteColor];
    separatorLineView.alpha = 0.5f;
    [sectionView addSubview:separatorLineView];

    UITapGestureRecognizer *headerTapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [sectionView addGestureRecognizer:headerTapped];

    self.gameSection = section;

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 610;
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

    NSMutableArray *tempHomePlayersArray = [[NSMutableArray alloc] initWithObjects:@"", nil];

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.playerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayerCollectionViewCellID" forIndexPath:indexPath];
            self.playerCell.backgroundColor = [UIColor colorWithRed:.1 green:.3 blue:.5 alpha:1];
            self.playerCell.playerNameLabel.font = [UIFont systemFontOfSize:12.0];
            self.playerCell.playerNameLabel.textColor = [UIColor whiteColor];

            for (int i = 0; i < self.game.games.count; i++) {
                if (self.gameSection == i) {

                    NSDictionary *homeDict = [[self.game.games objectAtIndex:i] objectForKey:@"Home Team"];
                    self.game.homeTeamName = [homeDict objectForKey:@"Team Name"];

                    self.playerCell.playerNameLabel.text = [NSString stringWithFormat:@"%@", self.game.homeTeamName];
                }
            }

//            self.playerCell.playerNameLabel.text = [NSString stringWithFormat:@"%@", self.game.homeTeamName];
            self.playerCell.separatorView.hidden = YES;
            self.playerCell.bottomSeparatorView.hidden = YES;

            return self.playerCell;

        } else {
            self.statsCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StatsCollectionViewCellID" forIndexPath:indexPath];

            self.statTitlesArray = [[NSMutableArray alloc] initWithObjects:@"", @"MIN", @"PTS", @"FGM-A", @"3PM-A", @"FTM-A", @"OFF", @"DEF", @"TOT", @"AST", @"STL", @"BLK", @"TO", @"PF", @"+/-",  nil];
            self.statsCollectionCell.statsLabel.text = [self.statTitlesArray objectAtIndex:indexPath.row];

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

            for (int i = 0; i < self.game.games.count; i++) {
                if (self.gameSection == i) {

                    NSDictionary *homeDict = [[self.game.games objectAtIndex:i] objectForKey:@"Home Team"];
                    self.game.homePlayers = [homeDict objectForKey:@"Players"];

                    [tempHomePlayersArray addObjectsFromArray:self.game.homePlayers];
                    self.playerCell.playerNameLabel.text = [NSString stringWithFormat:@"%@", [tempHomePlayersArray objectAtIndex:indexPath.section]];

                }
            }

//            NSMutableArray *tempHomePlayersArray = [[NSMutableArray alloc] initWithObjects:@"", nil];
//            [tempHomePlayersArray addObjectsFromArray:self.game.homePlayers];
//            self.playerCell.playerNameLabel.text = [NSString stringWithFormat:@"%@", [tempHomePlayersArray objectAtIndex:indexPath.section]];

            self.playerCell.playerNameLabel.font = [UIFont systemFontOfSize:9.5];
            self.playerCell.playerNameLabel.textColor = [UIColor blackColor];
            self.playerCell.backgroundColor = [UIColor whiteColor];

            return self.playerCell;

        } else {

            self.statsCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StatsCollectionViewCellID" forIndexPath:indexPath];

            if (indexPath.row == 1) {

                for (int i = 0; i < self.game.games.count; i++) {
                    if (self.gameSection == i) {

                        NSDictionary *homeDict = [[self.game.games objectAtIndex:i] objectForKey:@"Home Team"];
                        self.game.minutesArray = [[homeDict objectForKey:@"Stats"] objectForKey:@"MIN"];
                        NSMutableArray *tempMinutesArray = [[NSMutableArray alloc] initWithObjects:@"", nil];
                        [tempMinutesArray addObjectsFromArray:self.game.minutesArray];
                        self.statsCollectionCell.statsLabel.text = [NSString stringWithFormat:@"%@", [tempMinutesArray objectAtIndex:indexPath.section]];
                    }
                }

            } else if (indexPath.row == 2) {

                for (int i = 0; i < self.game.games.count; i++) {
                    if (self.gameSection == i) {

                        NSDictionary *homeDict = [[self.game.games objectAtIndex:i] objectForKey:@"Home Team"];
                        self.game.pointsArray = [[homeDict objectForKey:@"Stats"] objectForKey:@"PTS"];
                        NSMutableArray *tempPointsArray = [[NSMutableArray alloc] initWithObjects:@"", nil];
                        [tempPointsArray addObjectsFromArray:self.game.pointsArray];
                        self.statsCollectionCell.statsLabel.text = [NSString stringWithFormat:@"%@", [tempPointsArray objectAtIndex:indexPath.section]];
                    }
                }

            } else if (indexPath.row == 3) {

                for (int i = 0; i < self.game.games.count; i++) {
                    if (self.gameSection == i) {

                        NSDictionary *homeDict = [[self.game.games objectAtIndex:i] objectForKey:@"Home Team"];
                        self.game.fgmaArray = [[homeDict objectForKey:@"Stats"] objectForKey:@"FGM-A"];
                        NSMutableArray *tempfgmaArray = [[NSMutableArray alloc] initWithObjects:@"", nil];
                        [tempfgmaArray addObjectsFromArray:self.game.fgmaArray];
                        self.statsCollectionCell.statsLabel.text = [NSString stringWithFormat:@"%@", [tempfgmaArray objectAtIndex:indexPath.section]];
                    }
                }

            } else if (indexPath.row == 4) {

                for (int i = 0; i < self.game.games.count; i++) {
                    if (self.gameSection == i) {

                        NSDictionary *homeDict = [[self.game.games objectAtIndex:i] objectForKey:@"Home Team"];
                        self.game.threepmaArray = [[homeDict objectForKey:@"Stats"] objectForKey:@"3PM-A"];
                        NSMutableArray *temp3pmaArray = [[NSMutableArray alloc] initWithObjects:@"", nil];
                        [temp3pmaArray addObjectsFromArray:self.game.threepmaArray];
                        self.statsCollectionCell.statsLabel.text = [NSString stringWithFormat:@"%@", [temp3pmaArray objectAtIndex:indexPath.section]];
                    }
                }

            } else if (indexPath.row == 5) {

                for (int i = 0; i < self.game.games.count; i++) {
                    if (self.gameSection == i) {

                        NSDictionary *homeDict = [[self.game.games objectAtIndex:i] objectForKey:@"Home Team"];
                        self.game.ftmaArray = [[homeDict objectForKey:@"Stats"] objectForKey:@"FTM-A"];
                        NSMutableArray *tempftmaArray = [[NSMutableArray alloc] initWithObjects:@"", nil];
                        [tempftmaArray addObjectsFromArray:self.game.ftmaArray];
                        self.statsCollectionCell.statsLabel.text = [NSString stringWithFormat:@"%@", [tempftmaArray objectAtIndex:indexPath.section]];
                    }
                }

            } else if (indexPath.row == 6) {

                for (int i = 0; i < self.game.games.count; i++) {
                    if (self.gameSection == i) {

                        NSDictionary *homeDict = [[self.game.games objectAtIndex:i] objectForKey:@"Home Team"];
                        self.game.offRebArray = [[homeDict objectForKey:@"Stats"] objectForKey:@"OFF"];
                        NSMutableArray *tempOffRebArray = [[NSMutableArray alloc] initWithObjects:@"", nil];
                        [tempOffRebArray addObjectsFromArray:self.game.offRebArray];
                        self.statsCollectionCell.statsLabel.text = [NSString stringWithFormat:@"%@", [tempOffRebArray objectAtIndex:indexPath.section]];
                    }
                }

            } else if (indexPath.row == 7) {

                for (int i = 0; i < self.game.games.count; i++) {
                    if (self.gameSection == i) {

                        NSDictionary *homeDict = [[self.game.games objectAtIndex:i] objectForKey:@"Home Team"];
                        self.game.defRebArray = [[homeDict objectForKey:@"Stats"] objectForKey:@"DEF"];
                        NSMutableArray *tempDefRebArray = [[NSMutableArray alloc] initWithObjects:@"", nil];
                        [tempDefRebArray addObjectsFromArray:self.game.defRebArray];
                        self.statsCollectionCell.statsLabel.text = [NSString stringWithFormat:@"%@", [tempDefRebArray objectAtIndex:indexPath.section]];
                    }
                }

            } else if (indexPath.row == 8) {


                for (int i = 0; i < self.game.games.count; i++) {
                    if (self.gameSection == i) {

                        NSDictionary *homeDict = [[self.game.games objectAtIndex:i] objectForKey:@"Home Team"];
                        self.game.totRebArray = [[homeDict objectForKey:@"Stats"] objectForKey:@"TOT"];
                        NSMutableArray *tempTotRebArray = [[NSMutableArray alloc] initWithObjects:@"", nil];
                        [tempTotRebArray addObjectsFromArray:self.game.totRebArray];
                        self.statsCollectionCell.statsLabel.text = [NSString stringWithFormat:@"%@", [tempTotRebArray objectAtIndex:indexPath.section]];
                    }
                }

            } else if (indexPath.row == 9) {

                for (int i = 0; i < self.game.games.count; i++) {
                    if (self.gameSection == i) {

                        NSDictionary *homeDict = [[self.game.games objectAtIndex:i] objectForKey:@"Home Team"];
                        self.game.assistsArray = [[homeDict objectForKey:@"Stats"] objectForKey:@"AST"];
                        NSMutableArray *tempAssistsArray = [[NSMutableArray alloc] initWithObjects:@"", nil];
                        [tempAssistsArray addObjectsFromArray:self.game.assistsArray];
                        self.statsCollectionCell.statsLabel.text = [NSString stringWithFormat:@"%@", [tempAssistsArray objectAtIndex:indexPath.section]];
                    }
                }

            } else if (indexPath.row == 10) {

                for (int i = 0; i < self.game.games.count; i++) {
                    if (self.gameSection == i) {

                        NSDictionary *homeDict = [[self.game.games objectAtIndex:i] objectForKey:@"Home Team"];
                        self.game.stealsArray = [[homeDict objectForKey:@"Stats"] objectForKey:@"STL"];
                        NSMutableArray *tempStealsArray = [[NSMutableArray alloc] initWithObjects:@"", nil];
                        [tempStealsArray addObjectsFromArray:self.game.stealsArray];
                        self.statsCollectionCell.statsLabel.text = [NSString stringWithFormat:@"%@", [tempStealsArray objectAtIndex:indexPath.section]];
                    }
                }

            } else if (indexPath.row == 11) {

                for (int i = 0; i < self.game.games.count; i++) {
                    if (self.gameSection == i) {

                        NSDictionary *homeDict = [[self.game.games objectAtIndex:i] objectForKey:@"Home Team"];
                        self.game.blocksArray = [[homeDict objectForKey:@"Stats"] objectForKey:@"BLK"];
                        NSMutableArray *tempBlocksArray = [[NSMutableArray alloc] initWithObjects:@"", nil];
                        [tempBlocksArray addObjectsFromArray:self.game.blocksArray];
                        self.statsCollectionCell.statsLabel.text = [NSString stringWithFormat:@"%@", [tempBlocksArray objectAtIndex:indexPath.section]];
                    }
                }
            } else if (indexPath.row == 12) {

                for (int i = 0; i < self.game.games.count; i++) {
                    if (self.gameSection == i) {

                        NSDictionary *homeDict = [[self.game.games objectAtIndex:i] objectForKey:@"Home Team"];
                        self.game.turnoversArray = [[homeDict objectForKey:@"Stats"] objectForKey:@"TO"];
                        NSMutableArray *tempTurnoversArray = [[NSMutableArray alloc] initWithObjects:@"", nil];
                        [tempTurnoversArray addObjectsFromArray:self.game.turnoversArray];
                        self.statsCollectionCell.statsLabel.text = [NSString stringWithFormat:@"%@", [tempTurnoversArray objectAtIndex:indexPath.section]];
                    }
                }

            } else if (indexPath.row == 13) {

                for (int i = 0; i < self.game.games.count; i++) {
                    if (self.gameSection == i) {

                        NSDictionary *homeDict = [[self.game.games objectAtIndex:i] objectForKey:@"Home Team"];
                        self.game.foulsArray = [[homeDict objectForKey:@"Stats"] objectForKey:@"PF"];
                        NSMutableArray *tempFoulsArray = [[NSMutableArray alloc] initWithObjects:@"", nil];
                        [tempFoulsArray addObjectsFromArray:self.game.foulsArray];
                        self.statsCollectionCell.statsLabel.text = [NSString stringWithFormat:@"%@", [tempFoulsArray objectAtIndex:indexPath.section]];
                    }
                }

            } else if (indexPath.row == 14) {

                for (int i = 0; i < self.game.games.count; i++) {
                    if (self.gameSection == i) {

                        NSDictionary *homeDict = [[self.game.games objectAtIndex:i] objectForKey:@"Home Team"];
                        self.game.plusMinusArray = [[homeDict objectForKey:@"Stats"] objectForKey:@"+/-"];
                        NSMutableArray *tempPlusMinusArray = [[NSMutableArray alloc] initWithObjects:@"", nil];
                        [tempPlusMinusArray addObjectsFromArray:self.game.plusMinusArray];
                        self.statsCollectionCell.statsLabel.text = [NSString stringWithFormat:@"%@", [tempPlusMinusArray objectAtIndex:indexPath.section]];
                    }
                }
            }

            self.statsCollectionCell.statsLabel.font = [UIFont systemFontOfSize:9.5];
            self.statsCollectionCell.statsLabel.textColor = [UIColor blackColor];
            self.statsCollectionCell.backgroundColor = [UIColor whiteColor];

            return self.statsCollectionCell;
        }
    }
}


@end