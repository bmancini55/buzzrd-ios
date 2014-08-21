//
//  RoomOptionsViewController.m
//  Buzzrd
//
//  Created by Brian Mancini on 3/14/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "RoomOptionsViewController.h"
#import "BuzzrdAPI.h"
#import "FrameUtils.h"
#import "CreateRoomCommand.h"

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
    
    self.title = NSLocalizedString(@"new_room", nil);
    
    self.doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouch)];
    self.doneButton.enabled = false;
    self.navigationItem.rightBarButtonItem = self.doneButton;
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
    Room *room = [[Room alloc]init];
    room.name = self.nameTextField.text;
    room.venueId = self.venue.id;
    
    [self createRoom:room];
}


#pragma Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"room_options"];
    
    switch(indexPath.section)
    {
        case 0:
            switch(indexPath.row)
            {
                case 0:
                {
                    self.nameTextField = [[UITextField alloc]init];
                    self.nameTextField.frame = CGRectMake(15, 5, cell.frame.size.width - 30, cell.frame.size.height - 10);
                    self.nameTextField.placeholder = NSLocalizedString(@"name", nil);
                    self.nameTextField.enablesReturnKeyAutomatically = true;
                    self.nameTextField.returnKeyType = UIReturnKeyDone;
                    self.nameTextField.delegate = self;
                    [self.nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                    [cell addSubview:self.nameTextField];
                    break;
                }
            }
            break;
    }
    return cell;
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
