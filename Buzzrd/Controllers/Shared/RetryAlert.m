//
//  RetryAlert.m
//  Buzzrd
//
//  Created by Brian Mancini on 6/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "RetryAlert.h"
#import "BuzzrdAPI.h"

@implementation RetryAlert {
    UIAlertView *alert;
    int retryIndex;
}

- (void)show {
    if (self.operation != nil) {
        retryIndex = 1;
        alert = [[UIAlertView alloc] initWithTitle:self.title
                                          message:self.message
                                          delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                          otherButtonTitles:@"Retry", nil];
    }
    else {
        retryIndex = -1;
        alert = [[UIAlertView alloc] initWithTitle:self.title
                                          message:self.message
                                          delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                          otherButtonTitles:nil, nil];
    }
    
    [alert show];
}

- (void)showRetryManadatory {
    retryIndex = 0;
    alert = [[UIAlertView alloc] initWithTitle:self.title
                                       message:self.message
                                      delegate:self
                             cancelButtonTitle:NSLocalizedString(@"Retry", nil)
                             otherButtonTitles:nil, nil];
    [alert show];
}

- (void)dealloc {
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // fire command if we have a retry
    if(buttonIndex == retryIndex) {
        [[BuzzrdAPI dispatch] enqueueCommand:self.operation];
    }
    
    // remove retain count
    self.operation = nil;
}



@end
