//
//  RetryAlert.h
//  Buzzrd
//
//  Created by Brian Mancini on 6/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RetryAlert : NSObject <UIAlertViewDelegate>

@property (strong, nonatomic) NSOperation *operation;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *message;

- (void)show;
- (void)showRetryManadatory;

@end
