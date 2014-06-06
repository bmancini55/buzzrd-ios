//
//  OptionalInfoViewController.m
//  Buzzrd
//
//  Created by Robert Beck on 5/22/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "BuzzrdNav.h"
#import "BuzzrdAPI.h"
#import "OptionalInfoTableViewController.h"

@interface OptionalInfoTableViewController ()
{
    UIBarButtonItem *saveButton;
    UITextField *firstNameTextField;
    UITextField *lastNameTextField;
    UILabel *genderLabel;
    
}

@end

@implementation OptionalInfoTableViewController

-(void) loadView
{
    [super loadView];
    
    saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"save", nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveTouch)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    // Remove the extra row separators
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - UITableViewDelegate

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
        
        genderLabel.text = NSLocalizedString(genderString, nil);
        self.user.genderId = genderId;
    }
}

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

-(void) saveTouch
{
    self.user.firstName = [firstNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.user.lastName = [lastNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (self.user.genderId == nil) {
        self.user.genderId = @2;
    }
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
//    ProfileImageViewController *profileImageController = [BuzzrdNav profileImageViewController];
//    profileImageController.user = self.user;
//    [self.navigationController pushViewController:profileImageController animated:YES];

    [[BuzzrdAPI current].userService
     createUser:self.user
     success:^(User* createdUser)
     {
         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
         ProfileImageViewController *profileImageController = [BuzzrdNav profileImageViewController];
         profileImageController.user = createdUser;
         [self.navigationController pushViewController:profileImageController animated:YES];
     }
     failure:^(NSError *error) {
         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
         UIAlertView* alert = [[UIAlertView alloc] initWithTitle: error.localizedDescription message: error.localizedFailureReason delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         [alert show];
     }];
}

@end
