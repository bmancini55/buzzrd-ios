//
//  BuzzrdAPI.m
//  Buzzrd
//
//  Created by Brian Mancini on 5/13/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "BuzzrdAPI.h"
#import "CommandBase.h"

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

+ (CommandDispatcher *) dispatch
{
    return [BuzzrdAPI current].dispatch;
}

+ (NSString *) apiURLBase
{
    return [[[CommandBase alloc]init] apiURLBase];
}

@synthesize authorization = _authorization;
@synthesize user = _user;
@synthesize profilePic = _profilePic;

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

- (void)clearAuthorization {
    _authorization = nil;
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


- (UIImage *) profilePic {
    
    if(_profilePic == nil)
    {
        //1) Try and read the user from local storage
        //2) If it is there, then instantiate the User
        //3) Else, return nil
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSData * profilePicData = [defaults objectForKey:@"profilePic"];
        
        if(profilePicData != nil)
        {
            _profilePic = [NSKeyedUnarchiver unarchiveObjectWithData: profilePicData];
        }
    }
    
    return _profilePic;
}

- (void)setProfilePic:(UIImage *)newValue {
    _profilePic = newValue;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_user] forKey:@"profilePic"];
    
    [defaults synchronize];
}

-(id) init
{
    self = [super init];
    if(self)
    {
        self.dispatch = [[CommandDispatcher alloc]init];
    }
    return self;
}

@end
