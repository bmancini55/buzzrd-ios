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

@interface RoomOptionsViewController ()

@property (strong, nonatomic) UITextField *nameTextField;

@end

@implementation RoomOptionsViewController

-(id)initWithVenue:(Venue *)venue callback:(void (^)(Room *created))onRoomCreated
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
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouch)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

#pragma Button Events

-(void)doneTouch
{
    Room *room = [[Room alloc]init];
    room.name = self.nameTextField.text;
    room.venueId = self.venue.id;
    
    [[BuzzrdAPI current].roomService
    createRoom:room
    success:^(Room* createdRoom)
     {
         NSLog(@"Created room: %@, %@", createdRoom.id, createdRoom.name);
         self.onRoomCreated(createdRoom);
         
         [self dismissViewControllerAnimated:true completion:^{ }];
     }
     failure:^(NSError *error) {
         NSLog(@"%@", error);
     }];
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
                    [cell addSubview:self.nameTextField];
                    break;
                }
            }
            break;
    }
    return cell;
}

#pragma Table view delegate

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"room_options", nil);
}


@end
