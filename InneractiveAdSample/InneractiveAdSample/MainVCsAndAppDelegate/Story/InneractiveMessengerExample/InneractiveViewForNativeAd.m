//
//  InneractiveViewForNativeAd.m
//  InneractiveAdSample
//
//  Created by Nikita Fedorenko on 18/2/15.
//  Copyright (c) 2015 Inneractive. All rights reserved.
//

#import "InneractiveViewForNativeAd.h"

#define kInterfaceElementsIndent 8
#define kMainAssetsViewAspectRatio (16.0/9.0)
#define kTitleLabelHeight 30
#define kDescriptionLabelHeight 40.0
#define kStarRatingWidth 30.0
#define kCTALableSize CGSizeMake(100,20)

#define kCloseButtonSize 30

@interface InneractiveViewForNativeAd ()

@property (nonatomic, strong) UIView *mainAssetView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *CTALabel;
@property (nonatomic, strong) UILabel *sponsoredPostLabel;
@property (nonatomic, strong) UIView *starRatingView;

@property (nonatomic, strong) UIImageView *temporaryView;

@end

@implementation InneractiveViewForNativeAd {}

#pragma mark - Inits

+ (CGFloat)mainAssetHeight {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat deviceWidth = screenSize.width < screenSize.height ? screenSize.width : screenSize.height;
    return deviceWidth / kMainAssetsViewAspectRatio;
}

- (id)init {
    CGFloat adViewHeight = kInterfaceElementsIndent +
                            kTitleLabelHeight + kInterfaceElementsIndent +
                            kDescriptionLabelHeight + kInterfaceElementsIndent +
                            [[self class] mainAssetHeight] + kInterfaceElementsIndent +
                            kCTALableSize.height + kInterfaceElementsIndent;
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].applicationFrame.size.width, adViewHeight)];
    
    if (self) {
        [self initInterface];
    }
    
    return self;
}

- (void)initInterface {
    self.backgroundColor = [UIColor whiteColor];
    
    CGRect frame = self.bounds;
    
    // Title label
    frame.origin.x = kInterfaceElementsIndent;
    frame.origin.y = kInterfaceElementsIndent;
    frame.size.height = kTitleLabelHeight;
    frame.size.width -= kInterfaceElementsIndent + (kInterfaceElementsIndent + kCloseButtonSize) + kInterfaceElementsIndent;
    _titleLabel = [[UILabel alloc] initWithFrame:frame];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _titleLabel.font = [UIFont fontWithName:@"Roboto-Light" size:18];
    _titleLabel.textColor = [UIColor colorWithRed:96/255.0 green:99/255.0 blue:102/255.0 alpha:1.0];
    [self addSubview:_titleLabel];
    
    // Description label
    frame = self.bounds;
    frame.origin.x = kInterfaceElementsIndent;
    frame.origin.y = CGRectGetMaxY(_titleLabel.frame) + kInterfaceElementsIndent;
    frame.size.height = kDescriptionLabelHeight;
    frame.size.width -= 2 * kInterfaceElementsIndent + (kStarRatingWidth + kInterfaceElementsIndent);
    _descriptionLabel = [[UILabel alloc] initWithFrame:frame];
    _descriptionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.font = [UIFont fontWithName:@"Roboto-Light" size:15];
    _descriptionLabel.textColor = [UIColor colorWithRed:137/255.0 green:142/255.0 blue:145/255.0 alpha:1.0];
    [self addSubview:_descriptionLabel];
    
    frame = _descriptionLabel.frame;
    frame.size.width = kStarRatingWidth;
    frame.origin.x = CGRectGetMaxX(_descriptionLabel.frame) + kInterfaceElementsIndent;
    _starRatingView = [[UIView alloc] initWithFrame:frame];
    [self addSubview:_starRatingView];
    
    // Main asset view
    frame = self.bounds;
    frame.origin.y = CGRectGetMaxY(_descriptionLabel.frame) + kInterfaceElementsIndent;
    frame.size.height = [[self class] mainAssetHeight];
    _mainAssetView = [[UIView alloc] initWithFrame:frame];
    _mainAssetView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _mainAssetView.translatesAutoresizingMaskIntoConstraints = YES;
    
    // set the color of video borders in case the video does not fill in it's place holder;
    _mainAssetView.backgroundColor = UIColor.whiteColor;
    
    [self addSubview:_mainAssetView];
    
    // Call to Action label
    frame = self.bounds;
    frame.size.width = kCTALableSize.width;
    frame.size.height = kCTALableSize.height;
    frame.origin.x = self.bounds.size.width - kCTALableSize.width - kInterfaceElementsIndent;
    frame.origin.y = CGRectGetMaxY(_mainAssetView.frame) + kInterfaceElementsIndent;
    _CTALabel = [[UILabel alloc] initWithFrame:frame];
    _CTALabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    _CTALabel.textAlignment = NSTextAlignmentCenter;
    _CTALabel.font = [UIFont fontWithName:@"Roboto-Bold" size:15.5f];
    _CTALabel.textColor = [UIColor whiteColor];
    _CTALabel.backgroundColor = IA_BUTTONS_BACKGROUND_COLOR;
    _CTALabel.layer.cornerRadius = 2;
    _CTALabel.clipsToBounds = YES;
    _CTALabel.hidden = YES;
    [self addSubview:_CTALabel];
    
    // Sponsored label
    _sponsoredPostLabel = [UILabel new];
    _sponsoredPostLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    _sponsoredPostLabel.text = @"Sponsored Post";
    _sponsoredPostLabel.font = [UIFont fontWithName:@"Roboto-Light" size:14];
    _sponsoredPostLabel.textColor = [UIColor colorWithRed:204/255.0 green:208/255.0 blue:212/255.0 alpha:1.0];
    [_sponsoredPostLabel sizeToFit];
    [self addSubview:_sponsoredPostLabel];
    
    frame = self.bounds;
    frame.origin.x = kInterfaceElementsIndent;
    frame.origin.y = self.bounds.size.height - _sponsoredPostLabel.frame.size.height - kInterfaceElementsIndent;
    frame.size.width = _sponsoredPostLabel.frame.size.width;
    frame.size.height = _sponsoredPostLabel.frame.size.height;
    _sponsoredPostLabel.frame = frame;
    
    // Additional views
    [self initTemporaryView];
    [self initCloseButton];
    
    // Adding shadow at the bottom of the view
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.masksToBounds = NO;
    self.layer.shadowOpacity = 1.0;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.layer.shouldRasterize = YES;
}

- (void)initCloseButton {
    const CGFloat sideSize = kCloseButtonSize;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.bounds.size.width - sideSize - kInterfaceElementsIndent, kInterfaceElementsIndent, sideSize, sideSize);
    [button setBackgroundImage:[UIImage imageNamed:@"CloseImage"] forState:UIControlStateNormal];
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    button.translatesAutoresizingMaskIntoConstraints = YES;
    self.closeButton = button;
    [self addSubview:self.closeButton];
}

- (void)initTemporaryView {
    CGRect frame = self.bounds;
    frame.origin.y = CGRectGetMaxY(_titleLabel.frame);
    frame.size.height = _sponsoredPostLabel.frame.origin.y - frame.origin.y;
    _temporaryView = [[UIImageView alloc] initWithFrame:frame];
    _temporaryView.image = [UIImage imageNamed:@"testAd"];
    _temporaryView.contentMode = UIViewContentModeScaleAspectFit;
    _temporaryView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _temporaryView.translatesAutoresizingMaskIntoConstraints = YES;
    _temporaryView.clipsToBounds = YES;
    _temporaryView.hidden = YES;
    [self addSubview:_temporaryView];
}

#pragma mark - IaNativeAdRenderingDelegate

- (void)layoutAdAssets:(IaNativeAd *)adObject {
    //Inneractive SDK API for ad rendering
    [[InneractiveAdSDK sharedInstance] loadMainAssetIntoView:self.mainAssetView withNativeAd:adObject];
    [[InneractiveAdSDK sharedInstance] loadTitleIntoTitleLabel:self.titleLabel withNativeAd:adObject];
    [[InneractiveAdSDK sharedInstance] loadBodyTextIntoTitleLabel:self.descriptionLabel withNativeAd:adObject];
    [[InneractiveAdSDK sharedInstance] loadCallToActionIntoLabel:self.CTALabel withNativeAd:adObject];
    [[InneractiveAdSDK sharedInstance] loadStarRatingIntoView:self.starRatingView withNativeAd:adObject];
    
    [self bringSubviewToFront:self.closeButton];
}

#pragma mark - API

- (void)switchToTempMode {
    if (self.temporaryView.hidden) {
        self.temporaryView.hidden = NO;
    }
    
    [self bringSubviewToFront:self.closeButton];
}

- (void)switchToAdMode {
    self.temporaryView.hidden = YES;
}

@end
