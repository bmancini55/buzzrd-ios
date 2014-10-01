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

#define ACCESSORY_WIDTH 13.f
#define ACCESSORY_HEIGHT 18.f
#define CELL_PADDING 5.f

@property (strong, nonatomic) RetryAlert *retryAlert;

- (void) showRetryAlertWithTitle:(NSString *)title
                         message:(NSString *)message
                  retryOperation:(NSOperation *)operation;

- (void) showMandatoryRetryAlertWithTitle:(NSString *)title
                                  message:(NSString *)message
                           retryOperation:(NSOperation *)operation;

- (void) showDefaultRetryAlert:(NSOperation *)operation;

@end
