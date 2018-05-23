//
//  IARegularAdVC.h
//  IASDKClient
//
//  Created by Inneractive on 15/02/2017.
//  Copyright © 2017 Inneractive. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SampleAdType) {
    SampleAdTypeBanner = 0,
    SampleAdTypeRectangle = 1,
	SampleAdTypeSquare = 2,
	SampleAdTypeLandscape = 3,
    SampleAdTypeInterstitial = 4,
	SampleAdTypeVertical = 5
};

@class IAAdSpot;
@class IAAdModel;

@interface IARegularAdVC : UIViewController

@property (nonatomic) SampleAdType requestedAdType;

@end
