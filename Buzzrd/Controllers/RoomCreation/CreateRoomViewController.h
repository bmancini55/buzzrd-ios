//
//  CreateRoomViewController.m
//  Buzzrd
//
//  Created by Brian Mancini on 3/14/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BaseTableViewController.h"
#import "Room.h"
#import "Venue.h"

@interface CreateRoomViewController : BaseTableViewController <UITextFieldDelegate>

-(id)initWithCallback:(void (^)(Room *created))onRoomCreated;

@property (strong, nonatomic) void(^onRoomCreated)(Room *created);

@end
