//
//  IANativeAdResponseModel.h
//  IASDKNative
//
//  Created by Inneractive on 01/03/2017.
//  Copyright © 2017 Inneractive. All rights reserved.
//

#ifndef IANativeAdResponseModel_h
#define IANativeAdResponseModel_h

#import <Foundation/Foundation.h>

@interface IANativeAdResponseModel : NSObject

/**
 *  @brief Title;
 */
@property (nullable, nonatomic, strong) NSString *titleText; // IA supported / FB supported;

/**
 *  @brief Icon.
 */
@property (nullable, nonatomic, strong) NSString *iconImageURLString; // IA supported / FB supported;

/**
 *  @brief Video VAST 2.0 XML content as NSData.
 */
@property (nullable, nonatomic, strong) NSData *VASTXMLData; // IA supported / FB supported;

/**
 *  @brief Cover Image.
 */
@property (nullable, nonatomic, strong) NSString *largeImageURLString; // IA supported / FB supported;

/**
 *  @brief Description.
 */
@property (nullable, nonatomic, strong) NSString *descriptionString; // IA supported / FB supported;

/**
 *  @brief Call To Action text.
 */
@property (nullable, nonatomic, strong) NSString *CTAText; // IA supported / FB supported;

@end

#endif /* IANativeAdResponseModel_h */
