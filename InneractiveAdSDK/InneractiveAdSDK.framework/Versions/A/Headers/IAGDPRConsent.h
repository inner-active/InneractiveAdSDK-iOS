//
//  IAGDPRConsent.h
//  IAGDPRConsent
//
//  Created by Inneractive.
//  Copyright (c) 2018 Inneractive. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString * const IAGDPRConsentUserDefaultsKey;
FOUNDATION_EXTERN NSString * const IAGDPRConsentDataUserDefaultsKey;

typedef NS_ENUM(NSInteger, IAGDPRConsent) {
    IAGDPRConsentUnknown = -1,
    IAGDPRConsentDenied = 0,
    IAGDPRConsentGiven = 1
};
