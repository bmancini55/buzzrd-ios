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
                                          cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                          otherButtonTitles:@"Retry", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [[BuzzrdAPI dispatch] enqueueCommand:self.operation];
            break;
        default:
            break;
    }
}



@end
