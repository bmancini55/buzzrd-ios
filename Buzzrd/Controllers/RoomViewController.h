//
//  RoomViewController.h
//  Buzzrd
//
//  Created by Brian Mancini on 3/10/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "KeyboardBarView.h"
#import "SocketIO.h"
#import "Room.h"

@interface RoomViewController : BaseTableViewController <KeyboardBarDelegate, SocketIODelegate>

@property Room* room;

@end
