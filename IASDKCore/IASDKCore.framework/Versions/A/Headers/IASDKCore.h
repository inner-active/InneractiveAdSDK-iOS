//
//  IASDKCore.h
//  IASDKCore
//
//  Created by Inneractive on 29/01/2017.
//  Copyright © 2017 Inneractive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "IALogger.h"

#import "IAInterfaceAllocBlocker.h"
#import "IAInterfaceBuilder.h"
#import "IAInterfaceSingleton.h"

#import "IAInterfaceUnitController.h"
#import "IAInterfaceNativeRenderer.h"

#import "IAAdSpot.h"
#import "IAAdRequest.h"
#import "IAUserData.h"
#import "IADebugger.h"
#import "IAAdModel.h"

#import "IAUnitController.h"
#import "IAUnitDelegate.h"
#import "IAViewUnitController.h"
#import "IAFullscreenUnitController.h"
#import "IANativeUnitController.h"
#import "IAContentController.h"
#import "IAAdView.h"
#import "IAMRAIDAdView.h"

#import "IAMediation.h"
#import "IAMediationMopub.h"
#import "IAMediationAdMob.h"
#import "IAMediationDFP.h"
#import "IAMediationFyber.h"
#import "IAGDPRConsent.h"

@interface IASDKCore : NSObject <IAInterfaceSingleton>

@property (atomic, strong, nullable, readonly) NSString *appID;

/**
 *  @brief Singleton method, use for any instance call.
 */
+ (instancetype _Null_unspecified)sharedInstance;

/**
 *  @brief Initialisation of the SDK. Must be invoked before requesting the ads.
 *
 *  @discussion Should be invoked on the main thread. Otherwise it will convert the flow to the main thread.
 *
 *  @param appID A required param. Must be a valid application ID, otherwise the SDK will not be able to request/render the ads.
 */
- (void)initWithAppID:(NSString * _Nonnull)appID;

/**
 *  @brief Get IASDKCore framework current version as NSString instance.
 *
 *  @discussion The format is 'X.XX'.
 */
- (NSString * _Null_unspecified)version;

/**
 *  @brief Use in order to set GDPR consent.
 *
 *  @param value Yes - allow, No - deny.
 */
- (void)setGDPRConsent:(BOOL)value;

@end
