//
//  ViewController.m
//  NBABoxScores
//
//  Created by Paul Kitchener on 11/30/15.
//  Copyright © 2015 Paul Kitchener. All rights reserved.
//

#import "ViewController.h"
#import "ContentViewController.h"

@interface ViewController () <UIPageViewControllerDataSource>

@property UIPageViewController *datePageViewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.datePageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];

    self.datePageViewController.view.frame = self.view.frame;
    self.datePageViewController.dataSource = self;
    [self addChildViewController:self.datePageViewController];
    [self.view addSubview:self.datePageViewController.view];
    [self didMoveToParentViewController:self];

    [self.datePageViewController setViewControllers:@[[self getContentForDate:0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

}

- (UIViewController *)getContentForDate:(NSInteger)index {
    if (index >= 0) {
        ContentViewController *contentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DatePageViewControllerID"];

        contentVC.page = index;

        return contentVC;
    }

    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {

    NSInteger index = ((ContentViewController *) viewController).page + 1;
    if (((ContentViewController *) viewController).page == NSNotFound) {
        return nil;
    }

    NSLog(@"Went to page after");
    return [self getContentForDate:index];

}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = ((ContentViewController *) viewController).page - 1;
    if (((ContentViewController *) viewController).page == NSNotFound) {
        return nil;
    }

    NSLog(@"Went to page before");
    return [self getContentForDate:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // arbitrary number until we have data
    return 20;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

@end
