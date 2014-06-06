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

@property (strong, nonatomic) UIBarButtonItem *nextButton;
@property (strong, nonatomic) UITextField *usernameTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UITextField *password2TextField;

@property (strong, nonatomic) UIBarButtonItem *saveButton;
@property (strong, nonatomic) UITextField *firstNameTextField;
@property (strong, nonatomic) UITextField *lastNameTextField;
@property (strong, nonatomic) UILabel *genderLabel;

@end

@implementation CreateAccountTableViewController

-(void) loadView
{
    [super loadView];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTouch)];
    self.navigationItem.leftBarButtonItem = cancelItem;
    
    self.nextButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"next", nil) style:UIBarButtonItemStylePlain target:self action:@selector(nextTouch)];
    self.nextButton.enabled = false;
    self.navigationItem.rightBarButtonItem = self.nextButton;
    
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
    self.user.username = self.usernameTextField.text;
    self.user.password = self.passwordTextField.text;
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    // Validate the username is unique
    [[BuzzrdAPI current].userService
     usernameExists:self.user.username
     success:^(bool usernameExists)
     {
         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
         
         OptionalInfoTableViewController *optionalInfoTableViewController = [BuzzrdNav optionalInfoTableViewController];
         optionalInfoTableViewController.user = self.user;
         optionalInfoTableViewController.user.username = self.usernameTextField.text;
         optionalInfoTableViewController.user.password = self.passwordTextField.text;
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
    
    if(indexPath.section == 0) {
        switch (indexPath.row ) {
            case 0: {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.textLabel.text = NSLocalizedString(@"username", nil);
                tf = self.usernameTextField = [self makeTextField: self.user.username placeholder:nil];
                [cell addSubview:self.usernameTextField];
                break ;
            }
            case 1: {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.textLabel.text = NSLocalizedString(@"password", nil);
                tf = self.passwordTextField = [self makeTextField: nil placeholder:nil];
                self.passwordTextField.secureTextEntry = YES;
                [cell addSubview:self.passwordTextField];
                break ;
            }
            case 2: {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.textLabel.text = NSLocalizedString(@"verify", nil);
                tf = self.password2TextField = [self makeTextField: nil placeholder:nil];
                self.password2TextField.secureTextEntry = YES;
                [cell addSubview:self.password2TextField];
                break ;
            }
        }
    }
    
    if(indexPath.section == 1) {
        switch (indexPath.row ) {
            case 0: {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.textLabel.text = NSLocalizedString(@"first_name", nil);
                tf = self.firstNameTextField = [self makeTextField: self.user.firstName placeholder:nil];
                [cell addSubview:self.firstNameTextField];
                break ;
            }
            case 1: {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.textLabel.text = NSLocalizedString(@"last_name", nil);
                tf = self.lastNameTextField = [self makeTextField: self.user.lastName placeholder:nil];
                [cell addSubview:self.lastNameTextField];
                break ;
            }
            case 2: {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GenderCell"];
                cell.textLabel.text = NSLocalizedString(@"gender", nil);
                
                self.genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 170, 40)];
                
                if (self.user.genderId != nil)
                {
                    NSString *genderString = [NSMutableString stringWithFormat:@"gender_%@", self.user.genderId];
                    
                    self.genderLabel.text = NSLocalizedString(genderString, nil);
                }
                
                [cell addSubview:self.genderLabel];
                
                break ;
            }
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.reuseIdentifier isEqual: @"GenderCell"])
    {
        [self displayGenderPicker];
    }
}

- (void) displayGenderPicker
{
    GenderPickerTableViewController *viewController = [[GenderPickerTableViewController alloc]init];
    viewController.selectedGenderId = self.user.genderId;
    viewController.onGenderSelected = ^(NSNumber *genderId) {
        [self setGender:genderId];
    };
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void) setGender:(NSNumber *)genderId
{
    if (genderId != nil)
    {
        NSString *genderString = [NSMutableString stringWithFormat:@"gender_%@", genderId];
        
        self.genderLabel.text = NSLocalizedString(genderString, nil);
        self.user.genderId = genderId;
    }
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
    self.usernameTextField.text = [self.usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (self.usernameTextField.text.length == 0)
    {
        self.nextButton.enabled = false;
        return;
    }
    
    // Validate password was filled in
    if (self.passwordTextField.text.length == 0)
    {
        self.nextButton.enabled = false;
        return;
    }
    
    // Validate that the passwords match
    if (![self.passwordTextField.text isEqualToString:self.password2TextField.text])
    {
        self.nextButton.enabled = false;
        return;
    }
    
    self.nextButton.enabled = true;
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
