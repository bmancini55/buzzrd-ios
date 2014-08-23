//
//  RoomOptionsViewController.m
//  Buzzrd
//
//  Created by Brian Mancini on 3/14/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "RoomOptionsViewController.h"
#import "BuzzrdAPI.h"
#import "CreateRoomCommand.h"
#import "TableSectionHeader.h"
#import "ThemeManager.h"

@interface RoomOptionsViewController ()

@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UIBarButtonItem *doneButton;

@end

@implementation RoomOptionsViewController

-(id)initWithVenue:(Venue *)venue callback:(void (^)(Venue *venue, Room *created))onRoomCreated
{
    self = [self initWithStyle:UITableViewStyleGrouped];
    if(self != nil)
    {
        self.venue = venue;
        self.onRoomCreated = onRoomCreated;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.title = NSLocalizedString(@"create_room", nil);
    self.tableView.backgroundColor = [ThemeManager getPrimaryColorLight];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (bool) validateInput
{
    if(self.nameTextField.text.length == 0) {
        return false;
    }
    return true;
}

- (bool) enableDoneIfValid
{
    bool isValid = [self validateInput];
    if(isValid) {
        self.doneButton.enabled = true;
    } else {
        self.doneButton.enabled = false;
    }
    return isValid;
}


- (void)createRoom:(Room *)room
{
    // Create the default room
    CreateRoomCommand *command = [[CreateRoomCommand alloc]init];
    command.room = room;
    [command listenForCompletion:self selector:@selector(createRoomDidComplete:)];
    [[BuzzrdAPI dispatch] enqueueCommand:command];
}

- (void)createRoomDidComplete:(NSNotification *)info
{
    CreateRoomCommand *command = (CreateRoomCommand *)info.object;
    if(command.status == kSuccess) {
        
        Venue *venue = command.results[@"venue"];
        Room *room = command.results[@"room"];
        
        [self dismissViewControllerAnimated:true completion:^{
            self.onRoomCreated(venue, room);
        }];
    }
    else
    {
        [self showRetryAlertWithTitle:NSLocalizedString(@"Unexpected Error", nil)
                              message:NSLocalizedString(@"An unexpected error occurred while processing your request", nil)
                       retryOperation:command];
    }
}



#pragma Button events

-(void)doneTouch
{
    if(![self.nameTextField.text isEqualToString:@""]) {
        
        Room *room = [[Room alloc]init];
        room.name = self.nameTextField.text;
        room.venueId = self.venue.id;
    
        [self createRoom:room];
        
    }
}


#pragma Table view data source


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"room_options"];
    cell.textLabel.font = [ThemeManager getPrimaryFontRegular:16.0];
    cell.textLabel.textColor = [ThemeManager getPrimaryColorDark];
    cell.backgroundColor = [ThemeManager getPrimaryColorLight];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    switch(indexPath.section)
    {
        case 0:
            switch(indexPath.row)
            {
                case 0:
                {
                    cell.textLabel.text = NSLocalizedString(@"name", nil);
                    
                    self.nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, 170, 40)];
                    self.nameTextField.font = [ThemeManager getPrimaryFontDemiBold:16.0];
                    self.nameTextField.textColor = [ThemeManager getPrimaryColorMedium];
                    self.nameTextField.backgroundColor = [ThemeManager getPrimaryColorLight];
                    self.nameTextField.textAlignment = NSTextAlignmentLeft;
                    self.nameTextField.tintColor = [ThemeManager getTertiaryColorDark];
                    self.nameTextField.enablesReturnKeyAutomatically = true;
                    self.nameTextField.returnKeyType = UIReturnKeyDone;
                    self.nameTextField.delegate = self;
                    [self.nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    [cell.contentView addSubview:self.nameTextField];
                    
                    CALayer *border = [CALayer layer];
                    border.backgroundColor = [ThemeManager getPrimaryColorMediumLight].CGColor;
                    border.frame = CGRectMake(16, 39, cell.frame.size.width - 16, 0.5);
                    [cell.layer addSublayer:border];
                    
                    break;
                }
            }
            break;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect viewFrame = CGRectMake(0, 0, tableView.frame.size.width, 30);
    TableSectionHeader *view = [[TableSectionHeader alloc]initWithFrame:viewFrame];
    view.titleText = [NSLocalizedString(@"room_options", nil) uppercaseString];
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGRect viewFrame = CGRectMake(0, 0, tableView.frame.size.width, 80);
    UIView *view = [[UIView alloc]init];
    
    CGRect buttonFrame = CGRectMake(viewFrame.size.width / 2 - 70, 30, 140, 38);
    UIButton *createButton = [[UIButton alloc]initWithFrame:buttonFrame];
    [createButton setTitle:[NSLocalizedString(@"create_room", nil) uppercaseString] forState:UIControlStateNormal];
    [createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    createButton.titleLabel.font = [ThemeManager getPrimaryFontMedium:15.0];
    createButton.backgroundColor = [ThemeManager getTertiaryColorDark];
    createButton.layer.cornerRadius = 6;
    [createButton addTarget:self action:@selector(doneTouch) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:createButton];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
}


#pragma Text field delegate

-(void)textFieldDidChange:(UITextField *)textField
{
    [self enableDoneIfValid];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.nameTextField) {
        
        // attempt to complete
        if([self enableDoneIfValid]) {
            [textField resignFirstResponder];
            [self doneTouch];
        }
    }
    return true;
}

#pragma Table view delegate

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"room_options", nil);
}


@end
