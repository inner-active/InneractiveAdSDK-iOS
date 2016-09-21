//
//  InneractiveNativeAdCollectionCell.h
//  InneractiveAdSample
//
//  Created by Nikita Fedorenko on 24/3/15.
//  Copyright (c) 2015 Inneractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InneractiveAdSDK.h"

/*
 * A cell, that is used for ad content.
 */
@interface InneractiveNativeAdCollectionCell : UICollectionViewCell <IaNativeAdCellRenderingDelegate>

+ (void)setSize:(CGSize)value;

@end
