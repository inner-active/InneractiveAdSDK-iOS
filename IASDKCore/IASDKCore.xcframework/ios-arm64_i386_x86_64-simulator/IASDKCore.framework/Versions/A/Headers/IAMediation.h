//
//  IAMediation.h
//  IASDKCore
//
//  Created by Fyber on 20/03/2017.
//  Copyright © 2017 Fyber. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IAMediationInterface <NSObject>

@required
- (NSString * _Nonnull)name;
- (NSString * _Nonnull)version;

@end

@interface IAMediation : NSObject<IAMediationInterface>

@end
