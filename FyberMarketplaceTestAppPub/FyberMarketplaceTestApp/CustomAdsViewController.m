//
//  CustomAdsViewController.m
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 05/07/2020.
//  Copyright © 2020 Fyber. All rights reserved.
//

#import "CustomAdsViewController.h"
#import "IAColors.h"

typedef NS_ENUM(NSUInteger, AdType) {
    AdTypeBanner,
    AdTypeFullscreenHTML,
    AdTypeVAST,
    AdTypeVPAID,
    AdTypeProduction
};

@interface CustomAdsViewController () <UITableViewDelegate>

@end

@implementation CustomAdsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.title = NSLocalizedString(@"Custom Ads", nil);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClicked:)];
    NSDictionary *titleAttributes = [NSDictionary dictionaryWithObject:UIColor.systemPinkColor forKey:NSForegroundColorAttributeName];
    
    [backButton setTitleTextAttributes:titleAttributes forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = backButton;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *name = @"";
    
    if (section == AdTypeBanner) {
        name = @"Banner/Mrec";
    } else if (section == AdTypeFullscreenHTML) {
        name = @"Fullscreen HTML";
    } else if (section == AdTypeVAST) {
        name = @"VAST";
    } else if (section == AdTypeVPAID) {
        name = @"VPAID";
    } else if (section == AdTypeProduction) {
        name = @"Production";
    }
    
    return name;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 1;
    
    if (section == AdTypeBanner) {
        numberOfRows = 3;
    } else if (section == AdTypeFullscreenHTML) {
        numberOfRows = 1;
    } else if (section == AdTypeVAST) {
        numberOfRows = 3;
    } else if (section == AdTypeVPAID) {
        numberOfRows = 1;
    } else if (section == AdTypeProduction) {
        numberOfRows = 1;
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    NSString *title = @"";
    
    switch (indexPath.section) {
        case AdTypeBanner:
            switch (indexPath.row) {
                case 0:
                    title = @"Resize Banner";
                    break;
                case 1:
                    title = @"HTML Banner";
                    break;
                case 2:
                    title = @"Expand banner";
                    break;
            }
            break;
        case AdTypeFullscreenHTML:
            switch (indexPath.row) {
                case 0:
                    title = @"Display interstitial";
                    break;
            }
            break;
        case AdTypeVAST:
            switch (indexPath.row) {
                case 0:
                    title = @"Short VAST - 7715";
                    break;
                case 1:
                    title = @"Simple VAST - 7714";
                    break;
                case 2:
                    title = @"Long VAST";
                    break;
            }
            break;
        case AdTypeVPAID:
            switch (indexPath.row) {
                case 0:
                    title = @"Jin wigmore";
                    break;
            }
            break;
        case AdTypeProduction:
            switch (indexPath.row) {
                case 0:
                    title = @"Production";
                    break;
            }
            break;
    }
    
    cell.textLabel.text = NSLocalizedString(title, nil);
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case AdTypeBanner:
            switch (indexPath.row) {
                case 0:
                    [self.delegate updateServer:@"ia-cert" database:@"5430" mockResponse:@"mraidResize"];
                    break;
                case 1:
                    [self.delegate updateServer:@"ia-cert" database:@"5430" mockResponse:@"bannerResponseForCI"];
                    break;
                case 2:
                    [self.delegate updateServer:@"ia-cert" database:@"5430" mockResponse:@"bannerExpand"];
                    break;
            }
            break;
        case AdTypeFullscreenHTML:
            switch (indexPath.row) {
                case 0:
                    [self.delegate updateServer:@"ia-cert" database:@"5430" mockResponse:@"interstitialadresponseforci"];
                    break;
            }
            break;
        case AdTypeVAST:
            switch (indexPath.row) {
                case 0:
                    [self.delegate updateServer:@"ia-cert" database:@"5431" mockResponse:@"7715"];
                    break;
                case 1:
                    [self.delegate updateServer:@"ia-cert" database:@"5431" mockResponse:@"7714"];
                    break;
                case 2:
                    [self.delegate updateServer:@"ia-cert" database:@"5431" mockResponse:@"vastlarge"];
                    break;
            }
            break;
        case AdTypeVPAID:
            switch (indexPath.row) {
                case 0:
                    [self.delegate updateServer:@"ia-cert" database:@"5431" mockResponse:@"vpaidTesting"];
                    break;
            }
            break;
        case AdTypeProduction:
            switch (indexPath.row) {
                case 0:
                    [self.delegate updateServer:@"" database:@"" mockResponse:@""];
                    break;
            }
            break;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

#pragma mark - Service

- (void)backButtonClicked:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
