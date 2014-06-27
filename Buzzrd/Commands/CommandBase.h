//
//  CommandBase.h
//  Buzzrd
//
//  Created by Brian Mancini on 6/26/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFHTTPSessionManager.h"
#import "DateUtils.h"
#import "NSString+string.h"

#define kInProcess  0
#define kFailure   -1
#define kSuccess    1

@interface CommandBase : NSOperation <NSCopying>

@property (strong, nonatomic) NSString *apiURLBase;

@property (strong, nonatomic) id              results;
@property (strong, nonatomic) NSString        *completionNotificationName;
@property (nonatomic)         NSInteger       status;
@property (strong, nonatomic) NSString        *reason;
@property (strong, nonatomic) NSNumber        *requestTimeoutInterval;


// Returns the default error notification name
+ (NSString *)getNetworkErrorNotificationname;

// Registers the listener object as a listener for the completion of the operation.  When the notification is sent the listener's
// selector is called
- (void) listenForMyCompletion:(id)listener selector:(SEL)selector;

// Remove the listener from observing for notifications for this command
- (void) stopListeningForMyCompletion:(id)listener;

// Send the completion notification and response data on behalf of the operation
- (void) sendCompletionNotification;

// Send a notification to listeners that the call failed.
- (void) sendCompletionFailureNotification;

// Send the completion notificaiton with an error status on behalf of the operation
- (void) sendNetworkErrorNotification;


- (NSString *) getAPIUrl:(NSString *)path;

- (AFHTTPSessionManager *) getJSONRequestManager;

- (void) httpGetWithManager:(AFHTTPSessionManager *)manager
                        url:(NSString *)url
                 parameters:(NSDictionary *)parameters
                     parser:(SEL)parser;

@end
