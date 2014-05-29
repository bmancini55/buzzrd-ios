//
//  RequiredInfoTableViewController.m
//  Buzzrd
//
//  Created by Robert Beck on 5/27/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "BuzzrdNav.h"
#import "BuzzrdAPI.h"
#import "RequiredInfoTableViewController.h"

@interface RequiredInfoTableViewController ()
{
    UITextField *usernameTextField;
    UITextField *passwordTextField;
    UITextField *password2TextField;
}

@end

@implementation RequiredInfoTableViewController

-(void) loadView
{
    [super loadView];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"next", nil) style:UIBarButtonItemStylePlain target:self action:@selector(nextTouch)];
    self.navigationItem.rightBarButtonItem = nextButton;
    
    // Remove the extra row separators
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.user = [[User alloc] init];
}

-(void) nextTouch
{
    // Validate if username was filled in
    usernameTextField.text = [usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (usernameTextField.text.length == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"username", nil) message: NSLocalizedString(@"username_required", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    // Validate password was filled in
    if (passwordTextField.text.length == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"password", nil) message: NSLocalizedString(@"password_required", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // Validate that the passwords match
    if (![passwordTextField.text isEqualToString:password2TextField.text])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"password", nil) message: NSLocalizedString(@"passwords_dont_match", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    self.user.username = usernameTextField.text;
    self.user.password = passwordTextField.text;
    
    // Validate the username is unique
    [[BuzzrdAPI current].userService
     usernameExists:self.user.username
     success:^(bool usernameExists)
     {
         OptionalInfoTableViewController *optionalInfoTableViewController = [BuzzrdNav optionalInfoTableViewController];
         optionalInfoTableViewController.user = self.user;
         optionalInfoTableViewController.user.username = usernameTextField.text;
         optionalInfoTableViewController.user.password = passwordTextField.text;
         [self.navigationController pushViewController:optionalInfoTableViewController animated:YES];
     }
     failure:^(NSError *error) {
         UIAlertView* alert = [[UIAlertView alloc] initWithTitle: error.localizedDescription message: error.localizedFailureReason delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         [alert show];
         
     }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    UITextField* tf = nil ;
    
	switch ( indexPath.row ) {
		case 0: {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
			cell.textLabel.text = NSLocalizedString(@"username", nil);
			tf = usernameTextField = [self makeTextField: self.user.username placeholder:nil];
			[cell addSubview:usernameTextField];
			break ;
		}
		case 1: {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = NSLocalizedString(@"password", nil);
			tf = passwordTextField = [self makeTextField: nil placeholder:nil];
            passwordTextField.secureTextEntry = YES;
			[cell addSubview:passwordTextField];
			break ;
		}
		case 2: {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = NSLocalizedString(@"verify", nil);
			tf = password2TextField = [self makeTextField: nil placeholder:nil];
            password2TextField.secureTextEntry = YES;
			[cell addSubview:password2TextField];
			break ;
		}
	}
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Textfield dimensions
	tf.frame = CGRectMake(120, 0, 170, 40);
	
	// Workaround to dismiss keyboard when Done/Return is tapped
	[tf addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
	
	// We want to handle textFieldDidEndEditing
	tf.delegate = self;
    
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

// Workaround to hide keyboard when Done is tapped
- (IBAction)textFieldFinished:(id)sender {
    // [sender resignFirstResponder];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

@end
