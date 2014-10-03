//
//  BZLocationManager.m
//  Buzzrd
//
//  Created by Brian Mancini on 9/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "BZLocationManager.h"

@interface BZLocationManager()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *lastLocation;

@end

@implementation BZLocationManager

NSString * const BZLocationManagerUpdated = @"BZLocationManagerUpdated";
NSString * const BZLocationManagerErrored = @"BZLocationManagerErrored";
NSString * const BZLocationManagerUpdatedLocationInfoKey = @"BZLocationManagerUpdatedLocationInfoKey";
NSString * const BZLocationManagerErroredErrorInfoKey = @"BZLocationManagerErroredErrorInfoKey";


+(BZLocationManager *) instance
{
    static BZLocationManager *theInstance = nil;
    static dispatch_once_t onceToken;
    
    if([NSThread isMainThread]) {
        dispatch_once(&onceToken, ^{
            theInstance = [[self alloc]init];
        });
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            dispatch_once(&onceToken, ^{
                theInstance = [[self alloc]init];
            });
        });
    }

    return theInstance;
}

- (id)init {
    self = [super init];
    if(self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 100; // distance device must move to register change
        self.locationManager.delegate = self;
    }
    return self;
}


- (BZLocationManagerStatus)requestLocation {
    NSLog(@"%p:LocationManager:requestLocation", self);
    
    // attempt to use cached location
    CLLocation *location = self.lastLocation;
    if(self.lastLocation != nil &&
       [self checkLocationFreshness:location freshness:60] &&
       [self checkLocationAccuracy:location withAccuracy:100]) {
        
        NSLog(@"  -> Returning cached Location (%f, %f)", self.lastLocation.coordinate.longitude, self.lastLocation.coordinate.latitude);
        
        // send updated notification
        NSDictionary *userInfo = @{ BZLocationManagerUpdatedLocationInfoKey: location };
        [[NSNotificationCenter defaultCenter] postNotificationName:BZLocationManagerUpdated object:self userInfo:userInfo];
        return BZLocationManagerStatusEnabled;
        
    }
    // otherwise start the service to get a new update
    else {
        return  [self start];
    }
}

- (CLLocation *)requestLastLocation {
    return self.lastLocation;
}


#pragma Helper methods

- (BZLocationManagerStatus)start {
    NSLog(@"%p:LocationManager:start", self);
    
    
    if([CLLocationManager locationServicesEnabled]) {
        NSLog(@"  -> Location Services are enabled");
        
        // when undetermined
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            NSLog(@"  -> Location Service auth not determined");
            
            // trigger check on iOS8
            if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
            }
            
            // trigger check pre iOS8
            else {
                [self.locationManager startUpdatingLocation];
                [self.locationManager stopUpdatingLocation];
            }
            
            return BZLocationManagerStatusNotDetermined;
        }
        
        // when denied
        else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
           [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
            NSLog(@"  -> Location Services auth denied");
            
            return BZLocationManagerStatusDenied;
        }
        
        // otherwise we're open for business
        else {
            NSLog(@"  -> Location Services auth allowed");
            
            // start updating
            NSLog(@"  -> Starting CLLocationManager");
            [self.locationManager startUpdatingLocation];
            return BZLocationManagerStatusEnabled;
        }
    } else {
        NSLog(@"  -> Location services are disabled");
        
        // show message that app cannot be used because location services is disabled
        return BZLocationManagerStatusDisabled;
    }
}

- (void)stop {
    NSLog(@"%p:LocationManager:stop", self);
    [self.locationManager stopUpdatingLocation];
}



// Verifies the location is within the specified number of seconds
- (bool)checkLocationFreshness:(CLLocation *)location freshness:(NSInteger) freshness {
    
    NSDate *eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    return abs(howRecent) < freshness;
}

// Verifieds the locations accuracy is within the specified number of meters
- (bool)checkLocationAccuracy:(CLLocation *)location withAccuracy:(NSInteger) accuracy {
    return location.horizontalAccuracy < accuracy;
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%p:LocationManager:didFailWithError", self);
    NSLog(@"  -> Triggering Errored notification");
    
    // send error notification
    NSDictionary *userInfo = @{ BZLocationManagerErroredErrorInfoKey: error };
    [[NSNotificationCenter defaultCenter] postNotificationName:BZLocationManagerErrored object:self userInfo:userInfo];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray*)locations {
    NSLog(@"%p:LocationManager:didUpdateLocations", self);

    CLLocation *location = [locations lastObject];
    
    // store the location
    self.lastLocation = location;
    NSLog(@"  -> Location received: (%f, %f)", location.coordinate.longitude, location.coordinate.latitude);
    
    // ensure location is fresh and accuracy
    if([self checkLocationFreshness:location freshness:60] &&
       [self checkLocationAccuracy:location withAccuracy:100]) {
        NSLog(@"  -> Meets freshness and accuracy limits");
        NSLog(@"  -> Stopping CLLocationManager");
        NSLog(@"  -> Triggering Updated notification");
        
        // stop service
        [self stop];
        
        // send updated notification
        NSDictionary *userInfo = @{ BZLocationManagerUpdatedLocationInfoKey: location };
        [[NSNotificationCenter defaultCenter] postNotificationName:BZLocationManagerUpdated object:self userInfo:userInfo];
        
    }
    
    // when doesn't meet requirements
    else {
        NSLog(@"  -> Does not meet freshness or accuracy limits");
    }
}

@end
