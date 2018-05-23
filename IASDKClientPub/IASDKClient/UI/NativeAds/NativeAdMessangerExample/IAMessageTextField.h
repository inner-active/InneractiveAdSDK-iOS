//
//  IAMessageTextField.h
//  IASDKClient
//
//  Created by Inneractive on 09/03/2017.
//  Copyright (c) 2017 Inneractive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IAMessageTextFieldDelegate <NSObject>

@required
- (void)sendPressedWithMessage:(NSString *)message;
- (void)textFieldDidBeginEditing;

@end

@interface IAMessageTextField : UIView <UITextFieldDelegate>

@property (nonatomic, weak) id<IAMessageTextFieldDelegate> delegate;

- (BOOL)resignFirstResponder;

@end
