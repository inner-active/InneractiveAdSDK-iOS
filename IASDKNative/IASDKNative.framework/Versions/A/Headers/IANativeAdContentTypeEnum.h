//
//  IANativeAdContentTypeEnum.h
//  IASDKNative
//
//  Created by Inneractive on 26/04/2017.
//  Copyright © 2017 Inneractive. All rights reserved.
//

#ifndef IANativeAdContentTypeEnum_h
#define IANativeAdContentTypeEnum_h

#import <Foundation/Foundation.h>

/**
 *  @typedef IANativeAdContentType
 *  @brief Native Ad Main Asset content definition.
 */
typedef NS_ENUM(NSUInteger, IANativeAdContentType) {
    /**
     *  @brief Both video and image are allowed.
     */
    IANativeAdContentTypeAny = 1,
    /**
     *  @brief Only video.
     */
    IANativeAdContentTypeVideo = 2,
    /**
     *  @brief Only image.
     */
    IANativeAdContentTypeImage = 3,
};

#endif /* IANativeAdContentTypeEnum_h */
