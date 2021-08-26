//
//  IAFeedTableCell.m
//  FyberMarketplaceTestApp
//
//  Created by Fyber on 09/03/2017.
//  Copyright (c) 2017 Fyber. All rights reserved.
//

#import "IAFeedTableCell.h"

@interface IAFeedTableCell ()

@property (nonatomic, readwrite) IBOutlet UIImageView *feedImageView;
@property (nonatomic, readwrite) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, readwrite) IBOutlet UILabel *authorNameLabel;

@end

@implementation IAFeedTableCell {}

#pragma mark - 

- (void)awakeFromNib {
	[super awakeFromNib];
	
    self.authorNameLabel.textColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1.0];
}

#pragma mark - API

+ (CGFloat)preferredHeight {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat preferredHeight = screenSize.width < screenSize.height ? screenSize.width : screenSize.height;
    return preferredHeight;
}

@end
