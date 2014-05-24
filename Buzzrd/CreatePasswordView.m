//
//  CreatePasswordView.m
//  Buzzrd
//
//  Created by Robert Beck on 5/22/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "CreatePasswordView.h"

@implementation CreatePasswordView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *createPasswordLbl = [ [UILabel alloc] initWithFrame:CGRectMake(0,100,self.frame.size.width,20)];
        [createPasswordLbl setText:NSLocalizedString(@"create_a_password", nil)];
        createPasswordLbl.textAlignment = NSTextAlignmentCenter;
        createPasswordLbl.font = [UIFont boldSystemFontOfSize:17.0];
        [self addSubview:createPasswordLbl];
        
        CGRect frame = CGRectMake(20, 135, self.frame.size.width-40, 30);
        _passwordTextField = [[UITextField alloc] initWithFrame:frame];
        _passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
        _passwordTextField.textColor = [UIColor blackColor];
        _passwordTextField.font = [UIFont systemFontOfSize:14.0];
        _passwordTextField.placeholder = NSLocalizedString(@"password", nil);
        _passwordTextField.backgroundColor = [UIColor clearColor];
        _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _passwordTextField.keyboardType = UIKeyboardTypeDefault;
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.secureTextEntry = YES;
        [self addSubview:_passwordTextField];
        
        UILabel *helpLbl = [ [UILabel alloc] initWithFrame:CGRectMake(20,170,self.frame.size.width-40,40)];
        [helpLbl setText:NSLocalizedString(@"create_password_help_text", nil)];
        helpLbl.textAlignment = NSTextAlignmentCenter;
        helpLbl.font = [UIFont systemFontOfSize:12.0];
        helpLbl.numberOfLines = 0;
        [self addSubview:helpLbl];
        
        _continueButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _continueButton.backgroundColor = [UIColor orangeColor];
        _continueButton.frame = CGRectMake(80, 220, 160, 40);
        [_continueButton setTitle:NSLocalizedString(@"continue", nil) forState:UIControlStateNormal];
        [self addSubview:_continueButton];
    }
    return self;
}

@end
