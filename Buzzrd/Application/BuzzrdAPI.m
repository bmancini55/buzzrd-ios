//
//  BuzzrdAPI.m
//  Buzzrd
//
//  Created by Brian Mancini on 5/13/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "BuzzrdAPI.h"
#import "CommandBase.h"
#import "GetUnreadNotificationsCommand.h"
#import "Notification.h"
#import "MMDrawerController.h"

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
    [self setAuthorization:nil];
    [self setProfilePic:nil];
    [self setUser:nil];    
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

- (bool) isAuthenticated {
    return self.authorization.bearerToken != nil;
}

// This method will call out the server and retrieve the
// list of rooms that have pending notifications.
- (void)checkForUnreadNotifications {
    NSLog(@"BuzzrdAPI:checkForUnreadNotifications");
    
    if(self.isAuthenticated) {
        GetUnreadNotificationsCommand *command = [[GetUnreadNotificationsCommand alloc] init];
        [command listenForCompletion:self selector:@selector(checkForUnreadNotificationsComplete:)];
        [[BuzzrdAPI dispatch] enqueueCommand:command];
    }
}

// This will then trigger a RoomUnread Notification
// that will update any lists that have the corresponding room
// to keep the message count and indicators in sync for rooms
// that have notifications.
- (void)checkForUnreadNotificationsComplete:(NSNotification *)notification {
    NSLog(@"BuzzrdAPI:checkForUnreadNotificationsComplete");
    
    GetUnreadNotificationsCommand *command = (GetUnreadNotificationsCommand *)notification.object;
    if(command.status == kSuccess) {
        
        NSArray *notifications = (NSArray *)command.results;
        [notifications enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            Notification *notification = (Notification *)obj;
            switch([notification.typeId integerValue]) {
                case 1:
                    break;
                case 2:
                    [[NSNotificationCenter defaultCenter] postNotificationName:BZAppDidReceiveRoomUnreadNotification object:nil userInfo:
                    @{
                       BZAppDidReceiveRoomUnreadRoomIdKey: [notification.payload valueForKey:@"roomId"]
                    }];
                    break;
            }
        }];
        
        // set badge counts
        [self updateBadgeCountWithArray:notifications];
    }
    
    // handle errors
    else {
        NSLog(@"  -> Failed with error: %@", command.error);
    }
}


- (void)updateBadgeCount:(uint)badgeCount {
    NSLog(@"BuzzrdAPI:updateBadgeCount");
    NSLog(@"  -> Settting to %u", badgeCount);
    
    // set global badge count
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeCount];
    
    // set badge count for tab bar
    UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if([rootController.presentedViewController class] == [MMDrawerController class]) {
        MMDrawerController *drawer = (MMDrawerController *)rootController.presentedViewController;
        UITabBarController *tabController = (UITabBarController *)drawer.centerViewController;
        UITabBarItem *item = [tabController.tabBar.items objectAtIndex:2];
        
        if(badgeCount > 0)
            item.badgeValue = [NSString stringWithFormat:@"%u", badgeCount];
        else
            item.badgeValue = nil;
    }
}

- (void)updateBadgeCountWithArray:(NSArray *)notifications {
    NSLog(@"BuzzrdAPI:updateBadgeCountWithArray");
    
    __block uint totalBadgeCount = 0;
    [notifications enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Notification *notification = (Notification *)obj;
        if(!notification.read) {
            totalBadgeCount += notification.badgeCount;
        }
    }];
    
    [self updateBadgeCount:totalBadgeCount];
}

- (void)decrementBadgeCount:(uint)amount {
    long currentBadgeCount = [[UIApplication sharedApplication] applicationIconBadgeNumber];
    uint newBadgeCount = (uint)MAX(currentBadgeCount - amount, 0);
    [self updateBadgeCount:newBadgeCount];
}


@end
