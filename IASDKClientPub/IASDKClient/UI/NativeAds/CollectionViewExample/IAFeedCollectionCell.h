//
//  IAFeedCollectionCell.h
//  IASDKClient
//
//  Created by Inneractive on 10/03/2017.
//  Copyright (c) 2017 Inneractive. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * A cell, that is used for regular feed.
 */
@interface IAFeedCollectionCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *feedImageView;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *likesCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *commentsCountLabel;

@end
