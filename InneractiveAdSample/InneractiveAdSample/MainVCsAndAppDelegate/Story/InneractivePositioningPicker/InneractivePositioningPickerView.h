//
//  InneractivePositioningPickerView.h
//  InneractiveAdSample
//
//  Created by Nikita Fedorenko on 11/19/14.
//  Copyright (c) 2014 Inneractive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InneractivePositioningPickerView : UIView

@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;
@property (nonatomic, weak) IBOutlet UIButton *updateButton;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;

@end
