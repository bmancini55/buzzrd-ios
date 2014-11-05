//
//  DownloadImageCommand.m
//  Buzzrd
//
//  Created by Robert Beck on 9/10/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "DownloadImageCommand.h"
#import "BuzzrdAPI.h"

@implementation DownloadImageCommand

- (id)init
{
    self = [super init];
    if(self) {
        self.imageDownloadBaseUrl = [BuzzrdAPI current].config.s3BucketUrl;
        self.completionNotificationName = @"downloadImageComplete";
    }
    return self;
}

- (void)main
{
    NSString *url = [self.imageDownloadBaseUrl stringByAppendingPathComponent:self.url];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    [manager GET:url
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             
             UIImage *image = (UIImage *)responseObject;
             
             self.status = kSuccess;
             self.results = image;
             [self sendCompletionNotification];
         }
         failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
             NSError *newError = [[NSError alloc]initWithDomain:@"buzzrd-api" code:1 userInfo:@{ NSLocalizedDescriptionKey: @"Image download error" }];
             self.status = kFailure;
             self.results = newError;
            [self sendCompletionFailureNotification];
         }];
}

- (id) copyWithZone:(NSZone *)zone {
    DownloadImageCommand *newOp = [super copyWithZone:zone];
    newOp.url = self.url;
    return newOp;
}

@end
