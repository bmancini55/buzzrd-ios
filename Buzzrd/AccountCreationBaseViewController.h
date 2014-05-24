//
//  AccountCreationBaseViewController.h
//  Buzzrd
//
//  Created by Robert Beck on 5/22/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "User.h"

@interface AccountCreationBaseViewController : BaseViewController

@property (strong, nonatomic) User *user;

@end
