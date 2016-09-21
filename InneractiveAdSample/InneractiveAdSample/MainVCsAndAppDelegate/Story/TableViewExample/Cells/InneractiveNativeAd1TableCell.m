//
//  InneractiveNativeAd1TableCell.m
//  InneractiveAdSample
//
//  Created by Alexey Karzov on 6/10/15.
//  Copyright (c) 2015 Inneractive. All rights reserved.
//

#import "InneractiveNativeAd1TableCell.h"

#define kMainAssetsViewAspectRatio (16.0/9.0)
#define kIconImageViewHeight 30
#define kDescriptionLabelHeight 40
#define kCTALableSize CGSizeMake(100,20)
#define kInterfaceElementsIndent 8
#define kContentInsets UIEdgeInsetsMake(5,0,5,0)

@interface InneractiveNativeAd1TableCell ()

@property (nonatomic, strong) UIView *mainAssetView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *CTALabel;

@property (nonatomic, strong) UILabel *sponsoredLabel;

@end

@implementation InneractiveNativeAd1TableCell {}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initInterface];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Cell Layout:
    // indent - icon - indent - title - indent
    // indent
    // main asset
    // indent
    // indent - description - indent
    // indent
    // indent - sponsored - flexible space - CTA - indent
    
    CGRect availableFrame = self.contentView.bounds;
    availableFrame.origin.x += kContentInsets.left;
    availableFrame.origin.y += kContentInsets.top;
    availableFrame.size.width -= kContentInsets.left + kContentInsets.right;
    availableFrame.size.height -= kContentInsets.top + kContentInsets.bottom;
    
    CGRect frame = availableFrame;
    
    // Icon imageView
    frame.size.width = kIconImageViewHeight;
    frame.size.height = kIconImageViewHeight;
    frame.origin.x += kInterfaceElementsIndent;
    self.iconImageView.frame = frame;
    
    // Title label
    frame = availableFrame;
    frame.origin.x = CGRectGetMaxX(self.iconImageView.frame) + kInterfaceElementsIndent;
    frame.size.width -= frame.origin.x + kInterfaceElementsIndent;
    frame.size.height = kIconImageViewHeight;
    self.titleLabel.frame = frame;
    
    // Main asset view
    frame = availableFrame;
    frame.size.height = [[self class] mainAssetViewHeight];
    frame.origin.y = CGRectGetMaxY(self.iconImageView.frame) + kInterfaceElementsIndent;
    self.mainAssetView.frame = frame;
    
    // Description label
    frame = availableFrame;
    frame.origin.x += kInterfaceElementsIndent;
    frame.origin.y = CGRectGetMaxY(self.mainAssetView.frame) + kInterfaceElementsIndent;
    frame.size.width = availableFrame.size.width - 2 * kInterfaceElementsIndent;
    frame.size.height = kDescriptionLabelHeight;
    self.descriptionLabel.frame = frame;
    
    // CTA label
    frame = availableFrame;
    frame.size.width = kCTALableSize.width;
    frame.size.height = kCTALableSize.height;
    frame.origin.x += availableFrame.size.width - frame.size.width - kInterfaceElementsIndent;
    frame.origin.y = CGRectGetMaxY(self.descriptionLabel.frame) + kInterfaceElementsIndent;
    self.CTALabel.frame = frame;
    
    // Sponsored label
    frame = availableFrame;
    frame.origin.x += kInterfaceElementsIndent;
    frame.origin.y = CGRectGetMidY(self.CTALabel.frame) - _sponsoredLabel.frame.size.height/2;
    frame.size.width = _sponsoredLabel.frame.size.width;
    frame.size.height = _sponsoredLabel.frame.size.height;
    _sponsoredLabel.frame = frame;
}

#pragma mark - private methods

- (void)initInterface {
    _iconImageView = [UIImageView new];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_iconImageView];
    
    _mainAssetView = [UIView new];
    
    // set the color of video borders in case the video does not fill in it's place holder;
    _mainAssetView.backgroundColor = UIColor.whiteColor;
    
    [self.contentView addSubview:_mainAssetView];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont fontWithName:@"Roboto-Light" size:18];
    _titleLabel.textColor = [UIColor colorWithRed:96/255.0 green:99/255.0 blue:102/255.0 alpha:1.0];
    [self.contentView addSubview:_titleLabel];
    
    _descriptionLabel = [UILabel new];
    _descriptionLabel.font = [UIFont fontWithName:@"Roboto-Light" size:15];
    _descriptionLabel.textColor = [UIColor colorWithRed:137/255.0 green:142/255.0 blue:145/255.0 alpha:1.0];
    _descriptionLabel.numberOfLines = 0;
    [self.contentView addSubview:_descriptionLabel];
    
    _CTALabel = [UILabel new];
    _CTALabel.textAlignment = NSTextAlignmentCenter;
    _CTALabel.font = [UIFont fontWithName:@"Roboto-Bold" size:15.5f];
    _CTALabel.textColor = [UIColor whiteColor];
    _CTALabel.backgroundColor = IA_BUTTONS_BACKGROUND_COLOR;
    _CTALabel.layer.cornerRadius = 2;
    _CTALabel.clipsToBounds = YES;
    _CTALabel.hidden = YES;
    [self.contentView addSubview:_CTALabel];
    
    _sponsoredLabel = [UILabel new];
    _sponsoredLabel.text = @"Sponsored Post";
    _sponsoredLabel.font = [UIFont fontWithName:@"Roboto-Light" size:14];
    _sponsoredLabel.textColor = [UIColor colorWithRed:204/255.0 green:208/255.0 blue:212/255.0 alpha:1.0];
    [_sponsoredLabel sizeToFit];
    [self.contentView addSubview:_sponsoredLabel];
    
    [self setNeedsLayout];
}

+ (CGFloat)mainAssetViewHeight {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat deviceWidth = screenSize.width < screenSize.height ? screenSize.width : screenSize.height;
    return deviceWidth / kMainAssetsViewAspectRatio;
}

#pragma mark - IaNativeAdRendering

- (void)layoutAdAssets:(IaNativeAd *)adObject {
    //Inneractive SDK API for ad rendering
    [[InneractiveAdSDK sharedInstance] loadMainAssetIntoView:self.mainAssetView withNativeAd:adObject];
    [[InneractiveAdSDK sharedInstance] loadIconIntoImageView:self.iconImageView withNativeAd:adObject];
    [[InneractiveAdSDK sharedInstance] loadTitleIntoTitleLabel:self.titleLabel withNativeAd:adObject];
    [[InneractiveAdSDK sharedInstance] loadBodyTextIntoTitleLabel:self.descriptionLabel withNativeAd:adObject];
    [[InneractiveAdSDK sharedInstance] loadCallToActionIntoLabel:self.CTALabel withNativeAd:adObject];
}

+ (CGSize)sizeForNativeAdCell {
    CGFloat mainAssetViewHeight = [self mainAssetViewHeight];
    CGFloat otherElementsHeight = kIconImageViewHeight + kInterfaceElementsIndent + kDescriptionLabelHeight + kInterfaceElementsIndent + kCTALableSize.height;
    CGFloat cellHeight = ceil(kContentInsets.top + mainAssetViewHeight + kInterfaceElementsIndent + otherElementsHeight + kContentInsets.bottom);
    return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), cellHeight);
}

@end
