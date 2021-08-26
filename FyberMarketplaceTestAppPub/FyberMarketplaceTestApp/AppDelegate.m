//
//  AppDelegate.m
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 29/01/2017.
//  Copyright © 2017 Fyber. All rights reserved.
//

#import "AppDelegate.h"

#import <IASDKCore/IASDKCore.h>

@implementation AppDelegate {}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [IALogger setLogLevel:IALogLevelVerbose];
    NSString * const kAppIDForTest = @"102960";



    [IASDKCore.sharedInstance initWithAppID:kAppIDForTest completionBlock:^(BOOL success, NSError * _Nullable error) { // init is mandatory;
        if (success) {
            NSLog(@"Fyber Marketplace SDK has been initialised, version: %@", IASDKCore.sharedInstance.version);
        } else {
            NSLog(@"Fyber Marketplace SDK init has failed: %@", error.description);
        }
    } completionQueue:dispatch_queue_create("appDelegate queue", DISPATCH_QUEUE_SERIAL)];
    IASDKCore.sharedInstance.globalAdDelegate = self;

    IASDKCore.sharedInstance.CCPAString = @"1YYY";

    return YES;
}

- (UIViewController *)topViewController {
    UIViewController *topVC = UIApplication.sharedApplication.keyWindow.rootViewController;

    if ([topVC isKindOfClass:UINavigationController.class]) {
        UINavigationController *navigationVC = (UINavigationController *)topVC;
        topVC = [navigationVC topViewController];
    }

    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }

    return topVC;
}

#pragma mark - IAGlobalAdDelegate

- (void)adDidShowWithImpressionData:(IAImpressionData * _Nonnull)impressionData withAdRequest:(IAAdRequest * _Nonnull)adRequest {
    NSLog(@"\n\nAd did show with impression data\
          \ndemandSourceName: %@\
          \ncountry: %@\
          \nsessionID: %@\
          \nadvertiserDomain: %@\
          \ncreativeID: %@\
          \ncampaignID: %@\
          \npricing value: %@\
          \npricingCurrency: %@\
          \nduration: %@\
          \nisSkippable: %@\
          \nspotID: %@\
          \nunitID: %@",
          impressionData.demandSourceName,
          impressionData.country,
          impressionData.sessionID,
          impressionData.advertiserDomain,
          impressionData.creativeID,
          impressionData.campaignID,
          impressionData.pricingValue,
          impressionData.pricingCurrency,
          impressionData.duration,
          impressionData.skippable ? @"YES" : @"NO",
          adRequest.spotID,
          adRequest.unitID);
    NSLog(@"\n");
}

@end
