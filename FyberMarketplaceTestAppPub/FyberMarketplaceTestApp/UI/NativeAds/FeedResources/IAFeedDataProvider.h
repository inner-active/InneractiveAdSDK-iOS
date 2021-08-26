//
//  IAFeedDataProvider.h
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 09/03/2017.
//  Copyright (c) 2017 Fyber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IAFeedDataProvider : NSObject

+ (id)sharedInstance;

- (NSInteger)feedObjectsCount;

- (UIImage *)profileImageAtIndex:(NSInteger)index;
- (NSString *)nameAtIndex:(NSInteger)index;
- (UIImage *)imageAtIndex:(NSInteger)index;
- (NSInteger)randomCount;
- (NSString *)randomTime;

@end
