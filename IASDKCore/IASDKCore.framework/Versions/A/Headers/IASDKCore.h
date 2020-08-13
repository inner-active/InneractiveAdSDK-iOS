//
//  IASDKCore.h
//  IASDKCore
//
//  Created by Fyber on 29/01/2017.
//  Copyright © 2017 Fyber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <IASDKCore/IALogger.h>

#import <IASDKCore/IAInterfaceAllocBlocker.h>
#import <IASDKCore/IAInterfaceBuilder.h>
#import <IASDKCore/IAInterfaceSingleton.h>

#import <IASDKCore/IAGlobalAdDelegate.h>

#import <IASDKCore/IAInterfaceUnitController.h>

#import <IASDKCore/IAAdSpot.h>
#import <IASDKCore/IAAdRequest.h>
#import <IASDKCore/IAUserData.h>
#import <IASDKCore/IADebugger.h>
#import <IASDKCore/IAAdModel.h>

#import <IASDKCore/IAUnitController.h>
#import <IASDKCore/IAUnitDelegate.h>
#import <IASDKCore/IAViewUnitController.h>
#import <IASDKCore/IAFullscreenUnitController.h>
#import <IASDKCore/IAContentController.h>
#import <IASDKCore/IABaseView.h>
#import <IASDKCore/IAAdView.h>
#import <IASDKCore/IAMRAIDAdView.h>

#import <IASDKCore/IAMediation.h>
#import <IASDKCore/IAMediationMopub.h>
#import <IASDKCore/IAMediationAdMob.h>
#import <IASDKCore/IAMediationDFP.h>
#import <IASDKCore/IAMediationFyber.h>
#import <IASDKCore/IAMediationMax.h>
#import <IASDKCore/IAMediationIronSource.h>
#import <IASDKCore/IAGDPRConsent.h>

typedef void (^IASDKCoreInitBlock)(BOOL success, NSError * _Nullable error);

typedef NS_ENUM(NSInteger, IASDKCoreInitErrorType) {
    IASDKCoreInitErrorTypeUnknown = 0,
    IASDKCoreInitErrorTypeFailedToDownloadMandatoryData = 1,
    IASDKCoreInitErrorTypeMissingModules = 2,
    IASDKCoreInitErrorTypeInvalidAppID = 3,
    IASDKCoreInitErrorTypeCancelled = 4
};

@interface IASDKCore : NSObject <IAInterfaceSingleton>

@property (atomic, strong, nullable, readonly) NSString *appID;
@property (atomic, readonly, getter=isInitialised) BOOL initialised;

/**
 *  @brief Use this delegate in order to get an info about every shown ad.
 */
@property (atomic, weak, nullable) id<IAGlobalAdDelegate> globalAdDelegate;

/**
 *  @brief The GDPR consent status.
 *
 *  @discussion Use this property in order to set the GDPR consent accoring to your preferences.
 *
 * It can be used as one of the following, in order to allow/restrict:
 *
 * - `[IASDKCore.sharedInstance setGDPRConsent:YES]`
 *
 * - `[IASDKCore.sharedInstance setGDPRConsent:true]`
 *
 * - `IASDKCore.sharedInstance.GDPRConsent = NO`
 *
 * - `IASDKCore.sharedInstance.GDPRConsent = 1`
 *
 * - `IASDKCore.sharedInstance.GDPRConsent = IAGDPRConsentTypeGiven`
 *
 * Or it can be cleared by using the one of the following:
 *
 * - `[IASDKCore.sharedInstance clearGDPRConsentData]`
 *
 * - `IASDKCore.sharedInstance.GDPRConsent = IAGDPRConsentTypeUnknown`. <b>Important</b>: setting the `IAGDPRConsentTypeUnknown`, will clean the `GDPRConsentString` as well.
 *
 * The default (or after calling the `clearGDPRConsentData` method) value is unknown, which is the `IAGDPRConsentTypeUnknown`.
 *
 * The property is thread-safe.
 */
@property (atomic) IAGDPRConsentType GDPRConsent;

/**
 *  @brief Use this property in order to provide a custom GDPR consent data.
 *
 *  @discussion It will be passed as is, without any management/modification.
 */
@property (atomic, nullable) NSString *GDPRConsentString;

/**
 *  @brief Use this property in order to provide the CCPA string. Once it's set, it is saved on a device.
 *
 *  @discussion It will be passed as is, without any validation/modification. In order to clean this data permanently from a device, pass a nil or empty string.
 */
@property (atomic, nullable) NSString *CCPAString;

/**
 *  @brief Use this property in order to provide a user Id. Once it's set, it is saved on a device.
 *
 *  @discussion It will be passed as is, without any validation/modification. In order to clean it from a device, pass a nil or empty string.
 */
@property (atomic, nullable) NSString *userID;

/**
 *  @brief Singleton method, use for any instance call.
 */
+ (instancetype _Null_unspecified)sharedInstance;

/**
 *  @brief Initialisation of the SDK. Must be invoked before requesting the ads.
 *
 *  @discussion Should be invoked on the main thread. Otherwise it will convert the flow to the main thread. Is asynchronous method.
 *
 *  @param appID A required param. Must be a valid application ID, otherwise the SDK will not be able to request/render the ads.
 */
- (void)initWithAppID:(NSString * _Nonnull)appID;

/**
 *  @brief Initialisation of the SDK. Must be invoked before requesting the ads.
 *
 *  @discussion Should be invoked on the main thread. Otherwise it will convert the flow to the main thread. Is asynchronous method.
 *
 *  @param appID A required param. Must be a valid application ID, otherwise the SDK will not be able to request/render the ads.
 *
 *  @param completionBlock An optional callback for the init result notification. The error code is represented as `IASDKCoreInitErrorType` enum.
 *
 *  @param completionQueue An optional queue for the completion block. If is not provided, the completion block will be invoked on the main queue.
 */
- (void)initWithAppID:(NSString * _Nonnull)appID
      completionBlock:(IASDKCoreInitBlock _Nullable)completionBlock
      completionQueue:(dispatch_queue_t _Nullable)completionQueue;

/**
 *  @brief Get the IASDK current version as the NSString instance.
 *
 *  @discussion The format is `x.y.z`.
 */
- (NSString * _Null_unspecified)version;

/**
 *  @brief Clears all the GDPR related information. The state of the `GDPRConsent` property will become `-1` or `IAGDPRConsentTypeUnknown`.
 */
- (void)clearGDPRConsentData;

@end
