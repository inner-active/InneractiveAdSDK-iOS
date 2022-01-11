//
//  FMPLogger.h
//  IASDKCore
//
//  Created on 15/06/2021.
//  Copyright © 2021 Fyber. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FMPLogLevel) {
    /**
    @brief Disabled.
    */
    FMPLogLevelOff = 0,
    
    /**
    @brief Includes system-level or multi-process information when reporting system errors
    */
    FMPLogLevelFault = 1,
    
    /**
    @brief Includes process-level errors
    */
    FMPLogLevelError = 2,
    
    /**
    @brief Includes info, error fault logging.
     */
    FMPLogLevelInfo = 3,
    
    /**
    @brief Includes debug information, and all types of logging.
     */
    FMPLogLevelDebug = 4,
};

NS_ASSUME_NONNULL_BEGIN

@interface FMPLogger : NSObject

+ (void)setLogLevel:(FMPLogLevel)logLevel;

@end

NS_ASSUME_NONNULL_END
