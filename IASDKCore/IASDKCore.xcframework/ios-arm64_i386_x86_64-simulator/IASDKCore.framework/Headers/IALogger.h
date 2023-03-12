//
//  IALogger.h
//  IASDKCore
//
//  Created by Digital Turbine on 23/02/2017.
//  Copyright © 2022 Digital Turbine. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @typedef IALogLevel
 *  @brief Log level.
 */
typedef NS_ENUM(NSUInteger, IALogLevel) {
    /**
     *  @brief Disabled.
     */
    IALogLevelOff = 0,
    /**
     *  @brief Includes error logging.
     */
    IALogLevelError = 1,
    /**
     *  @brief Includes warnings and error logging.
     */
    IALogLevelWarn = 2,
    /**
     *  @brief Includes general info., warnings and error logging.
     */
    IALogLevelInfo = 3,
    /**
     *  @brief Includes debug information, general info., warnings and error logging.
     */
    IALogLevelDebug = 4,
    /**
     *  @brief Includes all types of logging.
     */
    IALogLevelVerbose = 5,
};

@interface IALogger : NSObject

/**
 *  @brief Sets IASDK logging level for:
 *
 *  1. Xcode console
 *
 *  2. Apple System Logs
 *
 *  @param logLevel log level
 */
+ (void)setLogLevel:(IALogLevel)logLevel DEPRECATED_MSG_ATTRIBUTE("IALogger class is deprecated and will be removed in future versions; please use FMPLogger API instead.");
+ (IALogLevel)logLevel:(IALogLevel)logLevel DEPRECATED_MSG_ATTRIBUTE("IALogger class is deprecated and will be removed in future versions; please use FMPLogger API instead.");

@end
