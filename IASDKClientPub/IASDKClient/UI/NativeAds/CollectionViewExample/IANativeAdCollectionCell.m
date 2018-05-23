//
//  IANativeAdCollectionCell.m
//  IASDKClient
//
//  Created by Inneractive on 09/03/2017.
//  Copyright (c) 2017 Inneractive. All rights reserved.
//

#import "IANativeAdCollectionCell.h"
#import "IAColors.h"

#define kInterfaceElementsIndent 5.0
#define kTitleLabelHeight 20.0
#define kCTALabelHeight 20

@interface IANativeAdCollectionCell ()

@property (nonatomic, strong) UIView *mainAssetView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *CTALabel;

@end

@implementation IANativeAdCollectionCell {}

#pragma mark - Inits

- (void)awakeFromNib {
	[super awakeFromNib];
	
	[self initInterface];
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
    _CTALabel.backgroundColor = kIAColorsAquamarine;
    _CTALabel.layer.cornerRadius = 2;
    _CTALabel.clipsToBounds = YES;
    _CTALabel.hidden = YES;
    [self.contentView addSubview:_CTALabel];
    
    // Main asset view
    frame = self.contentView.bounds;
    frame.origin.y = CGRectGetMaxY(_titleLabel.frame) + kInterfaceElementsIndent + 3.0;
    frame.size.height = CGRectGetMinY(_CTALabel.frame) - kInterfaceElementsIndent - frame.origin.y;
    _mainAssetView = [[UIView alloc] initWithFrame:frame];
	_mainAssetView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _mainAssetView.backgroundColor = UIColor.blackColor; // default is black
	_mainAssetView.clipsToBounds = YES;
	
    [self.contentView addSubview:_mainAssetView];
}

#pragma mark - IAInterfaceNativeRenderer

- (UIView * _Nonnull)IAMainAssetSuperview {
	return self.mainAssetView;
}

- (UILabel * _Nullable)IATitleAsset {
	return self.titleLabel;
}

- (UIImageView * _Nullable)IAIconAsset {
	UIImageView *iconView = [UIImageView new];
	return iconView;
}

- (UILabel * _Nullable)IADescriptionAsset {
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
	return label;
}

- (UILabel * _Nullable)IACallToActionAsset {
	return self.CTALabel;
}

- (void)IAWillLayoutAssets {
	NSLog(@"IAWillLayoutAssets");
}

- (void)IADidLayoutAssets {
	NSLog(@"IADidLayoutAssets");
	
	_CTALabel.hidden = !(self.CTALabel.text.length > 0);
}

@end
