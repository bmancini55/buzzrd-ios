//
//  FriendsViewController.h
//  Buzzrd
//
//  Created by Robert Beck on 10/9/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "BaseTableViewController.h"

@interface FriendsViewController : BaseTableViewController

@property (strong, nonatomic) NSArray *friends;
@property (strong, nonatomic) NSString *sectionHeaderTitle;

@end
