//
//  InneractiveAdSampleAppDelegate.m
//  InneractiveAdSample
//
//  Created by Inneractive.
//  Copyright (c) 2014 Inneractive. All rights reserved.
//

#import "InneractiveAdSampleAppDelegate.h"

#import <CoreLocation/CLLocationManager.h>
#import <InneractiveAdSDK/InneractiveAdSDK.h>

@implementation InneractiveAdSampleAppDelegate {}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];

    NSLog(NSLocalizedString(@"Running Inneractive SDK Version number: %0.2f.", @"SDK Version"), [InneractiveAdSDK sdkVersion]);
    
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
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self.locationManager startMonitoringSignificantLocationChanges];
}

@end
