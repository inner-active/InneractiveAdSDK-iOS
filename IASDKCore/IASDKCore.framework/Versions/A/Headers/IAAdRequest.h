//
//  IAAdRequest.h
//  IASDKCore
//
//  Created by Inneractive on 13/03/2017.
//  Copyright © 2017 Inneractive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IAInterfaceBuilder.h"
#import "IARequest.h"
#import "IAInterfaceAdDescription.h"

@class IAUserData;
@class CLLocation;
@class IADebugger;
@class IAMediation;

@protocol IAAdRequestBuilder <NSObject>

@required

@property (nonatomic) BOOL useSecureConnections;

/**
 *  @brief A mandatory parameter.
 */
@property (nonatomic, copy, nonnull) NSString *spotID;

/**
 *  @brief Timeout in seconds before 'ready on client' will be received.
 */
@property (nonatomic) NSTimeInterval timeout;

@property (nonatomic, copy, nullable) IAUserData *userData;

/**
 *  @brief Single keyword string or several keywords, separated by comma.
 */
@property (nonatomic, copy, nullable) NSString *keywords;

/**
 *  @brief Current location. Use for better ad targeting.
 */
@property (nonatomic, copy, nullable) CLLocation *location;

@property (nonatomic, copy, nullable) IADebugger *debugger;

/**
 *  @brief Subtype expected configuration. In case a certain type of ad has extra configuration, assign it here.
 */
@property (nonatomic, copy, nullable) id<IAInterfaceAdDescription> subtypeDescription;

@end

@interface IAAdRequest : IARequest <IAInterfaceBuilder, IAAdRequestBuilder, NSCopying>

/**
 *  @brief Use in order to determine type of unit returned.
 *  @discussion Will be assigned at response parsing phase.
 */
@property (nonatomic, strong, nullable, readonly) NSString *unitID;

+ (instancetype _Nullable)build:(void(^ _Nonnull)(id<IAAdRequestBuilder> _Nonnull builder))buildBlock;

@end
