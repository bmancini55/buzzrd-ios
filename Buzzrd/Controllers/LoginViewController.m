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

    
    //[beenThereBtn setTitleColor:[UIColor colorWithRed:232.0f/255.0f green:220.0f/255.0f blue:214.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    
  
    //[self.view setBackgroundColor: self.primaryGrayColor];
    
//    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    loginButton.backgroundColor = [UIColor orangeColor];
//    loginButton.frame = CGRectMake(80, 200, 160, 40);
//    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
//    [loginButton addTarget:self action:@selector(loginTouch) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:loginButton];
//    
//    UIButton *createButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    createButton.backgroundColor = [UIColor orangeColor];
//    createButton.frame = CGRectMake(80, 280, 160, 40);
//    [createButton setTitle:@"Create" forState:UIControlStateNormal];
//    [createButton addTarget:self action:@selector(createTouch) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:createButton];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
//    UITextField* tf = nil;
//    
//    switch ( indexPath.row ) {
//        case 0: {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//            cell.backgroundColor = [UIColor clearColor];
//            UIImage *buzzrdImage = [UIImage imageNamed:@"buzzrd.png"];
//            UIImageView *buzzrdImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//            buzzrdImageView.contentMode = UIViewContentModeScaleAspectFill;
//            buzzrdImageView.image = buzzrdImage;
//            buzzrdImageView.frame = CGRectMake(0.0f, 50.0f, 200, 0);
//            [buzzrdImageView setCenter: CGPointMake(cell.frame.size.width / 2, 80)];
//            [cell addSubview:buzzrdImageView];
//            break;
//        }
//		case 1: {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//            //cell.backgroundColor = [UIColor redColor];
//			tf = usernameTextField = [self makeTextField: nil placeholder:NSLocalizedString(@"username", nil)];
//			[cell addSubview:usernameTextField];
//            
//            UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, cell.frame.size.width, 1)];
//            
//            separatorLineView.backgroundColor = [UIColor lightGrayColor];
//            [cell addSubview:separatorLineView];
//            
//			break ;
//		}
//		case 2: {
//			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//            //cell.backgroundColor = [UIColor greenColor];
//            tf = passwordTextField = [self makeTextField: nil placeholder: NSLocalizedString(@"password", nil)];
//            passwordTextField.secureTextEntry = YES;
//			[cell addSubview:passwordTextField];
//			break ;
//		}
//		case 3: {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//            cell.backgroundColor = [UIColor clearColor];
//            loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            loginButton.backgroundColor = self.primaryOrangeColor;
//            loginButton.frame = CGRectMake(10, 20, cell.frame.size.width-40, 35);
//            [loginButton setTitle:@"Login" forState:UIControlStateNormal];
//            [loginButton addTarget:self action:@selector(loginTouch) forControlEvents:UIControlEventTouchUpInside];
//            loginButton.titleLabel.textColor = [UIColor darkGrayColor];
//            [cell addSubview:loginButton];
//			break ;
//		}
//        case 4: {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//            cell.backgroundColor = [UIColor clearColor];
//            createAccountButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            createAccountButton.backgroundColor = self.primaryOrangeColor;
//            
//            createAccountButton.frame = CGRectMake(10, 160, cell.frame.size.width-40, 35);
//            [createAccountButton setTitle:@"Create Account" forState:UIControlStateNormal];
//            [createAccountButton addTarget:self action:@selector(createTouch) forControlEvents:UIControlEventTouchUpInside];
//            createAccountButton.titleLabel.textColor = [UIColor darkGrayColor];
//            [cell addSubview:createAccountButton];
//			break ;
//		}
//	}
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    // Textfield dimensions
//	tf.frame = CGRectMake(10, 0, cell.frame.size.width-20, 40);
//	
////    [tf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    
//	// Workaround to dismiss keyboard when Done/Return is tapped
//	[tf addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
//	
//	// We want to handle textFieldDidEndEditing
//	tf.delegate = self;
    
    return cell;
}

-(UITextField*) makeTextField: (NSString*)text
                  placeholder: (NSString*)placeholder  {
	UITextField *tf = [[UITextField alloc] init];
	tf.placeholder = placeholder;
	tf.text = text;
	tf.autocorrectionType = UITextAutocorrectionTypeNo;
	tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
	tf.adjustsFontSizeToFitWidth = YES;
	return tf;
}

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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.row) {
        case 0: return 135;
        case 1: return 40;
        case 2: return 40;
        case 3: return 55;
        case 4: return 195;
        default: return 40;
    }
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
