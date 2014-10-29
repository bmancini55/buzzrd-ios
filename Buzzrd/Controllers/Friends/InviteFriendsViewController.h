//
//  InviteFriendsViewController.h
//  Buzzrd
//
//  Created by Robert Beck on 10/28/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "BaseTableViewController.h"
#import "Room.h"

@interface InviteFriendsViewController : BaseTableViewController

@property (strong, nonatomic) Room *room;
@property (strong, nonatomic) NSMutableArray *friends;
@property (strong, nonatomic) NSString *sectionHeaderTitle;

@end
