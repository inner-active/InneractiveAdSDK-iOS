//
//  InneractiveMessageTextField.h
//  InneractiveAdSample
//
//  Created by Nikita Fedorenko on 22/3/15.
//  Copyright (c) 2015 Inneractive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InneractiveMessageTextFieldDelegate <NSObject>

@required
- (void)sendPressedWithMessage:(NSString *)message;
- (void)textFieldDidBeginEditing;

@end

@interface InneractiveMessageTextField : UIView <UITextFieldDelegate>

@property (nonatomic, weak) id<InneractiveMessageTextFieldDelegate> delegate;

- (BOOL)resignFirstResponder;

@end
