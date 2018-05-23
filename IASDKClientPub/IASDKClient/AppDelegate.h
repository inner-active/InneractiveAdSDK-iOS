//
//  AppDelegate.h
//  IASDKClient
//
//  Created by Inneractive on 29/01/2017.
//  Copyright © 2017 Inneractive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLLocationManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * _Nonnull window;
@property (nonatomic, strong) CLLocationManager * _Nullable locationManager; // can be used for the sample's location updates, debugging and tests;

@end
