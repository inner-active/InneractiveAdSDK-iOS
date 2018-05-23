//
//  InaMoatAnalytics.h
//  InaMoatMobileAppKit
//
//  Created by Moat on 6/2/16.
//  Copyright © 2016 Moat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "InaMoatWebTracker.h"
#import "InaMoatNativeDisplayTracker.h"
#import "InaMoatVideoTracker.h"

@interface InaMoatOptions : NSObject<NSCopying>

@property BOOL locationServicesEnabled;
@property BOOL debugLoggingEnabled;
@property BOOL IDFACollectionEnabled;

@end

@interface InaMoatAnalytics : NSObject

+ (instancetype)sharedInstance;

- (void)start;

- (void)startWithOptions:(InaMoatOptions *)options;

- (void)prepareNativeDisplayTracking:(NSString *)partnerCode;

@end
