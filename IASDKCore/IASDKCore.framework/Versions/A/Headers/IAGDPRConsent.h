//
//  IAGDPRConsent.h
//  IASDKCore
//
//  Created by Inneractive on 08/06/2018.
//  Copyright (c) 2018 Inneractive. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString * const kIAGDPRConsentUserDefaultsKey;
FOUNDATION_EXTERN NSString * const kIAGDPRConsentDataUserDefaultsKey;

typedef NS_ENUM(NSInteger, IAGDPRConsentType) {
    IAGDPRConsentTypeUnknown = -1,
    IAGDPRConsentTypeDenied = 0,
    IAGDPRConsentTypeGiven = 1
};
