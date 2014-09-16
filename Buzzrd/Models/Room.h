//
//  Room.h
//  Buzzrd
//
//  Created by Brian Mancini on 3/9/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Room : NSObject

@property (strong, nonatomic) NSDate *created;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *updated;

@property (nonatomic) bool venueDefault;
@property (strong, nonatomic) NSString *venueId;

@property (nonatomic) NSUInteger userCount;
@property (nonatomic) NSUInteger lurkerCount;

@property (strong, nonatomic) CLLocation *location;

-(id) initWithJson:(NSDictionary *)json;

@end
