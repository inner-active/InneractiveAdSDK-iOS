//
//  InneractiveViewForNativeAd.h
//  InneractiveAdSample
//
//  Created by Nikita Fedorenko on 18/2/15.
//  Copyright (c) 2015 Inneractive. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <InneractiveAdSDK/InneractiveAdSDK.h>

/*
 * A UIView subclass, that implements "IaNativeAdRenderingDelegate" protocol and is used to render and display the ads.
 * An instance of this class is passed to 'showNativeAd:atView:' InneractiveAdSDK method as a view parameter.
 */
@interface InneractiveViewForNativeAd : UIView <IaNativeAdRenderingDelegate>

@property (nonatomic, strong) UIButton *closeButton;

- (void)switchToTempMode;
- (void)switchToAdMode;

@end
