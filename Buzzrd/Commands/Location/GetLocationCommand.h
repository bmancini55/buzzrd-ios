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
#import "BuzzrdAPI.h"
#import "BZLocationManager.h"

@interface GetLocationCommand : CommandBase <CLLocationManagerDelegate>

@end
