//
//  NotificationsViewController.h
//  Buzzrd
//
//  Created by Robert Beck on 10/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "BaseTableViewController.h"

@interface NotificationsViewController : BaseTableViewController

@property (strong, nonatomic) NSString *emptyNote;
@property (strong, nonatomic) NSMutableArray *notifications;
@property (strong, nonatomic) NSString *sectionHeaderTitle;

@end
