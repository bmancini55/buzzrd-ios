//
//  RetryAlert.m
//  Buzzrd
//
//  Created by Brian Mancini on 6/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "RetryAlert.h"
#import "BuzzrdAPI.h"

@implementation RetryAlert

- (void)show
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.title
                                                    message:self.message
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"retry", nil)
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [[BuzzrdAPI dispatch] enqueueCommand:self.operation];
}



@end
