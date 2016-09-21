//
//  InneractiveAdSampleViewController.h
//  InneractiveAdSample
//
//  Created by Inneractive.
//  Copyright (c) 2014 Inneractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InneractiveAdSDK.h"



typedef NS_ENUM(NSUInteger, IaTableViewSectionType) {
    IaSection_LoadAdFromCode = 0
};

@interface InneractiveAdSampleViewController : UIViewController <InneractiveAdDelegate
> {}

@property (nonatomic) IaTableViewSectionType chosenSectionType;
@property (nonatomic) IaAdType chosenAdType;

@property (nonatomic, strong) IaAdView *adView;

@property (nonatomic, weak) IBOutlet UIButton *loadAdButton;
@property (nonatomic, weak) IBOutlet UIButton *showAdButton;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *adLoadActivityIndicator;

@end
