//
//  InneractiveMessageTextField.m
//  InneractiveAdSample
//
//  Created by Nikita Fedorenko on 22/3/15.
//  Copyright (c) 2015 Inneractive. All rights reserved.
//

#import "InneractiveMessageTextField.h"

@interface InneractiveMessageTextField ()

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UIButton *sendButton;

@end

@implementation InneractiveMessageTextField {}

#pragma mark - API

- (BOOL)resignFirstResponder {
    [super resignFirstResponder];
    
    return [self.textField resignFirstResponder];
}

#pragma mark - Service

- (IBAction)sendPressed:(UIButton *)button {
    button.enabled = NO;
    
    if (self.textField.text && self.textField.text.length) {
        [self.delegate sendPressedWithMessage:self.textField.text];
        self.textField.text = @"";
        [self.textField resignFirstResponder];
    }
    
    button.enabled = YES;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.delegate textFieldDidBeginEditing];
}

@end
