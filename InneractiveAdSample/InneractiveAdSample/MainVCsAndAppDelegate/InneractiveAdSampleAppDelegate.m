//
//  InneractiveAdSampleAppDelegate.m
//  InneractiveAdSample
//
//  Created by Inneractive.
//  Copyright (c) 2014 Inneractive. All rights reserved.
//

#import "InneractiveAdSampleAppDelegate.h"
#import "InneractiveAdSampleViewController.h"
#import <InneractiveAdSDK/InneractiveAdSDK.h>
#import "DDLog.h"
#import "DDTTYLogger.h"


@implementation InneractiveAdSampleAppDelegate {}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDTTYLogger sharedInstance].colorsEnabled = NO;
    

    DDLogVerbose(NSLocalizedString(@"Running Inneractive SDK Version number: %0.2f.", @"SDK Version"), [InneractiveAdSDK sdkVersion]);
    
    // Initializing the Inneractive Ad SDK.
    [[InneractiveAdSDK sharedInstance] initialize];
    
    // It is preferable to add the user location from a previously initialized CLLocationManager object which started montoring location changes (e.g., via running the startUpdatingLocation or the startMonitoringSignificantLocationChanges methods inside applicationDidFinishLaunching.
    // See more here: https://developer.apple.com/library/mac/documentation/CoreLocation/Reference/CLLocationManager_Class/CLLocationManager/CLLocationManager.html )
    
    self.locationManager = [[CLLocationManager alloc] init];
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) { // iOS8+
        // Sending a message to avoid compile time error
        [[UIApplication sharedApplication] sendAction:@selector(requestAlwaysAuthorization)
                                                   to:self.locationManager
                                                 from:self
                                             forEvent:nil];
    }
    
    [self.locationManager startMonitoringSignificantLocationChanges];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [storyboard instantiateInitialViewController];
    
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark loggerWebServer


@end
