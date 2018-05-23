//
//  IAFeedTableCell.h
//  IASDKClient
//
//  Created by Inneractive on 09/03/2017.
//  Copyright (c) 2017 Inneractive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IAFeedTableCell : UITableViewCell

@property (readonly) UIImageView *feedImageView;
@property (readonly) UIImageView *avatarImageView;
@property (readonly) UILabel *authorNameLabel;

+ (CGFloat)preferredHeight;

@end
