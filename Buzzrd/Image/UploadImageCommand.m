//
//  UploadImageCommand.m
//  Buzzrd
//
//  Created by Robert Beck on 7/1/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "UploadImageCommand.h"

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
    NSURL* url = [NSURL URLWithString:[[self.apiURLBase stringByAppendingPathComponent:@"api/images/upload"] stringByAppendingPathComponent:self.image.accessibilityIdentifier]];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request addValue:@"image/png" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    NSData* bytes = UIImagePNGRepresentation(self.image);
    NSURLSessionUploadTask* task = [session uploadTaskWithRequest:request fromData:bytes completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil && [(NSHTTPURLResponse*)response statusCode] < 300) {
            NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            
            // call success callback
            self.status = kSuccess;
            self.results = responseDict[@"results"][@"imageURI"];
            [self sendCompletionNotification];
        }
        else {
            NSError *error = [[NSError alloc]initWithDomain:@"buzzrd-api" code:1 userInfo:@{ NSLocalizedDescriptionKey: @"Image upload error" }];
            self.status = kFailure;
            self.results = error;
            [self sendCompletionFailureNotification];
        }
    }];
    
    [task resume];
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
