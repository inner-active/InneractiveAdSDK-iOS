//
//  IAMessageTextField.m
//  IASDKClient
//
//  Created by Inneractive on 09/03/2017.
//  Copyright (c) 2017 Inneractive. All rights reserved.
//

#import "IAMessageTextField.h"

@interface IAMessageTextField ()

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UIButton *sendButton;

@end

@implementation IAMessageTextField {}

#pragma mark - Inits

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 2;
    self.layer.shadowRadius = 0.5;
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 0.5;
}

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
