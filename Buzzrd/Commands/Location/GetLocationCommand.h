//
//  GetLocationCommand.h
//  Buzzrd
//
//  Created by Brian Mancini on 6/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CommandBase.h"

@interface GetLocationCommand : CommandBase <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end
