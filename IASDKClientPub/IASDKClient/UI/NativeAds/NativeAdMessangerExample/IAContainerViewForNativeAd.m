//
//  IAContainerViewForNativeAd.m
//  IASDKClient
//
//  Created by Inneractive on 09/03/2017.
//  Copyright (c) 2017 Inneractive. All rights reserved.
//

#import "IAContainerViewForNativeAd.h"
#import "IAColors.h"

#define kInterfaceElementsIndent 8
#define kMainAssetsViewAspectRatio (16.0/9.0)
#define kTitleLabelHeight 30
#define kDescriptionLabelHeight 40.0
#define kStarRatingWidth 30.0
#define kCTALableSize CGSizeMake(100,20)

#define kCloseButtonSize 30

@interface IAContainerViewForNativeAd ()

@property (nonatomic, strong) UIView *mainAssetView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *CTALabel;
@property (nonatomic, strong) UILabel *sponsoredPostLabel;
@property (nonatomic, strong) UIView *starRatingView;

@property (nonatomic, strong) UIImageView *temporaryView;

@end

@implementation IAContainerViewForNativeAd {}

#pragma mark - Inits

- (id)init {
    CGFloat adViewHeight = kInterfaceElementsIndent +
    kTitleLabelHeight +
    kInterfaceElementsIndent +
    kDescriptionLabelHeight +
    kInterfaceElementsIndent +
    [self.class mainAssetHeight] +
    kInterfaceElementsIndent +
    kCTALableSize.height +
    kInterfaceElementsIndent;
    
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].applicationFrame.size.width, adViewHeight)];
    
    if (self) {
        [self initInterface];
        super.clipsToBounds = YES;
    }
    
    return self;
}

- (void)initInterface {
    self.backgroundColor = [UIColor whiteColor];
    
    CGRect frame = self.bounds;
    
    // Icon image view
    frame.origin.x = kInterfaceElementsIndent;
    frame.origin.y = kInterfaceElementsIndent;
    frame.size.height = kTitleLabelHeight;
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.height, frame.size.height)];
    self.icon.layer.cornerRadius = 2;
    self.icon.layer.masksToBounds = YES;
    [self addSubview:self.icon];
    
    // Title label
    frame.origin.x += (self.icon.frame.origin.x + self.icon.frame.size.width + kInterfaceElementsIndent);
    frame.size.width -= frame.origin.x + (kInterfaceElementsIndent + kCloseButtonSize) + kInterfaceElementsIndent;
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
    _CTALabel.backgroundColor = kIAColorsAquamarine;
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
    UIImage *image = [UIImage imageNamed:@"CloseImage"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:image forState:UIControlStateNormal];
    button.frame = CGRectMake(self.bounds.size.width - sideSize - kInterfaceElementsIndent, kInterfaceElementsIndent, sideSize, sideSize);
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    button.translatesAutoresizingMaskIntoConstraints = YES;
    self.closeButton = button;
    [self addSubview:self.closeButton];
}

- (void)initTemporaryView {
    _temporaryView = [[UIImageView alloc] initWithFrame:_mainAssetView.frame];
    _temporaryView.image = [UIImage imageNamed:@"testAd"];
    _temporaryView.contentMode = UIViewContentModeScaleAspectFit;
    _temporaryView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _temporaryView.translatesAutoresizingMaskIntoConstraints = YES;
    _temporaryView.clipsToBounds = YES;
    _temporaryView.hidden = YES;
    [self addSubview:_temporaryView];
}

#pragma mark - IAInterfaceNativeRenderer

- (UIView * _Nonnull)IAMainAssetSuperview {
    return self.mainAssetView;
}

- (UIImageView * _Nullable)IAIconAsset {
    return self.icon;
}

- (UILabel * _Nullable)IATitleAsset {
    return self.titleLabel;
}

- (UILabel * _Nullable)IADescriptionAsset {
    return self.descriptionLabel;
}

- (UILabel * _Nullable)IACallToActionAsset {
    return self.CTALabel;
}

- (void)IAWillLayoutAssets {
    [self bringSubviewToFront:self.closeButton];
}

- (void)IADidLayoutAssets {
    NSLog(@"IADidLayoutAssets");
    
    _CTALabel.hidden = !(self.CTALabel.text.length > 0);
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

#pragma mark - Service

+ (CGFloat)mainAssetHeight {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat deviceWidth = screenSize.width < screenSize.height ? screenSize.width : screenSize.height;
    return deviceWidth / kMainAssetsViewAspectRatio;
}

@end
