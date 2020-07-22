//
//  IAGlobalAdDelegate.h
//  IASDKCore
//
//  Created by Fyber on 08/12/2019.
//  Copyright © 2019 Fyber. All rights reserved.
//

#ifndef IAGlobalAdDelegate_h
#define IAGlobalAdDelegate_h

#import <IASDKCore/IAAdRequest.h>
#import <IASDKCore/IAImpressionData.h>

@protocol IAGlobalAdDelegate <NSObject>

@required
/**
 *  @brief The impression info of the shown ad.
 */
- (void)adDidShowWithImpressionData:(IAImpressionData * _Nonnull)impressionData withAdRequest:(IAAdRequest * _Nonnull)adRequest;

@end

#endif /* IAGlobalAdDelegate_h */
