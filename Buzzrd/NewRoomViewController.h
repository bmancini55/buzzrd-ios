//
//  NewRoomViewController.h
//  Buzzrd
//
//  Created by Brian Mancini on 3/14/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Room.h"

@interface NewRoomViewController : UITableViewController

@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) Room *room;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end
