//
//  IASDKCore.h
//  IASDKCore
//
//  Created by Fyber on 01/02/2017.
//  Copyright © 2017 Fyber. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <IASDKCore/IAInterfaceSingleton.h>

@interface IASDKVideo : NSObject <IAInterfaceSingleton>

/**
 *  @brief Singleton method, use for any instance call.
 */
+ (instancetype _Null_unspecified)sharedInstance;

@end
