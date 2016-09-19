//
//  InneractiveAdSDK-Ad.h
//  InneractiveAdSDK
//
//  Created by Inneractive.
//  Copyright (c) 2015 Inneractive. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IaAdConfig;
@protocol InneractiveAdDelegate;

/**
 *  @class IaAd
 *  @discussion The IaAd is an abstract class. It implements the basic ad flow logic.
 * This class should not be allocated explicitly, please use IaAdView class (Display Ads) or IaNativeAd class (Native Ads) instead.
 *
 * It contains the IaAdConfig property - ad configuration, and the InneractiveAdDelegate delegate.
 */
@interface IaAd : UIView {}

/**
 *  @brief Ad Configuration.
 */
@property (nonatomic, strong) IaAdConfig *adConfig;

/**
 *  @brief InneractiveAdDelegate.
 */
@property (nonatomic, weak) id<InneractiveAdDelegate> delegate;

- (instancetype)init __attribute__((unavailable("IaAd is an abstract class, please use IaAdView class or IaNativeAd class instead")));
- (instancetype)initWithFrame:(CGRect)frame __attribute__((unavailable("IaAd is an abstract class, please use IaAdView class or IaNativeAd class instead")));
- (instancetype)initWithCoder:(NSCoder *)aDecoder __attribute__((unavailable("IaAd is an abstract class, please use IaAdView class or IaNativeAd class instead")));
+ (instancetype)new __attribute__((unavailable("IaAd is an abstract class, please use IaAdView class or IaNativeAd class instead")));

/**
 *  @brief Check, whether the interstitial / native ad is video ad.
 *
 *  @discussion Use this method after 'InneractiveAdLoaded:' event has been received.
 *
 *  @return YES in case of video ad, otherwise NO.
 */
- (BOOL)isVideoAd;

#pragma mark - Ads Debugging

/**
 *  @brief Use to limit the connection request time to Inneractive's Server when retrieving the ad.
 *  @discussion If the connection timeout is reached and no ad is recevied from Inneractive's Server - an ad failed event will be invoked.
 * The default connection timeout is 8.0 seconds and the minimum that can be set is 3.0 seconds.
 *  @param connectionTimeoutInSeconds Timeout in seconds.
 */
- (void)setAdRequestConnectionTimeoutInSec:(NSTimeInterval)connectionTimeoutInSeconds;

- (void)testEnvironmentAddress:(NSString *)name;
/**
 * @param portalsString contains portals separated by dot (.) symbol.
 * For example: @"7714.7715"
 */
- (void)testEnvironmentPortal:(NSString *)portalsString;
- (void)testEnvironmentResponse:(NSString *)responseType;

@end
