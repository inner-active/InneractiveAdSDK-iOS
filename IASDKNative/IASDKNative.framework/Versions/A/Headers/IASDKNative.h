//
//  IASDKNative.h
//  IASDKNative
//
//  Created by Inneractive on 29/01/2017.
//  Copyright © 2017 Inneractive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <IASDKCore/IAInterfaceSingleton.h>

#import "IANativeContentController.h"
#import "IANativeContentDelegate.h"
#import "IANativeContentModel.h"
#import "IANativeAdResponseModel.h"
#import "IANativeAdDescription.h"
#import "IANativeAdContentTypeEnum.h"
#import "IANativeAdAssetDescription.h"
#import "IANativeLayoutEnum.h"

@interface IASDKNative : NSObject <IAInterfaceSingleton>

/**
 *  @brief Singleton method, use for any instance call.
 */
+ (instancetype)sharedInstance;

@end
