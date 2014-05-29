//
//  OptionalInfoViewController.h
//  Buzzrd
//
//  Created by Robert Beck on 5/22/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "BaseTableViewController.h"
#import "GenderPickerTableViewController.h"

@interface OptionalInfoTableViewController : BaseTableViewController <UITextFieldDelegate>

@property (strong, nonatomic) User *user;

//@property (strong, nonatomic) UIButton *saveButton;

@end