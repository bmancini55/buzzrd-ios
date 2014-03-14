//
//  RoomViewController.h
//  FizBuz
//
//  Created by Brian Mancini on 3/10/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketIO.h"
#import "Room.h"

@interface RoomViewController : UITableViewController <SocketIODelegate, UITextFieldDelegate>

@property Room* room;

@end
