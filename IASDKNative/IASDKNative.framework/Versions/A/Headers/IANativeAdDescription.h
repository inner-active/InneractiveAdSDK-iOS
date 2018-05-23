//
//  IANativeAdDescription.h
//  IASDKNative
//
//  Created by Inneractive on 27/04/2017.
//  Copyright © 2017 Inneractive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <IASDKCore/IAInterfaceBuilder.h>
#import <IASDKCore/IAInterfaceAdDescription.h>
#import "IANativeAdContentTypeEnum.h"

@class IANativeAdAssetDescription;

@protocol IANativeAdDescriptionBuilder <NSObject>

@required

@property (nonatomic, copy, nonnull, readonly) IANativeAdAssetDescription *assetsDescription;

/**
 *  @brief Defines min width for main asset.
 */
@property (nonatomic) CGFloat nativeAdMainAssetMinWidth;

/**
 *  @brief Defines min height for main asset.
 */
@property (nonatomic) CGFloat nativeAdMainAssetMinHeight;

/**
 *  @brief Defines limitation for bitrate of video.
 */
@property (nonatomic) NSInteger maxBitrate;

/**
 *  @brief Defines limitation for Ads content. The default is any content.
 */
@property (nonatomic) IANativeAdContentType nativeAdContentType;

@end

@interface IANativeAdDescription : NSObject <IAInterfaceBuilder, IAInterfaceAdDescription, IANativeAdDescriptionBuilder, NSCopying>

+ (instancetype _Nullable)build:(void(^ _Nonnull)(id<IANativeAdDescriptionBuilder> _Nonnull builder))buildBlock;

@end
