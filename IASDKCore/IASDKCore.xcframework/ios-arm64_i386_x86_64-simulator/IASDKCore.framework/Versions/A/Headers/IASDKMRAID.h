//
//  IASDKCore.h
//  IASDKCore
//
//  Created by Fyber on 02/02/2017.
//  Copyright © 2017 Fyber. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <IASDKCore/IAInterfaceSingleton.h>

@interface IASDKMRAID : NSObject <IAInterfaceSingleton>

/**
 *  @brief Singleton method, use for any instance call.
 */
+ (instancetype)sharedInstance;

@end
