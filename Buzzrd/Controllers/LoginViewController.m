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
#import "LoginCommand.h"
#import "GetCurrentUserCommand.h"
#import "ThemeManager.h"
#import "DownloadImageCommand.h"

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
    
    UIImage *buzzrdImage = [UIImage imageNamed:@"Buzzrd_Logo_with_Text.png"];
    
    UIImageView *buzzrdImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    buzzrdImageView.contentMode = UIViewContentModeScaleAspectFit;
    buzzrdImageView.translatesAutoresizingMaskIntoConstraints = NO;
    buzzrdImageView.image = buzzrdImage;
    [self.view addSubview:buzzrdImageView];

    
    
    UIView *credentialsContainer = [[UIView alloc] init];
    
    credentialsContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:credentialsContainer];
    
    UIImage *loginAreaImage = [[UIImage imageNamed:@"Login_Area.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(40, 40, 40, 40)];
    
    UIImageView *loginAreaImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    loginAreaImageView.contentMode = UIViewContentModeScaleToFill;
    loginAreaImageView.translatesAutoresizingMaskIntoConstraints = NO;
    loginAreaImageView.image = loginAreaImage;
    [credentialsContainer addSubview:loginAreaImageView];
    
    self.usernameTextField = [[UITextField alloc] init];
    self.usernameTextField.attributedPlaceholder = [[NSAttributedString alloc]
                                                    initWithString: NSLocalizedString(@"username", nil)];
    
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
    self.usernameTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [credentialsContainer addSubview:self.usernameTextField];

    
    self.passwordTextField = [[UITextField alloc] init];
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
    self.passwordTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [credentialsContainer addSubview:self.passwordTextField];

    
    self.createAccountButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.createAccountButton setTitle:NSLocalizedString(@"CREATE ACCOUNT", nil) forState:UIControlStateNormal];
    [self.createAccountButton addTarget:self action:@selector(createTouch) forControlEvents:UIControlEventTouchUpInside];
    self.createAccountButton.layer.cornerRadius = 5; // this value vary as per your desire
    self.createAccountButton.clipsToBounds = YES;
    self.createAccountButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.createAccountButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:15.0];
    [self.createAccountButton setBackgroundColor: [ThemeManager getPrimaryColorMedium]];
    [self.createAccountButton setTitleColor:[ThemeManager getPrimaryColorDark] forState:UIControlStateNormal];
    [self.createAccountButton setTitleColor:[ThemeManager getPrimaryColorDark] forState:UIControlStateSelected];
    
    [self.view addSubview:self.createAccountButton];
    
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.loginButton setTitle: NSLocalizedString(@"LOGIN", nil) forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginTouch) forControlEvents:UIControlEventTouchUpInside];
    self.loginButton.enabled = false;
    self.loginButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.loginButton.backgroundColor = [ThemeManager getSecondaryColorMedium];
    self.loginButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0];
    [self.loginButton setTitleColor:[ThemeManager getPrimaryColorDark] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[ThemeManager getPrimaryColorDark] forState:UIControlStateSelected];
    [credentialsContainer addSubview:self.loginButton];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[buzzrdImageView]-40-|" options:0 metrics:nil views:@{ @"buzzrdImageView" : buzzrdImageView }]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[credentialsContainer]-20-|" options:0 metrics:nil views:@{ @"credentialsContainer" : credentialsContainer }]];

    [credentialsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[loginAreaImageView]-0-|" options:0 metrics:nil views:@{ @"loginAreaImageView" : loginAreaImageView }]];
    
    [credentialsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[usernameTextField]-15-|" options:0 metrics:nil views:@{ @"usernameTextField" : self.usernameTextField }]];
    
    [credentialsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[passwordTextField]-15-|" options:0 metrics:nil views:@{ @"passwordTextField" : self.passwordTextField }]];
    
    [credentialsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-6-[loginButton]-6-|" options:0 metrics:nil views:@{ @"loginButton" : self.loginButton }]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[createAccountButton]-20-|" options:0 metrics:nil views:@{ @"createAccountButton" : self.createAccountButton }]];
    
    
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[createAccountButton]-20-|" options:0 metrics:nil views:@{ @"createAccountButton" : self.createAccountButton }]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[buzzrdImageView]" options:0 metrics:nil views:@{ @"buzzrdImageView" : buzzrdImageView, @"credentialsContainer": credentialsContainer, @"createAccountButton" : self.createAccountButton }]];

    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[credentialsContainer]-30-[createAccountButton]" options:0 metrics:nil views:@{ @"buzzrdImageView" : buzzrdImageView, @"credentialsContainer": credentialsContainer, @"createAccountButton" : self.createAccountButton }]];
    

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[buzzrdImageView]-20-[credentialsContainer]" options:0 metrics:nil views:@{ @"buzzrdImageView" : buzzrdImageView, @"credentialsContainer": credentialsContainer, @"createAccountButton" : self.createAccountButton }]];
    
    
    
    [credentialsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[loginAreaImageView]-0-|" options:0 metrics:nil views:@{ @"loginAreaImageView" : loginAreaImageView }]];
    
    [credentialsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[usernameTextField]-1-[passwordTextField]-20-[loginButton]" options:0 metrics:nil views:@{ @"usernameTextField" : self.usernameTextField, @"passwordTextField" : self.passwordTextField, @"loginButton" : self.loginButton }]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[createAccountButton(==40)]" options:0 metrics:nil views:@{ @"createAccountButton" : self.createAccountButton }]];
    
    [credentialsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[usernameTextField(==40)]" options:0 metrics:nil views:@{ @"usernameTextField" : self.usernameTextField }]];

    [credentialsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[passwordTextField(==40)]" options:0 metrics:nil views:@{ @"passwordTextField" : self.passwordTextField }]];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
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
    LoginCommand *command = [[LoginCommand alloc]init];
    command.username = self.usernameTextField.text;
    command.password = self.passwordTextField.text;
    
    [command listenForCompletion:self selector:@selector(loginDidComplete:)];
    
    [[BuzzrdAPI dispatch] enqueueCommand:command];
}

- (void)loginDidComplete:(NSNotification *)notif
{
    LoginCommand *command = notif.object;
    if(command.status == kSuccess)
    {
        [BuzzrdAPI current].authorization = (Authorization *)command.results;
                
        GetCurrentUserCommand *command = [[GetCurrentUserCommand alloc]init];
        [command listenForCompletion:self selector:@selector(getUserDidComplete:)];
        [[BuzzrdAPI dispatch] enqueueCommand:command];
    }
    else
    {
        [self showDefaultRetryAlert:command];
    }
}

- (void)getUserDidComplete:(NSNotification *)notif
{
    GetCurrentUserCommand *command = notif.object;
    if(command.status == kSuccess)
    {
        [BuzzrdAPI current].user = (User *)command.results;
        
        if ([BuzzrdAPI current].user.profilePic != nil){
            if ([BuzzrdAPI current].profilePic == nil) {
                DownloadImageCommand *command = [[DownloadImageCommand alloc]init];
                command.url = [BuzzrdAPI current].user.profilePic;
                
                [command listenForCompletion:self selector:@selector(downloadImageDidComplete:)];
                
                [[BuzzrdAPI dispatch] enqueueCommand:command];
            }
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self showDefaultRetryAlert:command];
    }
}

- (void)downloadImageDidComplete:(NSNotification *)notif
{
    DownloadImageCommand *command = notif.object;
    if(command.status == kSuccess)
    {
        [BuzzrdAPI current].profilePic = command.results;
    }
    else
    {
        [self showRetryAlertWithTitle:NSLocalizedString(@"Unexpected Error", nil)
                              message:NSLocalizedString(@"An unexpected error occurred while processing your request", nil)
                       retryOperation:command];
    }
}

- (void)createTouch
{
    UIViewController *joinBuzzrdController = [BuzzrdNav joinBuzzrdViewController];
    [self.navigationController pushViewController:joinBuzzrdController animated:YES];

//    UIViewController *parentViewController = self.parentViewController;
//    
//    [self dismissViewControllerAnimated:YES completion:^{ [parentViewController.navigationController pushViewController:joinBuzzrdController animated:YES]; }];
    
//    [self presentViewController:joinBuzzrdController animated:true completion:nil];
    
//    UIViewController *viewController = [BuzzrdNav createRoomViewController:room];
//    [self.navigationController pushViewController:viewController animated:YES];
    

//    CreateAccountTableViewController *createAccountTableViewController = [BuzzrdNav createAccountTableViewController];
//    [self.navigationController pushViewController:createAccountTableViewController animated:YES];
}

@end
