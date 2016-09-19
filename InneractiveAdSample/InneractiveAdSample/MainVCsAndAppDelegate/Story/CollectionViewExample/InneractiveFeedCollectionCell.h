//
//  InneractiveFeedCollectionCell.h
//  InneractiveAdSample
//
//  Created by Nikita Fedorenko on 24/3/15.
//  Copyright (c) 2015 Inneractive. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * A cell, that is used for regular feed.
 */
@interface InneractiveFeedCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *feedImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsCountLabel;

@end
