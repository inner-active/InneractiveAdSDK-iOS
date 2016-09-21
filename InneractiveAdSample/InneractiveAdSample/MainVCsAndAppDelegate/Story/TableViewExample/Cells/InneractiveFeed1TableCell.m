//
//  InneractiveFeed1TableCell.m
//  InneractiveAdSample
//
//  Created by Alexey Karzov on 6/10/15.
//  Copyright (c) 2015 Inneractive. All rights reserved.
//

#import "InneractiveFeed1TableCell.h"

#define kInterfaceElementsIndent 8
#define kAvatarImageViewHeight 30

@implementation InneractiveFeed1TableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initInterface];
    }
    return self;
}

+ (CGFloat)preferredHeight {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat deviceWidth = screenSize.width < screenSize.height ? screenSize.width : screenSize.height;
    return deviceWidth;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = CGRectZero;//just preventing analyze warning with dead store
    
    // Avatar imageView
    frame = CGRectMake(kInterfaceElementsIndent, kInterfaceElementsIndent, kAvatarImageViewHeight, kAvatarImageViewHeight);
    self.avatarImageView.frame = frame;
    
    // Name label
    frame = self.contentView.bounds;
    frame.origin.x = CGRectGetMaxX(self.avatarImageView.frame) + kInterfaceElementsIndent;
    frame.origin.y = kInterfaceElementsIndent;
    frame.size.width -= frame.origin.x + kInterfaceElementsIndent;
    frame.size.height = kAvatarImageViewHeight;
    self.authorNameLabel.frame = frame;
    
    // Main imageView
    float feedImageViewSize = self.contentView.bounds.size.height - (CGRectGetMaxY(self.avatarImageView.frame) + kInterfaceElementsIndent);
    frame.size.width = self.contentView.bounds.size.width;
    frame.size.height = feedImageViewSize;
    frame.origin.x = (self.contentView.bounds.size.width - frame.size.width) / 2;
    frame.origin.y = CGRectGetMaxY(self.avatarImageView.frame) + kInterfaceElementsIndent;
    self.feedImageView.frame = frame;
}

#pragma mark - private methods

- (void)initInterface {
    _avatarImageView = [UIImageView new];
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    _avatarImageView.clipsToBounds = YES;
    [self.contentView addSubview:_avatarImageView];
    
    _feedImageView = [UIImageView new];
    _feedImageView.contentMode = UIViewContentModeScaleAspectFill;
    _feedImageView.clipsToBounds = YES;
    [self.contentView addSubview:_feedImageView];
    
    _authorNameLabel = [UILabel new];
    _authorNameLabel.font = [UIFont fontWithName:@"Roboto-Light" size:18];
    _authorNameLabel.textColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1.0];
    [self.contentView addSubview:_authorNameLabel];
    
    [self setNeedsLayout];
}

@end
