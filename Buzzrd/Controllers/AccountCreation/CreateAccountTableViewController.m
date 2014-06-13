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
#import "FrameUtils.h"
#import "GenderPickerTableViewController.h"

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

-(id)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

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
    [self showActivityView];
    
    if (![self.usernameTextField.text isAlphaNumeric]) {
        [self hideActivityView];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"username", nil) message: NSLocalizedString(@"username_alphanumeric_error", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil];
        [alert show];
    }
    else if (self.passwordTextField.text.length < 6) {
        [self hideActivityView];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"password", nil) message: NSLocalizedString(@"password_length_error", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil];
        [alert show];
    }
    else {
        self.user.username = self.usernameTextField.text;
        self.user.password = self.passwordTextField.text;
        self.user.firstName = [self.firstNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.user.lastName = [self.lastNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

        if (self.user.genderId == nil) {
            self.user.genderId = [NSNumber numberWithInt:0];
        }

        // Create the user
        [[BuzzrdAPI current].userService
         createUser:self.user
         success:^(User* createdUser)
         {
             [self hideActivityView];
             ProfileImageViewController *profileImageController = [BuzzrdNav profileImageViewController];
             profileImageController.user = createdUser;
             [self.navigationController pushViewController:profileImageController animated:YES];
         }
         failure:^(NSError *error) {
             [self hideActivityView];
             UIAlertView* alert = [[UIAlertView alloc] initWithTitle: error.localizedDescription message: error.localizedFailureReason delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil];
             [alert show];
         }];
    }
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
    NSString *cellIdentifier = [NSString stringWithFormat:@"%d%d",indexPath.section,indexPath.row];
    
    UITextField *tf = nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        if(indexPath.section == 0) {
            switch (indexPath.row ) {
                case 0: {
                    cell.textLabel.text = NSLocalizedString(@"username", nil);
                    tf = self.usernameTextField = [self makeTextField: self.user.username placeholder:nil];
                    [cell addSubview:self.usernameTextField];
                    break ;
                }
                case 1: {
                    cell.textLabel.text = NSLocalizedString(@"password", nil);
                    tf = self.passwordTextField = [self makeTextField: nil placeholder:nil];
                    self.passwordTextField.secureTextEntry = YES;
                    [cell addSubview:self.passwordTextField];
                    break ;
                }
                case 2: {
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
                    cell.textLabel.text = NSLocalizedString(@"first_name", nil);
                    tf = self.firstNameTextField = [self makeTextField: self.user.firstName placeholder:nil];
                    [cell addSubview:self.firstNameTextField];
                    break ;
                }
                case 1: {
                    cell.textLabel.text = NSLocalizedString(@"last_name", nil);
                    tf = self.lastNameTextField = [self makeTextField: self.user.lastName placeholder:nil];
                    [cell addSubview:self.lastNameTextField];
                    break ;
                }
                case 2: {
                    cell.textLabel.text = NSLocalizedString(@"gender", nil);
                    
                    self.genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 170, 40)];
                    
                    if (self.user.genderId != nil)
                    {
                        NSString *genderString = [NSMutableString stringWithFormat:@"gender_%@", self.user.genderId];
                        
                        self.genderLabel.text = NSLocalizedString(genderString, nil);
                    }
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                    [cell addSubview:self.genderLabel];
                    
                    break ;
                }
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
    
    // 12 is the reuseIdentifier for the gender cell
    if ([cell.reuseIdentifier isEqual: @"12"])
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
