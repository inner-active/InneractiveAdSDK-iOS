//
//  IANativeLayoutEnum.h
//  IASDKNative
//
//  Created by Inneractive on 1/6/15.
//  Copyright (c) 2015 Inneractive. All rights reserved.
//

#ifndef InneractiveAdSDK_IANativeLayoutEnum_h
#define InneractiveAdSDK_IANativeLayoutEnum_h

#endif

typedef NS_ENUM (NSInteger, IANativeLayout) {
    IANativeLayoutUndefined = 0,
    IANativeLayoutContentWall = 1,
    IANativeLayoutAppWall,
    IANativeLayoutNewsFeed,
    IANativeLayoutChatList,
    IANativeLayoutCarousel,
    IANativeLayoutContentStream,
    IANativeLayoutGridToContent//grid adjoining the content
    //500+ reserved for Exchange specific formats
};
