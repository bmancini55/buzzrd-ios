//
//  NewRoomViewController.m
//  Buzzrd
//
//  Created by Brian Mancini on 3/14/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "NewRoomViewController.h"

@interface NewRoomViewController ()

@end

@implementation NewRoomViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"CreateRoom"])
    {
        self.room = [[Room alloc]init];
        self.room.name = self.nameTextField.text;
        self.room.lon = [NSNumber numberWithDouble:self.currentLocation.coordinate.longitude];
        self.room.lat = [NSNumber numberWithDouble:self.currentLocation.coordinate.latitude];
    }
}



@end
