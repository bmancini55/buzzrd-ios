//
//  EnterUsernameView.m
//  Buzzrd
//
//  Created by Robert Beck on 5/21/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "EnterUsernameView.h"

@implementation EnterUsernameView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *getStartedLbl = [ [UILabel alloc] initWithFrame:CGRectMake(0,100,self.frame.size.width,20)];
        [getStartedLbl setText:NSLocalizedString(@"enter_a_username", nil)];
        getStartedLbl.textAlignment = NSTextAlignmentCenter;
        getStartedLbl.font = [UIFont boldSystemFontOfSize:17.0];
        [self addSubview:getStartedLbl];
        
        CGRect frame = CGRectMake(20, 135, self.frame.size.width-40, 30);
        _usernameTextField = [[UITextField alloc] initWithFrame:frame];
        _usernameTextField.borderStyle = UITextBorderStyleRoundedRect;
        _usernameTextField.textColor = [UIColor blackColor];
        _usernameTextField.font = [UIFont systemFontOfSize:14.0];
        _usernameTextField.placeholder = NSLocalizedString(@"username", nil);
        _usernameTextField.backgroundColor = [UIColor clearColor];
        _usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _usernameTextField.keyboardType = UIKeyboardTypeDefault;
        _usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:_usernameTextField];
        
        _continueButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _continueButton.backgroundColor = [UIColor orangeColor];
        _continueButton.frame = CGRectMake(80, 185, 160, 40);
        [_continueButton setTitle:NSLocalizedString(@"continue", nil) forState:UIControlStateNormal];
        [self addSubview:_continueButton];
    }
    return self;
}

@end
