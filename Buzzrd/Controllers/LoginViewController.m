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
{
    UIButton *loginButton;
    UITextField *usernameTextField;
    UITextField *passwordTextField;
    UIButton *createAccountButton;
}

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
    
    usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 130, self.view.frame.size.width - 20, 40)];
    usernameTextField.placeholder = NSLocalizedString(@"username", nil);
    usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	usernameTextField.adjustsFontSizeToFitWidth = YES;
    UIView *usernamePaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    usernameTextField.leftView = usernamePaddingView;
    usernameTextField.leftViewMode = UITextFieldViewModeAlways;
    usernameTextField.delegate = self;
    [usernameTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:usernameTextField];
    
    passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 171, self.view.frame.size.width - 20, 40)];
    passwordTextField.placeholder = NSLocalizedString(@"password", nil);
    passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	passwordTextField.adjustsFontSizeToFitWidth = YES;
    passwordTextField.secureTextEntry = YES;
    UIView *passwordPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    passwordTextField.leftView = passwordPaddingView;
    passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    passwordTextField.delegate = self;
    [passwordTextField addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:passwordTextField];
    
    loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton.frame = CGRectMake(20, 230, self.view.frame.size.width-40, 35);
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    createAccountButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    createAccountButton.frame = CGRectMake(20, self.view.frame.size.height-50, self.view.frame.size.width-40, 35);
    [createAccountButton setTitle:@"Create Account" forState:UIControlStateNormal];
    [createAccountButton addTarget:self action:@selector(createTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createAccountButton];
}

//- (void)loginTouch
//{
//    // TODO actual login... on callback do...
//    UIViewController *homeController = [BuzzrdNav createHomeViewController];
//    [self presentViewController:homeController animated:true completion:nil];
//}
//
//- (void)createTouch
//{
//    UIViewController *createController = [BuzzrdNav joinBuzzrdViewController];
//    [self presentViewController:createController animated:true completion:nil];
//}

-(void)textFieldDidChange :(UITextField *)theTextField{
    
    // Validate if username was filled in
//    usernameTextField.text = [usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    
//    if (usernameTextField.text.length == 0)
//    {
//        nextButton.enabled = false;
//        return;
//    }
//    
//    // Validate password was filled in
//    if (passwordTextField.text.length == 0)
//    {
//        nextButton.enabled = false;
//        return;
//    }
//    
//    // Validate that the passwords match
//    if (![passwordTextField.text isEqualToString:password2TextField.text])
//    {
//        nextButton.enabled = false;
//        return;
//    }
//    
//    nextButton.enabled = true;
}

// Workaround to hide keyboard when Done is tapped
- (IBAction)textFieldFinished:(id)sender {
    // [sender resignFirstResponder];
}

- (void)loginTouch
{
    // TODO actual login... on callback do...
    UIViewController *homeController = [BuzzrdNav createHomeViewController];
    [self presentViewController:homeController animated:true completion:nil];
}

- (void)createTouch
{
    UIViewController *createController = [BuzzrdNav joinBuzzrdViewController];
    [self presentViewController:createController animated:true completion:nil];
}

@end
