//
//  LoginViewController.m
//  Buzzrd
//
//  Created by Brian Mancini on 5/14/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "BuzzrdNav.h"
#import "BuzzrdAPI.h"
#import "LoginViewController.h"
#import "FrameUtils.h"

@interface LoginViewController ()

    @property (strong, nonatomic) UIButton *loginButton;
    @property (strong, nonatomic) UITextField *usernameTextField;
    @property (strong, nonatomic) UITextField *passwordTextField;
    @property (strong, nonatomic) UIButton *createAccountButton;

@end

@implementation LoginViewController

- (void)loadView
{
    [super loadView];
    
    UIImage *buzzrdImage = [UIImage imageNamed:@"buzzrd.png"];
    UIImageView *buzzrdImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    buzzrdImageView.contentMode = UIViewContentModeScaleAspectFill;
    buzzrdImageView.image = buzzrdImage;
    buzzrdImageView.frame = CGRectMake(0.0f, 50.0f, 200, 0);
    [buzzrdImageView setCenter: CGPointMake(self.view.frame.size.width / 2, 80)];
    [self.view addSubview:buzzrdImageView];
    
    self.usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 130, self.view.frame.size.width - 20, 40)];
    self.usernameTextField.placeholder = NSLocalizedString(@"username", nil);
    self.usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	self.usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.usernameTextField.adjustsFontSizeToFitWidth = YES;
    UIView *usernamePaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.usernameTextField.leftView = usernamePaddingView;
    self.usernameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.usernameTextField.returnKeyType = UIReturnKeyNext;
    self.usernameTextField.delegate = self;
    [self.view addSubview:self.usernameTextField];
    [self.usernameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.usernameTextField];
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 171, self.view.frame.size.width - 20, 40)];
    self.passwordTextField.placeholder = NSLocalizedString(@"password", nil);
    self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.passwordTextField.adjustsFontSizeToFitWidth = YES;
    self.passwordTextField.secureTextEntry = YES;
    UIView *passwordPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.passwordTextField.leftView = passwordPaddingView;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
    self.passwordTextField.delegate = self;
    [self.passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.passwordTextField];
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.loginButton.frame = CGRectMake(20, 230, self.view.frame.size.width-40, 35);
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginTouch) forControlEvents:UIControlEventTouchUpInside];
    self.loginButton.enabled = false;
    [self.view addSubview:self.loginButton];
    
    self.createAccountButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.createAccountButton.frame = CGRectMake(20, self.view.frame.size.height-50, self.view.frame.size.width-40, 35);
    [self.createAccountButton setTitle:@"Create Account" forState:UIControlStateNormal];
    [self.createAccountButton addTarget:self action:@selector(createTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.createAccountButton];
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    
    // Validate if username was filled in
    self.usernameTextField.text = [self.usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (self.usernameTextField.text.length == 0)
    {
        self.loginButton.enabled = false;
        return;
    }

    // Validate password was filled in
    if (self.passwordTextField.text.length == 0)
    {
        self.loginButton.enabled = false;
        return;
    }

    self.loginButton.enabled = true;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.usernameTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if(textField == self.passwordTextField) {
        [self.passwordTextField resignFirstResponder];
        [self loginTouch];
    }
    return true;
}


- (void)loginTouch
{
    [[BuzzrdAPI current].userService
     login:self.usernameTextField.text : self.passwordTextField.text
     success:^(User* user)
     {
         UIViewController *homeController = [BuzzrdNav createHomeViewController];
         [self presentViewController:homeController animated:true completion:nil];
     }
     failure:^(NSError *error, id responseObject) {
         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
         UIAlertView* alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(responseObject[@"error"], nil) message: NSLocalizedString(responseObject[@"error_description"], nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         [alert show];
     }];
}

- (void)createTouch
{
    UIViewController *createController = [BuzzrdNav joinBuzzrdViewController];
    [self presentViewController:createController animated:true completion:nil];
}

@end
