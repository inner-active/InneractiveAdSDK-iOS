//
//  FYBCounterView.h
//
//  Created by Fyber on 22/12/14.
//  Copyright (c) 2017 Fyber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYBCounterView : UIView

/**
 * @brief A video remaining time to end.
 */
@property (nonatomic) NSTimeInterval remainingTime;

/**
 *  @brief Actual label.
 */
@property (nonatomic, strong) UILabel *timeLabel;

@end
