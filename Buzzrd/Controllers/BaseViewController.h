//
//  BaseViewController.h
//  Buzzrd
//
//  Created by Brian Mancini on 5/16/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RetryAlert.h"

@interface BaseViewController : UIViewController

@property (strong, nonatomic) RetryAlert *retryAlert;

- (void) showActivityView;

- (void) hideActivityView;

- (void) showRetryAlertWithTitle:(NSString *)title
                          message:(NSString *)message
                 retryOperation:(NSOperation *)operation;

- (void) showMandatoryRetryAlertWithTitle:(NSString *)title
                                  message:(NSString *)message
                           retryOperation:(NSOperation *)operation;

- (void) showDefaultRetryAlert:(NSOperation *)operation;

@end
