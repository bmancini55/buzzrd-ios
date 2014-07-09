//
//  UploadImageCommand.m
//  Buzzrd
//
//  Created by Robert Beck on 7/1/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "UploadImageCommand.h"
#import "AFHTTPRequestOperationManager.h"

@implementation UploadImageCommand

- (id)init
{
    self = [super init];
    if(self) {
        self.completionNotificationName = @"uploadImageComplete";
    }
    return self;
}

- (void)main
{
    AFHTTPSessionManager *manager = [self getJSONRequestManager];

    NSData *imageData = UIImagePNGRepresentation(self.image);
    
    NSString *url = [self getAPIUrl:@"/api/images/upload/"];
    
    [manager
    POST:url
    parameters:nil
    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"photo.png" mimeType:@"image/png"];
    }
    success:^(NSURLSessionDataTask *task, id responseObject) {
         
        NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         
        if(response.statusCode == 200)
        {
            id parsedData = [self parser: responseObject];
             
            // call success callback
            self.status = kSuccess;
            self.results = parsedData;
            [self sendCompletionNotification];
        }
        else
        {
            NSError *error = [[NSError alloc]initWithDomain:@"buzzrd-api" code:1 userInfo:@{ NSLocalizedDescriptionKey: responseObject[@"error"] }];
            self.status = kFailure;
            self.results = error;
            [self sendCompletionFailureNotification];
        }
    }
    failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        self.status = kFailure;
        self.results = responseObject;
        [self sendNetworkErrorNotification];
    }];
}

- (id) parser:(id)rawData
{
    NSDictionary *dic = rawData[@"results"];
    
    return dic[@"imageURI"];
}

- (id) copyWithZone:(NSZone *)zone {
    UploadImageCommand *newOp = [super copyWithZone:zone];
    newOp.image = self.image;
    return newOp;
}

@end
