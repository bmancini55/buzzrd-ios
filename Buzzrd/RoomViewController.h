//
//  RoomViewController.h
//  Buzzrd
//
//  Created by Brian Mancini on 3/10/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "RoomMainView.h"
#import "SocketIO.h"
#import "Room.h"

@interface RoomViewController : BaseViewController <KeyboardBarDelegate, UITableViewDelegate, UITableViewDataSource, SocketIODelegate>

@property Room* room;

@end
