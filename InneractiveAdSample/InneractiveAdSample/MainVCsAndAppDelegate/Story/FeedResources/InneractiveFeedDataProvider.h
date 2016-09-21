//
//  InneractiveFeedDataProvider.h
//  InneractiveAdSample
//
//  Created by Alexey Karzov on 6/10/15.
//  Copyright (c) 2015 Inneractive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InneractiveFeedDataProvider : NSObject

+ (id)sharedInstance;

- (int)feedObjectsCount;

- (UIImage *)profileImageAtIndex:(NSInteger)index;
- (NSString *)nameAtIndex:(NSInteger)index;
- (UIImage *)imageAtIndex:(NSInteger)index;
- (int)randomCount;
- (NSString *)randomTime;

@end
