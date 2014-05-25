//
//  OptionalInfoViewController.m
//  Buzzrd
//
//  Created by Robert Beck on 5/22/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "BuzzrdNav.h"
#import "BuzzrdAPI.h"
#import "User.h"
#import "OptionalInfoViewController.h"

@interface OptionalInfoViewController ()

@end

@implementation OptionalInfoViewController
{
    NSArray *staticCells;
}
-(void) loadView
{
    [super loadView];
    
//    mainView = [[OptionalInfoView alloc] initWithFrame:CGRectMake(0, 0, 320, 468)];
//    mainView.tableView.dataSource = self;
//    mainView.tableView.delegate = self;
//    self.view = mainView;
    //[self.view addSubview:mainView];
    
    //[mainView.continueButton addTarget:self action:@selector(continueButton_click) forControlEvents:UIControlEventTouchUpInside];
    
    // construct the cells
    [self constructStaticCells];
    
    CGFloat x = 0;
    CGFloat y = 50;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    CGRect tableFrame = CGRectMake(x, y, width, height);
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableFrame
                                                          style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view = tableView;
}


- (void)constructStaticCells
{
    UITableViewCell *firstNameCell = [[UITableViewCell alloc]init];
    firstNameCell.backgroundColor = [UIColor clearColor];
    firstNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGRect firstNameFrame = CGRectMake(15, 0, self.view.frame.size.width-30, 30);
    _firstNameTextField = [[UITextField alloc] initWithFrame:firstNameFrame];
    _firstNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    _firstNameTextField.textColor = [UIColor blackColor];
    _firstNameTextField.font = [UIFont systemFontOfSize:14.0];
    _firstNameTextField.placeholder = NSLocalizedString(@"first_name", nil);
    _firstNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _firstNameTextField.keyboardType = UIKeyboardTypeDefault;
    _firstNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [firstNameCell addSubview:_firstNameTextField];
    
    UITableViewCell *lastNameCell = [[UITableViewCell alloc]init];
    lastNameCell.backgroundColor = [UIColor clearColor];
    lastNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGRect lastNameFrame = CGRectMake(15, 0, self.view.frame.size.width-30, 30);
    _lastNameTextField = [[UITextField alloc] initWithFrame:lastNameFrame];
    _lastNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    _lastNameTextField.textColor = [UIColor blackColor];
    _lastNameTextField.font = [UIFont systemFontOfSize:14.0];
    _lastNameTextField.placeholder = NSLocalizedString(@"last_name", nil);
    _lastNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _lastNameTextField.keyboardType = UIKeyboardTypeDefault;
    _lastNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [lastNameCell addSubview:_lastNameTextField];
    
    UITableViewCell *genderCell = [[UITableViewCell alloc]init];
    genderCell.backgroundColor = [UIColor clearColor];
    genderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGRect genderFrame = CGRectMake(15, 0, self.view.frame.size.width-30, 30);
    _genderTextField = [[UITextField alloc] initWithFrame:genderFrame];
    _genderTextField.borderStyle = UITextBorderStyleRoundedRect;
    _genderTextField.textColor = [UIColor blackColor];
    _genderTextField.font = [UIFont systemFontOfSize:14.0];
    _genderTextField.placeholder = NSLocalizedString(@"gender", nil);
    _genderTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _genderTextField.keyboardType = UIKeyboardTypeDefault;
    _genderTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [genderCell addSubview:_genderTextField];
    
    UITableViewCell *saveCell = [[UITableViewCell alloc]init];
    saveCell.backgroundColor = [UIColor clearColor];
    saveCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _saveButton.backgroundColor = [UIColor orangeColor];
    _saveButton.frame = CGRectMake(80, 0, 160, 40);
    [_saveButton setTitle:NSLocalizedString(@"save", nil) forState:UIControlStateNormal];
    [_saveButton addTarget:self action:@selector(saveButton_click) forControlEvents:UIControlEventTouchUpInside];
    [saveCell addSubview:_saveButton];
    
    // create cell lookup
    staticCells = [[NSArray alloc]initWithObjects:firstNameCell, lastNameCell, genderCell, saveCell, nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [staticCells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)staticCells[indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch(section)
    {
        case 0:
            sectionName = NSLocalizedString(@"optional_info", nil);
            break;
    }
    return sectionName;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    if(section == 0)
    {
        // construct view to size of height
        CGRect viewFrame = CGRectMake(0, 0, tableView.frame.size.width, [self tableView:tableView heightForHeaderInSection:section]);
        view = [[UIView alloc]initWithFrame:viewFrame];
    
        // construct label with custom text
        CGRect labelFrame = CGRectOffset(view.frame, 15, 0);
        UILabel *label = [[UILabel alloc]initWithFrame:labelFrame];
        label.font = [UIFont systemFontOfSize:14];
        label.text = [[self tableView:tableView  titleForHeaderInSection:section] uppercaseString];
        [view addSubview:label];
    }
    return view;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //NSString *asdf = @"asdf";
    
    NSLog(@"here 1");
    
	if (textField == _genderTextField)
	{
        NSLog(@"here 1");
//		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:
//                                      NSLocalizedString(@"Gender", @"")
//                                                                 delegate:self
//                                                        cancelButtonTitle:nil
//                                                   destructiveButtonTitle:nil
//                                                        otherButtonTitles:NSLocalizedString(@"Male",@""),
//                                      NSLocalizedString(@"Female",@""),
//                                      NSLocalizedString(@"NoGender", @""),nil];
//		[actionSheet showInView:self.view];
	}
}

-(void) saveButton_click
{
    // Check that the data is valid before saving
    
    self.user.firstName = _firstNameTextField.text;
    self.user.lastName = _lastNameTextField.text;
    self.user.sex = _genderTextField.text;
    
    [[BuzzrdAPI current].userService
     createUser:self.user
     success:^(User* createdUser)
     {
         NSLog(@"Created user");
     }
     failure:^(NSError *error) {
         NSLog(@"%@", error);
     }];
}

@end
