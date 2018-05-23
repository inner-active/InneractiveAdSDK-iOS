//
//  IANativeAdAssetDescription.h
//  IASDKNative
//
//  Created by Inneractive on 26/04/2017.
//  Copyright © 2017 Inneractive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IANativeLayoutEnum.h"

/**
 *  @typedef IAAdAssetSize
 *  @brief Custom size struct.
 *  @discussion Use to define native assets minimum size.
 *
 *  @field width Asset width.
 *  @field height Asset height.
 */
typedef struct IAAdAssetSize {
    NSUInteger width;
    NSUInteger height;
} IAAdAssetSize;

/**
 *  @brief Creates IAAdAssetSize struct instance.
 *
 *  @param width  Width.
 *  @param height Height.
 *
 *  @return IAAdAssetSize instance.
 */
static inline IAAdAssetSize IAAdAssetSizeMake(NSUInteger width, NSUInteger height) {
    IAAdAssetSize assetSize;
    
    assetSize.width = width;
    assetSize.height = height;
    
    return assetSize;
}

/**
 *  @typedef IANativeAdAssetPriority
 *  @brief Asset Prioriy enum, that is used to define whether asset can be optional, is required by publisher or should not be displayed at all.
 */
typedef NS_ENUM(NSInteger, IANativeAdAssetPriority) {
    /**
     *  @brief Asset (UI) is not implemented by a publisher.
     */
    IANativeAdAssetPriorityNone,
    
    /**
     *  @brief Asset (UI) is implemented by a publisher, but is not crucial getting data for.
     */
    IANativeAdAssetPriorityOptional,
    
    /**
     *  @brief Asset (UI) is implemeted by a publisher and is required by a publisher.
     */
    IANativeAdAssetPriorityRequired
};

/**
 *  @class IANativeAdAssetDescription
 *  @brief Native Ad Assets configuration.
 */
@interface IANativeAdAssetDescription : NSObject <NSCopying>

/**
 *  @brief Defines the minimum width and heigth for main image or video asset.
 */
@property (nonatomic) IAAdAssetSize mainAssetMinSize;

/**
 *  @brief Defines the title asset priority.
 */
@property (nonatomic) IANativeAdAssetPriority titleAssetPriority;

/**
 *  @brief Defines the icon asset priority.
 */
@property (nonatomic) IANativeAdAssetPriority imageIconAssetPriority;

/**
 *  @brief Define the minimum width and height for icon asset.
 */
@property (nonatomic) IAAdAssetSize imageIconAssetMinSize;

/**
 *  @brief Defines the "Call to Action" asset priority.
 */
@property (nonatomic) IANativeAdAssetPriority callToActionTextAssetPriority;

/**
 *  @brief Defines the description (body text) asset priority.
 */
@property (nonatomic) IANativeAdAssetPriority descriptionTextAssetPriority;

/**
 *  @brief Open RTB 3.0 Native 1.0 - layout type.
 *  @Discussion Please use 'IANativeLayoutNewsFeed' for in-feed ad, and 'IANativeLayoutContentWall' for stand alone native ad.
 *
 * The default is IANativeLayoutNewsFeed.
 */
@property (nonatomic) IANativeLayout nativeLayout;

@end
