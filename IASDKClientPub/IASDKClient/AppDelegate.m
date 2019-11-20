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
    return YES;
}

@end
