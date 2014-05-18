//
//  RoomViewController.h
//  Buzzrd
//
//  Created by Brian Mancini on 3/10/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "SocketIO.h"
#import "Room.h"
#import "KeyboardTextView.h"

@interface RoomViewController : BaseTableViewController <SocketIODelegate, KeyboardTextViewDelegate>

@property Room* room;

@end
