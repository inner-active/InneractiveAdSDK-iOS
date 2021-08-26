//
//  IAMRAIDContentModel.h
//  IASDKMRAID
//
//  Created by Fyber on 27/03/2017.
//  Copyright © 2017 Fyber. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <IASDKCore/IAInterfaceBuilder.h>
#import <IASDKCore/IAInterfaceContentModel.h>

@protocol IAMRAIDContentModelBuilder <NSObject>

@required
@property (nonatomic, strong, nonnull) NSString *HTMLString;

@end

@interface IAMRAIDContentModel : NSObject <IAInterfaceBuilder, IAInterfaceContentModel, IAMRAIDContentModelBuilder>

+ (instancetype _Nullable)build:(void(^ _Nonnull)(id<IAMRAIDContentModelBuilder> _Nonnull builder))buildBlock;

@end
