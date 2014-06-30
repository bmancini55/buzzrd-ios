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
    NSLog(@"starting location update");
    
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    while (self.shouldKeepRunning && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Location service failed with error %@", error);
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
    
    NSDate *eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    if(abs(howRecent) < 15.0 && location.horizontalAccuracy < 100)
    {    
        NSLog(@"Latitude %+.6f, Longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
        
        self.status = kSuccess;
        self.results = location;
        [self sendCompletionNotification];
        [self.locationManager stopUpdatingLocation];
        self.shouldKeepRunning = false;
    }
}

@end
