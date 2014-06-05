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

+(LocationService *) sharedInstance;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

- (void)startUpdatingLocation;

@end
