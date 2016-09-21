//
//  InneractivePositioningPickerView.m
//  InneractiveAdSample
//
//  Created by Nikita Fedorenko on 11/19/14.
//  Copyright (c) 2014 Inneractive. All rights reserved.
//

#import "InneractivePositioningPickerView.h"

@implementation InneractivePositioningPickerView {}

#pragma mark - Inits

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = IA_NAV_BAR_COLOR;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 2.0f;
}

@end
