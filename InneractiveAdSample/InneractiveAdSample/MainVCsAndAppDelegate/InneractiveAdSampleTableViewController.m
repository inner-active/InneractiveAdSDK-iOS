//
//  InneractiveAdSampleTableViewController.m
//  InneractiveAdSample
//
//  Created by Inneractive.
//  Copyright (c) 2014 Inneractive. All rights reserved.
//

@import InneractiveAdSDK;
#import "InneractiveAdSampleTableViewController.h"
#import "InneractiveAdSampleViewController.h"

@implementation InneractiveAdSampleTableViewController {}

static const int kIaNumOfAdTypesInEachTableViewSection = 3;

#pragma mark - View Appearance and Loading

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customizeNavigationBarAppearance];
    
}

- (void)customizeNavigationBarAppearance{
    // Set navigation bar color
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
        [self.navigationController.navigationBar setBarTintColor:IA_NAV_BAR_COLOR];
    }
    else {
        [self.navigationController.navigationBar setTintColor:IA_NAV_BAR_COLOR];
    }
    
    // Add shadow to the bottom of navigation bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"Shadow effect line"]];
    
    // Set title text attributes of navigation bar
    NSMutableDictionary *titleTextAttributes = [NSMutableDictionary dictionary];
    titleTextAttributes[NSFontAttributeName] = [UIFont fontWithName:@"Roboto-Regular" size:20];
    titleTextAttributes[NSForegroundColorAttributeName] = [UIColor colorWithRed:137/255.0 green:142/255.0 blue:145/255.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:titleTextAttributes];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    [self customizeBackButtonForNavigationItem:[segue.destinationViewController navigationItem]];
    
    //Regular Ad and Native Ad (Simple)
    if ([segue.destinationViewController isKindOfClass:InneractiveAdSampleViewController.class]) {
        InneractiveAdSampleViewController *sampleViewController = segue.destinationViewController;
        
        //0 if ad should be loaded from code., 1 if ad should be loaded from Interface-Builder.
        sampleViewController.chosenSectionType = [segue.identifier intValue] / kIaNumOfAdTypesInEachTableViewSection;
        //This relies on the fact that the storyboard segue identifier is set to
        // 1, 2, 3 for the banner, rectangle and interstitial ad buttons segues in IB.
        sampleViewController.chosenAdType = ([segue.identifier intValue] % kIaNumOfAdTypesInEachTableViewSection) + 1;
    }
    //Native Ad Story (Table)
    else {
        //do nothing at this point
    }
}

- (void)customizeBackButtonForNavigationItem:(UINavigationItem *)navItem{	
	UIImage *buttonImage = [[UIImage imageNamed:@"Back-icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:buttonImage style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
	navItem.leftBarButtonItem = barButtonItem;
}

- (void)backPressed:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Interface Orientation

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate {
    return YES;
}

#pragma mark - UI

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)view forRowAtIndexPath:(NSIndexPath*)indexPath {
    view.textLabel.textColor = IA_BUTTONS_BACKGROUND_COLOR;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sectionsCount = 2;
    
    return sectionsCount;
}


@end
