//
//  GetLocationCommand.m
//  Buzzrd
//
//  Created by Brian Mancini on 6/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "GetLocationCommand.h"

@interface GetLocationCommand()

@property (nonatomic) bool shouldKeepRunning;

@end

@implementation GetLocationCommand

- (id)init
{
    self = [super init];
    if(self) {
        self.completionNotificationName = @"getLocationComplete";
        self.shouldKeepRunning = true;
    }
    return self;
}

- (void)main
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10; // meters
    self.locationManager.delegate = self;
    
    [self.locationManager startUpdatingLocation];
    
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    while (self.shouldKeepRunning && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:5]])
    {
        // exit after 15 seconds of trying
        if(self.shouldKeepRunning) {
            NSLog(@"Runloop exiting");
            self.shouldKeepRunning = false;
            self.status = kSuccess;
            self.results = self.locationManager.location;
            [self sendCompletionNotification];
            [self.locationManager stopUpdatingLocation];
        }
    }
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    self.status = kFailure;
    self.results = error;
    [self sendCompletionFailureNotification];
    [self.locationManager stopUpdatingLocation];
    self.shouldKeepRunning = false;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray*)locations
{
    CLLocation *location = [locations lastObject];
    
    // ensure location is calculated with 5 seconds and less than 100 yards
    NSDate *eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if(abs(howRecent) < 5 && location.horizontalAccuracy < 100)
    {
        self.shouldKeepRunning = false;
        self.status = kSuccess;
        self.results = location;
        [self sendCompletionNotification];
        [self.locationManager stopUpdatingLocation];
    }
}


@end
