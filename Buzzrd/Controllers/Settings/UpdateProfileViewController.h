//
//  UpdateProfileViewController.h
//  Buzzrd
//
//  Created by Robert Beck on 8/24/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "BaseTableViewController.h"
#import "User.h"

@interface UpdateProfileViewController : BaseTableViewController <UITextFieldDelegate>

@property (strong, nonatomic) User *user;

- (id)init;

@property (strong, nonatomic) UITapGestureRecognizer *keyboardDismissGestureRecognizer;

@end
