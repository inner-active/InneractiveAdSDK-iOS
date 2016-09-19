//
//  InneractiveNativeAdCollectionCell.m
//  InneractiveAdSample
//
//  Created by Nikita Fedorenko on 24/3/15.
//  Copyright (c) 2015 Inneractive. All rights reserved.
//

#import "InneractiveNativeAdCollectionCell.h"

#define kInterfaceElementsIndent 5.0
#define kTitleLabelHeight 20.0
#define kCTALabelHeight 20

@interface InneractiveNativeAdCollectionCell ()

@property (nonatomic, strong) UIView *mainAssetView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *CTALabel;

@end

@implementation InneractiveNativeAdCollectionCell

static CGSize _size;

#pragma mark - Inits

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initInterface];
    }
    
    return self;
}

- (void)initInterface {
    
    CGFloat cornerRadius = 2.0;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = cornerRadius;
    
    CGRect frame = CGRectZero;//just preventing analyze warning with dead store
    
    // Title label
    frame = self.contentView.bounds;
    frame.origin.x = kInterfaceElementsIndent;
    frame.origin.y = kInterfaceElementsIndent;
    frame.size.height = kTitleLabelHeight;
    frame.size.width -= 2 * kInterfaceElementsIndent;
    _titleLabel = [[UILabel alloc] initWithFrame:frame];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _titleLabel.font = [UIFont fontWithName:@"Roboto-Light" size:14];
    _titleLabel.textColor = [UIColor colorWithRed:96/255.0 green:99/255.0 blue:102/255.0 alpha:1.0];
    [self.contentView addSubview:_titleLabel];
    
    // Call to Action label
    frame = self.contentView.bounds;
    frame.size.height = kCTALabelHeight;
    frame.size.width -= 2 * kInterfaceElementsIndent;
    frame.origin.x = (self.contentView.bounds.size.width - frame.size.width ) /2;
    frame.origin.y = self.contentView.bounds.size.height - frame.size.height - kInterfaceElementsIndent;
    _CTALabel = [[UILabel alloc] initWithFrame:frame];
    _CTALabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _CTALabel.textAlignment = NSTextAlignmentCenter;
    _CTALabel.font = [UIFont fontWithName:@"Roboto-Bold" size:9];
    _CTALabel.textColor = [UIColor whiteColor];
    _CTALabel.backgroundColor = IA_BUTTONS_BACKGROUND_COLOR;
    _CTALabel.layer.cornerRadius = 2;
    _CTALabel.clipsToBounds = YES;
    _CTALabel.hidden = YES;
    [self.contentView addSubview:_CTALabel];
    
    // Main asset view
    frame = self.contentView.bounds;
    frame.origin.y = CGRectGetMaxY(_titleLabel.frame) + kInterfaceElementsIndent;
    frame.size.height = CGRectGetMinY(_CTALabel.frame) - kInterfaceElementsIndent - frame.origin.y;
    _mainAssetView = [[UIView alloc] initWithFrame:frame];
    _mainAssetView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _mainAssetView.backgroundColor = UIColor.blackColor; // default is black, later we will check, whether is video or image, and will set black or white
    
    [self.contentView addSubview:_mainAssetView];
}

#pragma mark - IaNativeAdRenderingDelegate

- (void)layoutAdAssets:(IaNativeAd *)adObject {
    // if we have received a video ad, let set the background to black, otherwise to white
    _mainAssetView.backgroundColor = adObject.isVideoAd ? UIColor.blackColor : UIColor.whiteColor;
    
    //Inneractive SDK API for ad rendering
    [[InneractiveAdSDK sharedInstance] loadMainAssetIntoView:self.mainAssetView withNativeAd:adObject];
    [[InneractiveAdSDK sharedInstance] loadTitleIntoTitleLabel:self.titleLabel withNativeAd:adObject];
    [[InneractiveAdSDK sharedInstance] loadCallToActionIntoLabel:self.CTALabel withNativeAd:adObject];
}

+ (CGSize)sizeForNativeAdCell {
    return _size;
}

#pragma mark - API

+ (void)setSize:(CGSize)value {
    _size = value;
}

@end
