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

@interface NewRoomViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) void(^onRoomCreated)(Room *created);

@property (strong, nonatomic) UITableViewCell *nameCell;
@property (strong, nonatomic) UITextField *nameTextField;

@end
