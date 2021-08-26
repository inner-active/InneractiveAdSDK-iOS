//
//  IAUnitController.h
//  IASDKCore
//
//  Created by Fyber on 19/03/2017.
//  Copyright © 2017 Fyber. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <IASDKCore/IAInterfaceUnitController.h>

/**
 *  @brief Abstract class, for service purpose. Should not be used explicitly.
 */
@interface IAUnitController : NSObject <IAInterfaceUnitController>

- (BOOL)isReady;

@end
