//
//  InneractiveFeedCollectionCell.m
//  InneractiveAdSample
//
//  Created by Nikita Fedorenko on 24/3/15.
//  Copyright (c) 2015 Inneractive. All rights reserved.
//

#import "InneractiveFeedCollectionCell.h"

@implementation InneractiveFeedCollectionCell {}

#pragma mark - Inits

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 2.0f;
    
    self.titleLabel.font = [UIFont fontWithName:@"Roboto-Light" size:14];
    self.titleLabel.textColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1.0];
    
    self.timeLabel.font = [UIFont fontWithName:@"Roboto-Light" size:14];
    self.timeLabel.textColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1.0];
}

@end
