//
//  IAFeedCollectionCell.m
//  IASDKClient
//
//  Created by Inneractive on 09/03/2017.
//  Copyright (c) 2017 Inneractive. All rights reserved.
//

#import "IAFeedCollectionCell.h"

@implementation IAFeedCollectionCell {}

#pragma mark - Inits

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 2.0f;
    
    self.titleLabel.textColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1.0];    
    self.timeLabel.textColor = [UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1.0];
}

@end
