//
//  IARegularAdVC.h
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 15/02/2017.
//  Copyright © 2017 Fyber. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SampleAdType) {
    SampleAdTypeBanner = 0,
    SampleAdTypeRectangle = 1,
    SampleAdTypeInterstitial = 2,
	SampleAdTypeRewarded = 3
};

@class IAAdSpot;
@class IAAdModel;

@interface IARegularAdVC : UIViewController

@property (nonatomic) SampleAdType requestedAdType;

@end
