//
//  CommandBase.m
//  Buzzrd
//
//  Created by Brian Mancini on 6/26/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//


#import "BuzzrdAPI.h"
#import "CommandBase.h"
#import "CommandDispatcher.h"



@implementation CommandBase

- (id)init
{
    self = [super init];
    if (self) {
        self.completionNotificationName = @"operationCompletion";
        self.status = kInProcess;
        
        // set the default network timeout
        self.requestTimeoutInterval = [NSNumber numberWithInt:30];
        
        self.removeListenerOnSuccess = true;
        
        self.apiURLBase = @"http://devapi.buzzrd.io:5050";
    }
    
    return self;
}



// The notification name for any network error
+ (NSString *)getNetworkErrorNotificationName {
    return @"networkError";
}


// Add the listener as an observer of the completion of the command
- (void) listenForCompletion:(id)listener selector:(SEL)selector {
    
    // Check to see that the listener does respond to the selector. It is easier to find selector typo's if it is checked here rather than when the notification fires
    if ([listener respondsToSelector:selector]) {
        
        // keep reference to listener for automatic removal
        self.listener = listener;
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        // make sure the listener only gets 1 notification
        [nc removeObserver:listener name:self.completionNotificationName object:nil];
        // Add the object as a listener
        [nc addObserver:listener selector:selector name:self.completionNotificationName object:nil];
    } else {
        NSLog(@"Warning:  not registering completion listener because it does not support the specified selector");
    }
}


// Removes the listener as listening for command completion for this command
- (void) stopListeningForCompletion:(id)listener {
    [[NSNotificationCenter defaultCenter] removeObserver:listener name:self.completionNotificationName object:nil];
}


// Send a completion notification with the command object and the results in the userInfo property of the notification
- (void) sendCompletionNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:self.completionNotificationName object:self userInfo:nil];
    
    // stop listening if we have this 
    if(self.removeListenerOnSuccess)
    {
        [self stopListeningForCompletion:self.listener];
    }
}

// Send a completion notification with a failure status.  The notification includes a copy of the command and the results, if any
- (void) sendCompletionFailureNotification {
    self.status = kFailure;
    CommandBase *copy = [self copy];
    [[NSNotificationCenter defaultCenter] postNotificationName:self.completionNotificationName object:copy userInfo:nil];
    
}

// Send a notification that a network error occured
- (void) sendNetworkErrorNotification {
    CommandBase *copy = [self copy];
    [[NSNotificationCenter defaultCenter] postNotificationName:[CommandBase getNetworkErrorNotificationName] object:copy userInfo:nil];
}


// Stub main for the NSOperation command.
- (void)main {
    NSLog(@"Starting operation");
}




#pragma mark   NSCopying protocol

// Copy the Command object so that it can be resubmitted if necessary
- (id)copyWithZone:(NSZone *)zone {
    CommandBase *newOp = [[[self class] allocWithZone:zone] init];
    newOp.reason = self.reason;
    newOp.results = self.results;
    newOp.status = self.status;
    return newOp;
}


#pragma AFNetworkingRelated

- (NSString *) getAPIUrl:(NSString *)path
{
    return [self.apiURLBase stringByAppendingString:path];
}

- (AFHTTPSessionManager *) getJSONRequestManager
{
    // create new manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // set authorization header
    if([[BuzzrdAPI current] authorization] != nil)
    {
        NSString *authorization = [@"Bearer " stringByAppendingString:[BuzzrdAPI current].authorization.bearerToken];
        [manager.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
    }
    
    return manager;
}


- (void) httpGetWithManager:(AFHTTPSessionManager *)manager
                        url:(NSString *)url
                 parameters:(NSDictionary *)parameters
                     parser:(SEL)parser;
{
    [manager
     GET:url
     parameters:parameters
     success:^(NSURLSessionDataTask *task, id responseObject) {
         
         if([responseObject[@"success"] boolValue])
         {
             // execute parser selector
             IMP imp = [self methodForSelector:parser];
             id (*func)(id, SEL, id) = (void *)imp;
             id parsedData = func(self, parser, responseObject);
         
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

- (void) httpPostWithManager:(AFHTTPSessionManager *)manager
                        url:(NSString *)url
                 parameters:(NSDictionary *)parameters
                     parser:(SEL)parser;
{
    [manager
     POST:url
     parameters:parameters
     success:^(NSURLSessionDataTask *task, id responseObject) {
         
         NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
         
         if(response.statusCode == 200)
         {
             // execute parser selector
             IMP imp = [self methodForSelector:parser];
             id (*func)(id, SEL, id) = (void *)imp;
             id parsedData = func(self, parser, responseObject);
             
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

@end
