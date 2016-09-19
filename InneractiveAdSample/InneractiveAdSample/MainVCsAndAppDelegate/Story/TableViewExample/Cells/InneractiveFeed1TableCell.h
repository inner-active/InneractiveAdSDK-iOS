//
//  InneractiveFeed1TableCell.h
//  InneractiveAdSample
//
//  Created by Alexey Karzov on 6/10/15.
//  Copyright (c) 2015 Inneractive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InneractiveFeed1TableCell : UITableViewCell

@property (readonly) UIImageView *feedImageView;
@property (readonly) UIImageView *avatarImageView;
@property (readonly) UILabel *authorNameLabel;

+ (CGFloat)preferredHeight;

@end
