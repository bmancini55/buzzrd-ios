//
//  BuzzrdAPI.m
//  Buzzrd
//
//  Created by Brian Mancini on 5/13/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "BuzzrdAPI.h"

@implementation BuzzrdAPI

+(BuzzrdAPI *) current
{
    static BuzzrdAPI *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

-(id) init
{
    self = [super init];
    if(self)
    {
        self.roomService = [[RoomService alloc] init];
        self.locationService = [[LocationService alloc]init];
    }
    return self;
}

@end
