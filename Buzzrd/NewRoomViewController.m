//
//  NewRoomViewController.m
//  Buzzrd
//
//  Created by Brian Mancini on 3/14/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "NewRoomViewController.h"
#import "BuzzrdAPI.h"
#import "FrameUtils.h"

@interface NewRoomViewController ()

@end

@implementation NewRoomViewController



- (void)loadView
{
    [super loadView];
    
    // Create nav bar items
    self.title = @"New Room";
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTouch)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouch)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    // Create the inner table view
    CGRect innerFrame = [FrameUtils getInnerFrame:self.navigationController.navigationBar
                                           tabBar:self.tabBarController.tabBar];
    UITableView *tableView = [[UITableView alloc] initWithFrame:innerFrame
                                                          style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.view = tableView;
    
    
    // create name cell
    self.nameCell = [[UITableViewCell alloc]init];
    
    // create name label in name cell
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"Name";
    nameLabel.Frame = CGRectMake(5, 5, 65, 35);
    [self.nameCell addSubview:nameLabel];
    
    // create name textbox in name cell
    UITextField *nameTextField = [[UITextField alloc]init];
    nameTextField.borderStyle = UITextBorderStyleLine;
    nameTextField.frame = CGRectMake(75, 5, 235, 35);
    self.nameTextField = nameTextField;
    [self.nameCell addSubview:self.nameTextField];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.nameCell;
}


-(void)cancelTouch
{
    [self dismissViewControllerAnimated:true completion:^{ }];
}

-(void)doneTouch
{
    Room *room = [[Room alloc]init];
    room.name = self.nameTextField.text;
    room.lon = [NSNumber numberWithDouble:self.currentLocation.coordinate.longitude];
    room.lat = [NSNumber numberWithDouble:self.currentLocation.coordinate.latitude];
    
    [[BuzzrdAPI current].roomService createRoom:room
     callback:^(Room* createdRoom)
     {
        NSLog(@"Created room: %@", createdRoom.idroom);
        self.onRoomCreated(createdRoom);
     }];
    
    // TODO fire delegate... or something from caller
    [self dismissViewControllerAnimated:true completion:^{ }];
}



@end
