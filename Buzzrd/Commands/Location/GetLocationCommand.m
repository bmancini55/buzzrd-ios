//
//  GetLocationCommand.m
//  Buzzrd
//
//  Created by Brian Mancini on 6/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "GetLocationCommand.h"

@interface GetLocationCommand()

@property (strong, nonatomic) NSTimer *timeoutTimer;
@property (strong, nonatomic) NSThread *timerThread;

@end

@implementation GetLocationCommand {
    bool executing;
    bool finished;
}

- (id)init
{
    self = [super init];
    if(self) {
        self.completionNotificationName = @"getLocationComplete";
        executing = false;
        finished  = false;
    }
    return self;
}


// iOS8 support for asynchronous NSOperations
- (bool) isAsynchronous {
    return true;
}


// iOS7 support for asynchronous NSOperations
- (bool) isConcurrent {
    return true;
}


// Override for isExecuting, required by async NSOperations
- (bool) isExecuting {
    return executing;
}


// Overrivde for isFinished, required by async NSOperations
- (bool) isFinished {
    return finished;
}


// Required by async NSOperations
// This will perform KVO for isExecuting property and call main
- (void) start {
    NSLog(@"%p:GetLocationCommand:start", self);
    
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = true;
    [self didChangeValueForKey:@"isExecuting"];
}


// Main NSOperation code
- (void) main {
    NSLog(@"%p:GetLocationCommand:main", self);
    
    // start timeout mechanism
    self.timerThread = [NSThread currentThread];
    self.timeoutTimer = [NSTimer timerWithTimeInterval:15.0 target:self selector:@selector(timeout) userInfo:nil repeats:false];
    [[NSRunLoop currentRunLoop] addTimer:self.timeoutTimer forMode:NSDefaultRunLoopMode];
    NSLog(@"  -> Scheduled timer %p", self.timeoutTimer);
    
    // add event handlers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdated:) name:BZLocationManagerUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationErrored:) name:BZLocationManagerErrored object:nil];
    
    // start the location request
    BZLocationManagerStatus status = [[BZLocationManager instance] requestLocation];
    if(status == BZLocationManagerStatusDisabled ||
       status == BZLocationManagerStatusDenied)
    {
        [self shutdownCommand];
        [self sendError:nil status:status];
        return;
    }
    
    // wait for timeout to complete
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
}


// Fires on deallocation
- (void)dealloc {
    NSLog(@"%p:GetLocationCommand:dealloc", self);
}


// Fires when after the elapsed timeout period
- (void)timeout {
    NSLog(@"%p:GetLocationCommand:timeout", self);
    
    CLLocation *lastLocation = [[BZLocationManager instance] requestLastLocation];
    
    if(lastLocation) {
        NSLog(@"  -> Sending last location: (%f, %f)", lastLocation.coordinate.longitude, lastLocation.coordinate.latitude);
        [self sendSuccess:lastLocation];
    } else {
        NSLog(@"  -> Sending error");
        [self  sendError:nil status:BZLocationManagerStatusEnabled];
    }
    
    [self shutdownCommand];
}


// Event handler for BZLocationManager errors
- (void)locationErrored:(NSNotification *)notification {
    NSLog(@"%p:GetLocationCommand:locationErrored", self);
    
    NSError *error = notification.userInfo[BZLocationManagerErroredErrorInfoKey];
    [self sendError:error status:BZLocationManagerStatusEnabled];
    [self shutdownCommand];
}


// Event handler for BZLocationManager updates
- (void)locationUpdated:(NSNotification *)notification {
    NSLog(@"%p:GetLocationCommand:locationUpdated", self);
    
    CLLocation *location = notification.userInfo[BZLocationManagerUpdatedLocationInfoKey];
    [self sendSuccess:location];
    [self shutdownCommand];
}


// Triggers an error for the NSOperation
- (void)sendError:(NSError*)error status:(BZLocationManagerStatus)status {
    self.status = kFailure;
    self.error = error;
    self.results = @{ @"status":[NSNumber numberWithInt:status] };
    [self sendCompletionFailureNotification];
}


// Triggers a succses for the NSOperation
- (void)sendSuccess:(CLLocation *)location {
    self.status = kSuccess;
    self.results = location;
    [self sendCompletionNotification];
}


// Shuts down the NSOperation
- (void)shutdownCommand {
    NSLog(@"%p:GetLocationCommand:shutdownCommand", self);
    
    // Clear out observers
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // Invalidate the timeout
    [self invalidateTimeout];
    
    // Execute KVO for isExecuting and isFinished properties
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    executing = false;
    finished = true;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}


// Invalidates the timer used for timeout handling
- (void)invalidateTimeout {
    NSLog(@"%p:GetLocationCommand:invalidateTimeout", self);
    
    [self performSelector:@selector(doInvalidateTimeout) onThread:self.timerThread withObject:nil waitUntilDone:true];
}


// Called on the timeoutThread to actually invalidate the timer
- (void)doInvalidateTimeout {
    
    // using NSTimer
    NSLog(@"  -> Invalidating timer %p", self.timeoutTimer);
    [self.timeoutTimer invalidate];
    self.timeoutTimer = nil;
}

@end