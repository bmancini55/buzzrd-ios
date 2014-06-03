//
//  ImageService.m
//  Buzzrd
//
//  Created by Robert Beck on 5/31/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "ImageService.h"

@implementation ImageService

-(void)uploadImage:(UIImage *)image
              success:(void (^)(NSString *))success
              failure:(void (^)(NSError *))failure;
{
    NSURL* url = [NSURL URLWithString:[[self.apiURLBase stringByAppendingPathComponent:@"api/images/upload"] stringByAppendingPathComponent:image.accessibilityIdentifier]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request addValue:@"image/png" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    NSData* bytes = UIImagePNGRepresentation(image);
    NSURLSessionUploadTask* task = [session uploadTaskWithRequest:request fromData:bytes completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil && [(NSHTTPURLResponse*)response statusCode] < 300) {
            NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            success(responseDict[@"imageURI"]);
        }
        else {
            
            failure(error);
        }
    }];
    [task resume];
}

@end
