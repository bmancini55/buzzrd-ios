//
//  BaseTableViewController.h
//  Buzzrd
//
//  Created by Brian Mancini on 5/17/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+string.h"
#import "UIView+UIView_Borders.h"
#import "RetryAlert.h"

@interface BaseTableViewController : UITableViewController

@property (strong, nonatomic) RetryAlert *retryAlert;

- (void) showActivityView;

- (void) hideActivityView;

- (void) showRetryAlertWithTitle:(NSString *)title
                         message:(NSString *)message
                  retryOperation:(NSOperation *)operation;

- (void) showDefaultRetryAlert:(NSOperation *)operation;

@end
