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
#import "CreateUserCommand.h"
#import "ThemeManager.h"
#import "TableSectionHeader.h"
#import "UIWindow+Helpers.h"
#import "AccessoryIndicatorView.h"

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

#define ACCESSORY_WIDTH 13.f
#define ACCESSORY_HEIGHT 18.f
#define CELL_PADDING 5.f

-(id)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

-(void) loadView
{
    [super loadView];
 
    [self.view setBackgroundColor: [ThemeManager getPrimaryColorLight]];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backTouch)];
    self.navigationItem.leftBarButtonItem = backItem;

    
    self.nextButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"next", nil) style:UIBarButtonItemStylePlain target:self action:@selector(nextTouch)];
    self.nextButton.enabled = false;
    self.navigationItem.rightBarButtonItem = self.nextButton;
    
    // Remove the extra row separators
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.user = [[User alloc] init];
}

- (void) hideKeyboard {
    [self.view endEditing:YES];
    [self.view removeGestureRecognizer:self.keyboardDismissGestureRecognizer];
    self.keyboardDismissGestureRecognizer = nil;
}

-(void) backTouch
{
    [self.navigationController popViewControllerAnimated:true];
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if(self.keyboardDismissGestureRecognizer == nil)
    {
        self.keyboardDismissGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
        self.keyboardDismissGestureRecognizer.cancelsTouchesInView = NO;
        
        [self.view addGestureRecognizer:self.keyboardDismissGestureRecognizer];
    }
}

-(void) nextTouch
{
    [self.view endEditing:YES];
    
    if (![self.usernameTextField.text isAlphaNumeric]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"username", nil) message: NSLocalizedString(@"username_alphanumeric_error", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil];
        [alert show];
    }
    else if (self.passwordTextField.text.length < 6) {
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

        CreateUserCommand *command = [[CreateUserCommand alloc]init];
        command.user = self.user;
        
        [command listenForCompletion:self selector:@selector(createUserDidComplete:)];
        
        [[BuzzrdAPI dispatch] enqueueCommand:command];
    }
}

- (void)createUserDidComplete:(NSNotification *)notif
{
    CreateUserCommand *command = notif.object;
    if(command.status == kSuccess)
    {
        ProfileImageViewController *profileImageController = [BuzzrdNav profileImageViewController];
        profileImageController.user = command.results;
        profileImageController.user.password = self.passwordTextField.text;
        [self.navigationController pushViewController:profileImageController animated:YES];
    }
    else
    {
        [self showRetryAlertWithTitle:NSLocalizedString(@"Unexpected Error", nil)
                              message:NSLocalizedString(@"An unexpected error occurred while processing your request", nil)
                       retryOperation:command];
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
    NSString *cellIdentifier = [NSString stringWithFormat:@"%d%d",(int)indexPath.section,(int)indexPath.row];
    
    UITextField *tf = nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [ThemeManager getPrimaryFontRegular:16.0];
        cell.textLabel.textColor = [ThemeManager getPrimaryColorDark];
        cell.contentView.backgroundColor=[ThemeManager getPrimaryColorLight];
        cell.backgroundColor = [ThemeManager getPrimaryColorLight];
        cell.accessoryView.backgroundColor=[UIColor redColor];

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
                        self.genderLabel.font = [ThemeManager getPrimaryFontDemiBold:16.0];
                        self.genderLabel.textColor = [ThemeManager getPrimaryColorMedium];
                    }
                    
                    [cell addSubview:self.genderLabel];
                    cell.accessoryView = [[AccessoryIndicatorView alloc] initWithFrame:CGRectMake(cell.frame.size.width - ACCESSORY_WIDTH - CELL_PADDING, cell.frame.size.height/2 - ACCESSORY_HEIGHT/2, ACCESSORY_WIDTH, ACCESSORY_HEIGHT)];
                    
                    break ;
                }
            }
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Textfield dimensions
    tf.frame = CGRectMake(120, 0, 170, 40);
    tf.font = [ThemeManager getPrimaryFontDemiBold:16.0];
    tf.textColor = [ThemeManager getPrimaryColorMedium];
    [tf setBackgroundColor:[ThemeManager getPrimaryColorLight]];
	
    [tf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
	
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
        self.genderLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0];
        self.genderLabel.textColor = [ThemeManager getPrimaryColorMedium];

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
    tf.returnKeyType = UIReturnKeyNext;
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


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameTextField) {
       [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField) {
        [self.password2TextField becomeFirstResponder];
    }
    else if (textField == self.password2TextField) {
        [self.firstNameTextField becomeFirstResponder];
    }
    else if (textField == self.firstNameTextField) {
        [self.lastNameTextField becomeFirstResponder];
    }
    else if (textField == self.lastNameTextField) {
        [self.lastNameTextField resignFirstResponder];
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:1];
        [self.tableView selectRowAtIndexPath:path animated:true scrollPosition:UITableViewScrollPositionBottom];
        
        [self displayGenderPicker];
    }
    return true;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CGRect frame = CGRectMake(0,
                              0,
                              tableView.frame.size.width,
                              [self tableView:tableView heightForHeaderInSection:section]);
    TableSectionHeader *headerView = [[TableSectionHeader alloc]initWithFrame:frame];
    switch (section)
    {
        case 0:
            headerView.titleText = NSLocalizedString(@"requiredInformation", nil);
            break;
        case 1:
            headerView.titleText = NSLocalizedString(@"optionalInformation", nil);
            break;
        default:
            headerView.titleText = nil;
            break;
    }
    
    return headerView;
}
                            
@end
