//
//  CreateRoomViewController.m
//  Buzzrd
//
//  Created by Brian Mancini on 3/14/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "CreateRoomViewController.h"
#import "BuzzrdAPI.h"
#import "CreateRoomCommand.h"
#import "TableSectionHeader.h"
#import "ThemeManager.h"
#import "AccessoryIndicatorView.h"
#import "RoomVenueViewController.h"

@interface CreateRoomViewController ()

@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UILabel *venueLabel;
@property (strong, nonatomic) Venue *venue;

@end

@implementation CreateRoomViewController

-(id)initWithCallback:(void (^)(Room *created))onRoomCreated
{
    self = [self initWithStyle:UITableViewStyleGrouped];
    if(self != nil)
    {
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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancelTouch)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDoneTouch)];
    self.navigationItem.rightBarButtonItem.enabled = false;
}

- (bool) validateInput
{
    if(self.nameTextField.text.length < 4) {
        return false;
    }
    return true;
}

- (bool) enableDoneIfValid
{
    bool isValid = [self validateInput];
    if(isValid) {
        self.navigationItem.rightBarButtonItem.enabled = true;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = false;
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
        
        Room *room = command.results;
        [self dismissViewControllerAnimated:true completion:^{
            self.onRoomCreated(room);
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

-(void)onCancelTouch {
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)onDoneTouch
{
    if(![self.nameTextField.text isEqualToString:@""]) {
        
        Room *room = [[Room alloc]init];
        room.name = self.nameTextField.text;
        room.location = [[BuzzrdAPI current] currentLocation];
        if(self.venue) {
            room.venue = self.venue;
        }
    
        [self createRoom:room];
        
    }
}


#pragma Table view data source


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
                    self.nameTextField.returnKeyType = UIReturnKeyNext;
                    self.nameTextField.delegate = self;
                    [self.nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    [cell.contentView addSubview:self.nameTextField];
                    
                    break;
                }
                case 1:
                {
                    cell.textLabel.text = @"Place";
                    cell.accessoryView = [[AccessoryIndicatorView alloc] initWithFrame:CGRectMake(cell.frame.size.width - ACCESSORY_WIDTH - CELL_PADDING, cell.frame.size.height/2 - ACCESSORY_HEIGHT/2, ACCESSORY_WIDTH, ACCESSORY_HEIGHT)];
                    
                    self.venueLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, cell.frame.size.width - 80 - ACCESSORY_WIDTH - CELL_PADDING - 12, 40)];
                    self.venueLabel.font = [ThemeManager getPrimaryFontDemiBold:16.0];
                    self.venueLabel.textColor = [ThemeManager getPrimaryColorMedium];
                    self.venueLabel.backgroundColor = [ThemeManager getPrimaryColorLight];
                    [cell.contentView addSubview:self.venueLabel];
                    break;
                }
            }
            break;
    }
    
    // add the border
    CALayer *border = [CALayer layer];
    border.backgroundColor = [ThemeManager getPrimaryColorMediumLight].CGColor;
    border.frame = CGRectMake(16, 39, cell.frame.size.width - 16, 0.5);
    [cell.layer addSublayer:border];
    
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 1) {
        RoomVenueViewController *viewController = [[RoomVenueViewController alloc]initWithCallback:^(Venue *venue) {
            self.venue = venue;
            self.venueLabel.text = venue.name;
        }];
        [self.navigationController pushViewController:viewController animated:true];
    }
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
            [self onDoneTouch];
        }
    }
    return true;
}




@end
