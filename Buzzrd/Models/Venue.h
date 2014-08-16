//
//  Venue.h
//  Buzzrd
//
//  Created by Brian Mancini on 5/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Room.h"
#import "VenueLocation.h"
#import "VenueCategory.h"

@interface Venue : NSObject

@property (strong, nonatomic) NSArray* categories;
@property (strong, nonatomic) NSDate *created;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) VenueLocation *location;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *referralId;
@property (nonatomic) NSUInteger roomCount;
@property (nonatomic) NSUInteger userCount;
@property (nonatomic) NSUInteger lurkerCount;
@property (strong, nonatomic) NSDate *updated;
@property (nonatomic) bool verified;
@property (nonatomic, strong) NSArray *rooms;
@property (nonatomic, strong) Room* defaultRoom;

-(id) initWithJson:(NSDictionary *)json;

@end
