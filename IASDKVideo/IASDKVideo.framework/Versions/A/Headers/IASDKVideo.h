//
//  IASDKVideo.h
//  IASDKVideo
//
//  Created by Fyber on 01/02/2017.
//  Copyright © 2017 Fyber. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <IASDKCore/IAInterfaceSingleton.h>

#import <IASDKVideo/IAVideoContentController.h>
#import <IASDKVideo/IAVideoContentDelegate.h>
#import <IASDKVideo/IAVideoLayout.h>
#import <IASDKVideo/IAVideoContentModel.h>
#import <IASDKVideo/IAVideoView.h>

/**
 *  @brief Should not be used never.
 */
extern NSString * const _Nonnull kIAVPAIDPlayerURLString;

@interface IASDKVideo : NSObject <IAInterfaceSingleton>

/**
 *  @brief Singleton method, use for any instance call.
 */
+ (instancetype _Null_unspecified)sharedInstance;

@end
