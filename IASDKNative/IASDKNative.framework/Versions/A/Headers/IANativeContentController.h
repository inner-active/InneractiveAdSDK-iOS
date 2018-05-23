//
//  IANativeContentController.h
//  IASDKNative
//
//  Created by Inneractive on 25/04/2017.
//  Copyright © 2017 Inneractive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <IASDKCore/IAInterfaceBuilder.h>
#import <IASDKCore/IAContentController.h>

#import <IASDKVideo/IAVideoContentController.h>

@class IAAdModel;
@protocol IAVideoContentDelegate;
@protocol IANativeContentDelegate;

@protocol IANativeContentControllerBuilder <NSObject>

@required
@property (nonatomic, weak, nullable) id<IAVideoContentDelegate> videoContentDelegate;
@property (nonatomic, weak, nullable) id<IANativeContentDelegate> nativeContentDelegate;

@end

@interface IANativeContentController : IAVideoContentController <IAInterfaceBuilder, IANativeContentControllerBuilder>

+ (instancetype _Nullable)build:(void(^ _Nonnull)(id<IANativeContentControllerBuilder> _Nonnull builder))buildBlock;

/**
 *  @brief Native content can be 'Image' or 'Video', please use this API, to determine.
 */
- (BOOL)isVideoContent;

@end
