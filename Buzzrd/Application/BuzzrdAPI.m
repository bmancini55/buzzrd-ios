//
//  BuzzrdAPI.m
//  Buzzrd
//
//  Created by Brian Mancini on 5/13/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "BuzzrdAPI.h"
#import "CommandBase.h"
#import "GetUnreadRoomsCommand.h"
#import "Room.h"

@interface BuzzrdAPI()

@end

@implementation BuzzrdAPI


-(id) init
{
    self = [super init];
    if(self)
    {
        self.dispatch = [[CommandDispatcher alloc]init];
        self.config = [[BuzzrdConfig alloc]init];
    }
    return self;
}


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

- (void)clearLocalStorage {
    _authorization = nil;
    _profilePic = nil;
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
    
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_profilePic] forKey:@"profilePic"];
    
    [defaults synchronize];
}

- (void)registerForRemoteNotifications {
    NSLog(@"BuzzrdAPI:registerForRemoteNotifications");
    
    // register for notification -> move this after login so that it doesn't trigger request until user is logged in
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    bool currentRemoteRegistration = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    NSLog(@"Current remote registration: %u", currentRemoteRegistration);
}

- (bool) isAuthenticated {
    return self.authorization.bearerToken != nil;
}

// This method will call out the server and retrieve the
// list of rooms that have pending notifications.
- (void)checkForUnreadRooms {
    NSLog(@"BuzzrdAPI:checkForUnreadRooms");
    
    GetUnreadRoomsCommand *command = [[GetUnreadRoomsCommand alloc] init];
    [command listenForCompletion:self selector:@selector(checkForUnreadRoomsComplete:)];
    [[BuzzrdAPI dispatch] enqueueCommand:command];
}

// This will then trigger a RoomUnread Notification
// that will update any lists that have the corresponding room
// to keep the message count and indicators in sync for rooms
// that have notifications.
- (void)checkForUnreadRoomsComplete:(NSNotification *)notification {
    NSLog(@"BuzzrdAPI:checkForUnreadRoomsComplete");
    
    GetUnreadRoomsCommand *command = (GetUnreadRoomsCommand *)notification.object;
    if(command.status == kSuccess) {
        
        NSArray *rooms = (NSArray *)command.results;
        [rooms enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            Room *room = (Room *)obj;
            [[NSNotificationCenter defaultCenter] postNotificationName:BZAppDidReceiveRoomUnreadNotification object:nil userInfo:
            @{
                BZAppDidReceiveRoomUnreadRoomIdKey: room.id,
                BZAppDidReceiveRoomUnreadMessageCountKey: [NSNumber numberWithLongLong:room.messageCount]
            }];
        }];
    }
    
    // handle errors
    else {
        NSLog(@"  -> Failed with error: %@", command.error);
    }
}



@end
