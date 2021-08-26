//
//  IAVideoContentModel.h
//  IASDKVideo
//
//  Created by Fyber on 12/04/2017.
//  Copyright © 2017 Fyber. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <IASDKCore/IAInterfaceBuilder.h>
#import <IASDKCore/IAInterfaceContentModel.h>

typedef enum : NSInteger {
    IAVideoTypeUndefined = 0,
    IAVideoTypeMRect __attribute__((deprecated)),
    IAVideoTypeInterstitial,
    IAVideoTypeRewarded,
} IAVideoType;

@class IAVASTModel;

@interface IAVideoContentModel : NSObject <IAInterfaceContentModel>

@property (nonatomic) IAVideoType videoType;
@property (nonatomic, strong, nonnull) IAVASTModel *VASTModel;
@property (nonatomic) NSTimeInterval skipSeconds;

@end
