//
//  UpdateProfileViewController.m
//  Buzzrd
//
//  Created by Robert Beck on 8/24/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "UpdateProfileViewController.h"
#import "ThemeManager.h"
#import "TableSectionHeader.h"
#import "AccessoryIndicatorView.h"
#import "GenderPickerTableViewController.h"
#import "BuzzrdAPI.h"

@interface UpdateProfileViewController ()

@property (strong, nonatomic) UIBarButtonItem *nextButton;
@property (strong, nonatomic) UITextField *usernameTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UITextField *password2TextField;

@property (strong, nonatomic) UIBarButtonItem *saveButton;
@property (strong, nonatomic) UITextField *firstNameTextField;
@property (strong, nonatomic) UITextField *lastNameTextField;
@property (strong, nonatomic) UILabel *genderLabel;

@end

@implementation UpdateProfileViewController


-(id)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

-(void) loadView
{
    [super loadView];
    
    [self.view setBackgroundColor: [ThemeManager getPrimaryColorLight]];
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backTouch)];
//    self.navigationItem.leftBarButtonItem = backItem;
    
    
//    self.nextButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"next", nil) style:UIBarButtonItemStylePlain target:self action:@selector(nextTouch)];
//    self.nextButton.enabled = false;
//    self.navigationItem.rightBarButtonItem = self.nextButton;
    
    // Remove the extra row separators
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.user = [[User alloc] init];
}

- (void) hideKeyboard {
    [self.view endEditing:YES];
    [self.view removeGestureRecognizer:self.keyboardDismissGestureRecognizer];
    self.keyboardDismissGestureRecognizer = nil;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    else {
        return 2;
    }
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
                    
                    tf = self.usernameTextField = [self makeTextField: [BuzzrdAPI current].user.username placeholder:nil];
                    tf.enabled = false;
                    [cell addSubview:self.usernameTextField];
                    break ;
                }
                case 1: {
                    cell.textLabel.text = NSLocalizedString(@"first_name", nil);
                    tf = self.firstNameTextField = [self makeTextField: [BuzzrdAPI current].user.firstName placeholder:nil];
                    [cell addSubview:self.firstNameTextField];
                    break ;
                }
                case 2: {
                    cell.textLabel.text = NSLocalizedString(@"last_name", nil);
                    tf = self.lastNameTextField = [self makeTextField: [BuzzrdAPI current].user.lastName placeholder:nil];
                    [cell addSubview:self.lastNameTextField];
                    break ;
                }
                case 3: {
                    cell.textLabel.text = NSLocalizedString(@"gender", nil);
                    
                    self.genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 170, 40)];
                    
                    if ([BuzzrdAPI current].user.genderId != nil)
                    {
                        NSString *genderString = [NSMutableString stringWithFormat:@"gender_%@", [BuzzrdAPI current].user.genderId];
                        
                        self.genderLabel.text = NSLocalizedString(genderString, nil);
                        self.genderLabel.font = [ThemeManager getPrimaryFontDemiBold:16.0];
                        self.genderLabel.textColor = [ThemeManager getPrimaryColorMedium];
                    }
                    
                    [cell addSubview:self.genderLabel];
                    cell.accessoryView = [[AccessoryIndicatorView alloc] initWithFrame:CGRectMake(cell.frame.size.width - ACCESSORY_WIDTH - CELL_PADDING, cell.frame.size.height/2 - ACCESSORY_HEIGHT/2, ACCESSORY_WIDTH, ACCESSORY_HEIGHT)];
                    
                    break ;
                }
                case 4: {
                    cell.textLabel.text = NSLocalizedString(@"Adjust Profile Picture", nil);
                    
                    UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
                    profileImageView.contentMode = UIViewContentModeScaleAspectFit;
                    profileImageView.translatesAutoresizingMaskIntoConstraints = NO;
                    profileImageView.image = [UIImage imageNamed:@"no_profile_pic.png"];
                    [cell addSubview: profileImageView];

                    [cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cellLabel]-(-70)-[profileImageView(27)]" options:0 metrics:nil views:@{ @"cellLabel": cell.textLabel, @"profileImageView": profileImageView }]];

                    [cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[profileImageView(27)]" options:0 metrics:nil views:@{ @"profileImageView": profileImageView }]];
                    
                    cell.accessoryView = [[AccessoryIndicatorView alloc] initWithFrame:CGRectMake(cell.frame.size.width - ACCESSORY_WIDTH - CELL_PADDING, cell.frame.size.height/2 - ACCESSORY_HEIGHT/2, ACCESSORY_WIDTH, ACCESSORY_HEIGHT)];
                    
                    break ;
                }
            }
        }
        else if (indexPath.section == 1) {
            switch(indexPath.row)
            {
                case 0: {
                    cell.textLabel.text = NSLocalizedString(@"password", nil);
                    tf = self.passwordTextField = [self makeTextField: nil placeholder:nil];
                    self.passwordTextField.secureTextEntry = YES;
                    [cell addSubview:self.passwordTextField];
                    break ;
                }
                case 1: {
                    cell.textLabel.text = NSLocalizedString(@"verify", nil);
                    tf = self.password2TextField = [self makeTextField: nil placeholder:nil];
                    self.password2TextField.secureTextEntry = YES;
                    [cell addSubview:self.password2TextField];
                    break ;
                }
            }
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (tf != nil) {
        // Textfield dimensions
        tf.frame = CGRectMake(120, 0, 170, 40);
        tf.font = [ThemeManager getPrimaryFontDemiBold:16.0];
        tf.textColor = [ThemeManager getPrimaryColorMedium];
        [tf setBackgroundColor:[ThemeManager getPrimaryColorLight]];
	
        [tf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
	
        // We want to handle textFieldDidEndEditing
        tf.delegate = self;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // 03 is the reuseIdentifier for the gender cell
    if ([cell.reuseIdentifier isEqual: @"03"])
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
            headerView.titleText = NSLocalizedString(@"PROFILE", nil);
            break;
        case 1:
            headerView.titleText = NSLocalizedString(@"PASSWORD", nil);
            break;
        default:
            headerView.titleText = nil;
            break;
    }
    
    return headerView;
}

@end