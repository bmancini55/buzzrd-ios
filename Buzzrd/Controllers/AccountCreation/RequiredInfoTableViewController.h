//
//  RequiredInfoTableViewController.h
//  Buzzrd
//
//  Created by Robert Beck on 5/27/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "BaseTableViewController.h"

@interface RequiredInfoTableViewController : BaseTableViewController <UITextFieldDelegate>

@property (strong, nonatomic) User *user;

@end
