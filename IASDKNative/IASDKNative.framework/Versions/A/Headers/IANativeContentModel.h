//
//  IANativeContentModel.h
//  IASDKNative
//
//  Created by Inneractive on 30/04/2017.
//  Copyright © 2017 Inneractive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <IASDKCore/IAInterfaceBuilder.h>
#import <IASDKCore/IAInterfaceContentModel.h>

@class IANativeAdResponseModel;

@class IAVASTModel;

@interface IANativeContentModel : NSObject <IAInterfaceBuilder, IAInterfaceContentModel>

@property (nonatomic, strong, nonnull, readonly) IANativeAdResponseModel *responseModel;

@property (nonatomic, strong, nonnull, readonly) IAVASTModel *VASTModel;

@end
