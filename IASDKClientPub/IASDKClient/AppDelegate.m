//
//  AppDelegate.m
//  IASDKClient
//
//  Created by Inneractive on 29/01/2017.
//  Copyright © 2017 Inneractive. All rights reserved.
//

#import "AppDelegate.h"

#import <IASDKCore/IASDKCore.h>

@implementation AppDelegate {}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [IALogger setLogLevel:IALogLevelVerbose];
    NSLog(@"Inneractive SDK version: %@", IASDKCore.sharedInstance.version);
    
    NSString * const kAppIDForTest = @"102960";

    
    
    [IASDKCore.sharedInstance initWithAppID:kAppIDForTest]; // init is mandatory;
    IASDKCore.sharedInstance.globalAdDelegate = self;
    return YES;
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
