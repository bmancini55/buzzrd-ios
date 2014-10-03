//
//  GetTermsOfServiceCommand.m
//  Buzzrd
//
//  Created by Robert Beck on 10/1/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "GetTermsOfServiceCommand.h"

@implementation GetTermsOfServiceCommand

- (id)init
{
    self = [super init];
    if(self) {
        self.completionNotificationName = @"getTermsOfServiceComplete";
        
    }
    return self;
}

- (void)main
{
    // create new manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [self setSecurityRules:manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    NSString *url = [self getAPIUrl:@"/api/disclaimers/termsofservice/"];
    
    if (self.showActivityIndicator) { [self sendShowActivityNotification]; }
    
    [manager
     GET:url
     parameters:nil
     success:^(NSURLSessionDataTask *task, id responseObject) {
         
         // call success callback
         self.status = kSuccess;
         self.results = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         if (self.showActivityIndicator) { [self hideShowActivityNotification]; }
        [self sendCompletionNotification];
     }
     failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
         self.status = kFailure;
         self.results = responseObject;
         self.error = [self handleError:error responseObject:responseObject];
         if (self.showActivityIndicator) { [self hideShowActivityNotification]; }
         [self sendNetworkErrorNotification];
     }];
}

@end
