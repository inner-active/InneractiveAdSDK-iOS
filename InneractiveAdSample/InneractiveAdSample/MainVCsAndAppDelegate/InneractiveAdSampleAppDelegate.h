//
//  InneractiveAdSampleAppDelegate.h
//  InneractiveAdSample
//
//  Created by Inneractive.
//  Copyright (c) 2014 Inneractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <InneractiveAdSDK/InneractiveAdSDK.h>
#import <CoreLocation/CLLocationManager.h>


@interface InneractiveAdSampleAppDelegate : UIResponder <UIApplicationDelegate> {
}


@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end
