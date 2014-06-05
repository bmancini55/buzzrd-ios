//
//  RequiredInfoTableViewController.m
//  Buzzrd
//
//  Created by Robert Beck on 5/27/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "BuzzrdNav.h"
#import "BuzzrdAPI.h"
#import "CreateAccountTableViewController.h"

@interface CreateAccountTableViewController ()
{
    UIBarButtonItem *nextButton;
    UITextField *usernameTextField;
    UITextField *passwordTextField;
    UITextField *password2TextField;
}

@end

@implementation CreateAccountTableViewController

-(void) loadView
{
    [super loadView];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTouch)];
    self.navigationItem.leftBarButtonItem = cancelItem;
    
    nextButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"next", nil) style:UIBarButtonItemStylePlain target:self action:@selector(nextTouch)];
    nextButton.enabled = false;
    self.navigationItem.rightBarButtonItem = nextButton;
    
    // Remove the extra row separators
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.user = [[User alloc] init];
}

-(void) cancelTouch
{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void) nextTouch
{
    self.user.username = usernameTextField.text;
    self.user.password = passwordTextField.text;
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    // Validate the username is unique
    [[BuzzrdAPI current].userService
     usernameExists:self.user.username
     success:^(bool usernameExists)
     {
         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
         
         OptionalInfoTableViewController *optionalInfoTableViewController = [BuzzrdNav optionalInfoTableViewController];
         optionalInfoTableViewController.user = self.user;
         optionalInfoTableViewController.user.username = usernameTextField.text;
         optionalInfoTableViewController.user.password = passwordTextField.text;
         [self.navigationController pushViewController:optionalInfoTableViewController animated:YES];
     }
     failure:^(NSError *error) {
         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
         
         UIAlertView* alert = [[UIAlertView alloc] initWithTitle: error.localizedDescription message: error.localizedFailureReason delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         [alert show];
         
     }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
	
    [tf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
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

-(void)textFieldDidChange :(UITextField *)theTextField{

    // Validate if username was filled in
    usernameTextField.text = [usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (usernameTextField.text.length == 0)
    {
        nextButton.enabled = false;
        return;
    }
    
    // Validate password was filled in
    if (passwordTextField.text.length == 0)
    {
        nextButton.enabled = false;
        return;
    }
    
    // Validate that the passwords match
    if (![passwordTextField.text isEqualToString:password2TextField.text])
    {
        nextButton.enabled = false;
        return;
    }
    
    nextButton.enabled = true;
}

// Workaround to hide keyboard when Done is tapped
- (IBAction)textFieldFinished:(id)sender {
    // [sender resignFirstResponder];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"requiredInformation", nil);
            break;
        case 1:
            sectionName = NSLocalizedString(@"optionalInformation", nil);
            break;
        default:
            sectionName = nil;
            break;
    }
    
    return sectionName;
}

@end
