//
//  FMPBiddingManager.h
//  IASDKCore
//
//  Created by Fyber on 25/03/2021.
//  Copyright © 2021 Fyber. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <IASDKCore/IAInterfaceSingleton.h>

@interface FMPBiddingManager : NSObject<IAInterfaceSingleton>

- (NSString * _Nullable)biddingToken;

@end
