//
//  IAInterfaceBuilder.h
//  IASDKCore
//
//  Created by Fyber on 20/03/2017.
//  Copyright © 2017 Fyber. All rights reserved.
//

#ifndef IAInterfaceBuilder_h
#define IAInterfaceBuilder_h

#import <Foundation/Foundation.h>

#import <IASDKCore/IAInterfaceAllocBlocker.h>

@protocol IAInterfaceBuilder;

@protocol IAInterfaceBuilder <IAInterfaceAllocBlocker>

@required
+ (instancetype _Nullable)build:(void(^ _Nonnull)(id<IAInterfaceBuilder> _Nonnull builder))buildBlock;

@end

#endif /* IAInterfaceBuilder_h */
