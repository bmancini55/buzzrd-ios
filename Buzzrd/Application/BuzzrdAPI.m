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
        self.userService = [[UserService alloc] init];
        self.roomService = [[RoomService alloc] init];
        self.locationService = [[LocationService alloc]init];
        self.messageService = [[MessageService alloc]init];
        self.venueService = [[VenueService alloc]init];
        
        // TODO: REMOVE THIS AND PLACE IN LOGIN REQUEST
        // THIS IS ONLY TEMPORARY
        self.authorization = [[Authorization alloc]initWithBearerToken:@"4acec7ac032ae54febf48eec749f4076523625ae"];
    }
    return self;
}

@end
