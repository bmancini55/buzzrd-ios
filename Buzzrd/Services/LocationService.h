//
//  LocationService.h
//  Buzzrd
//
//  Created by Brian Mancini on 3/10/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ServiceBase.h"


@interface LocationService : NSObject <CLLocationManagerDelegate>

+(LocationService *) instance;
+ (CLLocation *) currentLocation;

@property (strong, nonatomic) CLLocationManager *locationManager;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;
- (CLLocation *) currentLocation;

@end
