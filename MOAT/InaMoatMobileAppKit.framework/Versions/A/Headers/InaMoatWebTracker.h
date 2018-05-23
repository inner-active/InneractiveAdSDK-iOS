//
//  InaMoatWebTracker.h
//  InaMoatMobileAppKit
//
//  Created by Moat on 6/2/16.
//  Copyright © 2016 Moat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "InaMoatBaseTracker.h"

@interface InaMoatWebTracker : InaMoatBaseTracker

+ (InaMoatWebTracker *) trackerWithWebComponent:(UIView *)webViewOrWebViewContainer;

// Use this to track hybrid, two-view ads that consist both of a native UIView and a web-based component.
+ (InaMoatWebTracker *) trackerWithAdView:(UIView *)adView withWebComponent:(UIView *)webViewOrWebViewContainer;

- (bool) startTracking;

- (void) stopTracking;

@end
