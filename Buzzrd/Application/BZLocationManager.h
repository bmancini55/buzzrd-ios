//
//  BZLocationManager.h
//  Buzzrd
//
//  Created by Brian Mancini on 9/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSInteger, BZLocationManagerStatus) {
    BZLocationManagerStatusDisabled,
    BZLocationManagerStatusDenied,
    BZLocationManagerStatusEnabled,
    BZLocationManagerStatusNotDetermined
};

// Define the Notification Center Events
extern NSString * const BZLocationManagerUpdated;
extern NSString * const BZLocationManagerErrored;

// Define the User Info Dictionary Keys
extern NSString * const BZLocationManagerUpdatedLocationInfoKey;
extern NSString * const BZLocationManagerErroredErrorInfoKey;

@interface BZLocationManager : NSObject <CLLocationManagerDelegate>

+ (BZLocationManager *) instance;



- (BZLocationManagerStatus)requestLocation;
- (CLLocation *)requestLastLocation;

@end
