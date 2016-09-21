//
//  InneractiveAdSampleViewController.m
//  InneractiveAdSample
//
//  Created by Inneractive.
//  Copyright (c) 2014 Inneractive. All rights reserved.
//

#import "InneractiveAdSampleViewController.h"
#import "InneractiveAdSampleAppDelegate.h"
#import "iToast.h"

@interface InneractiveAdSampleViewController ()
@end

@implementation InneractiveAdSampleViewController {}

static NSString *kIaMyAppId = @"MyCompany_MyApp";

- (IBAction)loadAdButtonWasPressed:(id)sender {
    [self.adLoadActivityIndicator startAnimating];
    
    IaAdType adType = self.chosenAdType; // The ad type is based on the ad type chosen by the user in the sample's initial screen tableView.
    
            // Instantitating a new ad view. Passing an app ID, an ad type and our view controller (self) as the ad delegate which will be notified of
            // any ad related events, such as InneractiveAdLoaded, InneractiveAdFailed, etc.
            // Please note that when a banner/rectangle ad is clicked -
            // the ad's landing page is displayed as a modal view controller from the view controller which should be returned
            // from the  InneractiveAdDelegate - (UIViewController *)viewControllerForPresentingModalView method.
            
            if (!self.adView) {
                self.adView = [[IaAdView alloc] initWithAppId:kIaMyAppId adType:adType delegate:self];
                self.adView.backgroundColor = UIColor.whiteColor; // default is transparent
                
                if (adType != IaAdType_Interstitial) {
                    // adding banner / rectangle ad as a subview
                    [self.view addSubview:self.adView];
                    
                    // adding centerX constraint
                    [self.view addConstraint:
                     [NSLayoutConstraint constraintWithItem:self.adView
                                                  attribute:NSLayoutAttributeCenterX
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:self.view
                                                  attribute:NSLayoutAttributeCenterX
                                                 multiplier:1.0
                                                   constant:0.0f]];
                    
                    // adding top constraint
                    [self.view addConstraint:
                     [NSLayoutConstraint constraintWithItem:self.adView
                                                  attribute:NSLayoutAttributeTop
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:self.view
                                                  attribute:NSLayoutAttributeTop
                                                 multiplier:1.0
                                                   constant:0.0f]];
                }
            }
        // Setting the ad's configuration parameters (more info. can be found here: https://confluence.inner-active.com/display/DevWiki/iOS+SDK+guidelines).
        self.adView.adConfig.refreshIntervalInSec = 30;
        
        // Setting the ad's location. Please Note: Passing the location object in the ad configuration allows for better ad targeting, and potentially higher eCPMs.
        self.adView.adConfig.location = ((InneractiveAdSampleAppDelegate *)[[UIApplication sharedApplication] delegate]).locationManager.location;
        
        // Observe video progress:
        self.adView.videoProgressObserver = ^(NSTimeInterval currentTime, NSTimeInterval totalTime) {
            NSLog(@"[Current video time: %.2lfs total time: %.2lfs progress: %.0lf%%]", currentTime, totalTime, (currentTime / totalTime) * 100.0);
        };
        
        [[InneractiveAdSDK sharedInstance] loadAd:self.adView];
}


// Showing an interstitial ad if it has been previously loaded.
// Please note that Interstitial's are presented as a modal view controller from the view controller which should be returned from the
// InneractiveAdDelegate - (UIViewController *)viewControllerForPresentingModalView method.

- (IBAction)showAdButtonWasPressed:(id)sender {
    [self displayShowAdButton:NO];
    
    [[InneractiveAdSDK sharedInstance] showInterstitialAd:self.adView];
}

#pragma mark - InneractiveAdDelegate Event Handlers

/**
 * The 'viewControllerForPresentingModalView' delegate method implementation is required.
 * It should return the View Controller from which Interstitial ads / In App Browser can be presented modally from.
 * It is also MPAdViewDelegate callback. */

- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

/**
 * Ad received successfuly handler.
 * This method gaurantees that a proper ad is attached to the IaAdView view and is now ready to be displayed. */

- (void)InneractiveAdLoaded:(IaAd *)ad {
    [self showToastAndOutputToLog:[NSString stringWithFormat:@"InneractiveAdLoaded - %@", ad.adConfig.appId]];

    [self.adLoadActivityIndicator stopAnimating];
    
    if (ad.adConfig.adType == IaAdType_Interstitial) {
        [self displayShowAdButton:YES];
    }
}

/**
 * Ad Failed handler - This method will receive all errors related to the ad loading / displaying process. */

- (void)InneractiveAdFailedWithError:(NSError *)error withAdView:(IaAd *)ad {
    [self.adLoadActivityIndicator stopAnimating];
    [self displayShowAdButton:NO];
    [self showToastAndOutputToLog:[NSString stringWithFormat:@"InneractiveAdFailed Event Received\n\%@", [error localizedDescription]]];
}

- (void)InneractiveAdAppShouldSuspend:(IaAd *)ad {
    [self showToastAndOutputToLog:[NSString stringWithFormat:@"InneractiveAdAppShouldSuspend - %@", ad.adConfig.appId]];
}

- (void)InneractiveAdAppShouldResume:(IaAd *)ad {
    [self showToastAndOutputToLog:[NSString stringWithFormat:@"InneractiveAdAppShouldResume - %@", ad.adConfig.appId]];
}

#pragma mark - Interstitial Ad Events 

- (void)InneractiveInterstitialAdDismissed:(IaAdView *)adView {
    [self showToastAndOutputToLog:[NSString stringWithFormat:@"InneractiveInterstitialAdDismissed - %@", adView.adConfig.appId]];
}

- (void)InneractiveInterstitialAdWillShow:(IaAdView *)adView {
    [self showToastAndOutputToLog:[NSString stringWithFormat:@"InneractiveInterstitialAdWillShow - %@", adView.adConfig.appId]];
}

- (void)InneractiveInterstitialAdDidShow:(IaAdView *)adView {
    [self showToastAndOutputToLog:[NSString stringWithFormat:@"InneractiveInterstitialAdDidShow - %@", adView.adConfig.appId]];
}

#pragma mark - Ad User Interaction Events

- (void)InneractiveAdClicked:(IaAd *)ad {
    [self showToastAndOutputToLog:[NSString stringWithFormat:@"InneractiveAdClicked - %@", ad.adConfig.appId]];
}

- (void)InneractiveAdWillOpenExternalApp:(IaAd *)ad {
    [self showToastAndOutputToLog:[NSString stringWithFormat:@"InneractiveAdWillOpenExternalApp - %@", ad.adConfig.appId]];
}

#pragma mark - Rich Media (MRAID 2.0) Ad Events

- (void)InneractiveAdWillResize:(IaAdView *)adView toFrame:(NSValue*)frameAsValue {
    CGRect frame = [frameAsValue CGRectValue];
    [self showToastAndOutputToLog:[NSString stringWithFormat:@"InneractiveAdWillResize - %@. To frame: %@.", adView.adConfig.appId, NSStringFromCGRect(frame)]];
}

- (void)InneractiveAdDidResize:(IaAdView *)adView toFrame:(NSValue*)frameAsValue
{
    CGRect frame = [frameAsValue CGRectValue];
    [self showToastAndOutputToLog:[NSString stringWithFormat:@"InneractiveAdDidResize - %@. To frame: %@.", adView.adConfig.appId, NSStringFromCGRect(frame)]];
}

- (void)InneractiveAdWillExpand:(IaAdView *)adView toFrame:(NSValue*)frameAsValue
{
    CGRect frame = [frameAsValue CGRectValue];
    [self showToastAndOutputToLog:[NSString stringWithFormat:@"InneractiveAdWillExpand - %@. To frame: %@.", adView.adConfig.appId, NSStringFromCGRect(frame)]];
}

- (void)InneractiveAdDidExpand:(IaAdView *)adView toFrame:(NSValue*)frameAsValue
{
    CGRect frame = [frameAsValue CGRectValue];
    [self showToastAndOutputToLog:[NSString stringWithFormat:@"InneractiveAdDidExpand - %@. To frame: %@. ", adView.adConfig.appId, NSStringFromCGRect(frame)]];
}


#pragma mark - Inneractive Ad Sample View Controller Methods
#pragma mark - Status Bar and Interface Rotation Handling

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    /* If your application does not support automatic rotation, but rather rotates it's views manually,
       you can opt to forward orientation changes to the ad's IaAdView by calling the optional
       rotateToOrientation:(UIInterfaceOrientation)toInterfaceOrientation method like so:
    */
    /// [[InneractiveAdSDK sharedInstance] rotateAdView:self.bannerAdView ToOrientation:toInterfaceOrientation];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return  UIInterfaceOrientationMaskAll;
}

-(BOOL)shouldAutorotate {
    return YES;
}

#pragma mark View Controller View Loading and Appearance methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - Sample Helper Methods

// Helper method used to display received Ad Events (using iToast) and log output to the console.
- (void)showToastAndOutputToLog:(NSString *)toastString {
    [[iToast makeText:toastString] show];
    NSLog(@"Toast: %@", toastString);
}

// Helper method to display / hide the "Show Ad" button which should display when an Interstitial ad is properly loaded.
- (void)displayShowAdButton:(BOOL)shouldDisplay {
    self.showAdButton.enabled = shouldDisplay;
    self.showAdButton.hidden = !shouldDisplay;
}

#pragma mark - Memory management

- (void)dealloc {
    [[InneractiveAdSDK sharedInstance] removeAd:_adView];
}

@end
