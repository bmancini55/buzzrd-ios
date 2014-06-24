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

@synthesize authorization = _authorization;
@synthesize user = _user;

- (Authorization *) authorization {
    
    if(_authorization == nil)
    {
        //1) Try and read the access_token from local storage
        //2) If it is there, then instantiate the authorization
        //3) Else, return nil

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *bearerToken = [defaults objectForKey:@"bearerToken"];
                 
        if (bearerToken != nil)
        {
            _authorization = [[Authorization alloc]initWithBearerToken: bearerToken];
        }
    }
    
    return _authorization;
}

- (void)setAuthorization:(Authorization *)newValue {
    _authorization = newValue;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:_authorization.bearerToken forKey:@"bearerToken"];
    
    [defaults synchronize];
}

- (User *) user {
    
    if(_user == nil)
    {
        //1) Try and read the user from local storage
        //2) If it is there, then instantiate the User
        //3) Else, return nil
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSData * userData = [defaults objectForKey:@"user"];
        
        if(userData != nil)
        {
            _user = [NSKeyedUnarchiver unarchiveObjectWithData: userData];
        }
    }
    
    return _user;
}

- (void)setUser:(User *)newValue {
    _user = newValue;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_user] forKey:@"user"];
        
    [defaults synchronize];
}

-(id) init
{
    self = [super init];
    if(self)
    {
        self.userService = [[UserService alloc] init];
        self.roomService = [[RoomService alloc] init];
        self.messageService = [[MessageService alloc]init];
        self.venueService = [[VenueService alloc]init];
        self.imageService = [[ImageService alloc]init];
    }
    return self;
}

@end
