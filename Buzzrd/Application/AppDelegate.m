//
//  BuzzrdAppDelegate.m
//  Buzzrd
//
//  Created by Brian Mancini on 3/11/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "AppDelegate.h"
#import "BuzzrdNav.h"
#import "ThemeManager.h"
#import "BuzzrdAPI.h"
#import "UIWindow+Helpers.h"
#import "BZLocationManager.h"
#import "RootViewController.h"
#import "UpdateUserDeviceCommand.h"


@implementation AppDelegate {
    dispatch_queue_t _activityLock;
    bool appIsActive;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"AppDelegate:application:didFinishLaunchingWithOptions");
    
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];

    [ThemeManager setTheme: defaultStyle];
    
    [self initializeCommandDispatchListeners];
    
    // initialize the window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    RootViewController *viewController = [[RootViewController alloc] init];
    self.window.rootViewController = viewController;
    
    [self.window makeKeyAndVisible];
    
    // create activityLock
    _activityLock = dispatch_queue_create("io.buzzrd.activitylock", nil);
    
    // registration device for push notification
    [self registerForRemoteNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidAuthenticate:) name:BZUserDidAuthenticateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userWillDeauthenticate:) name:BZUserWillDeauthenticateNotification object:nil];
    
    return YES;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    appIsActive = true;
    
    if([BuzzrdAPI current].isAuthenticated) {
        [[BuzzrdAPI current] checkForUnreadNotifications];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    appIsActive = false;
}


- (void)userDidAuthenticate:(NSNotification *)notification {
    NSLog(@"AppDelegate:userDidAuthenticate");
    [self updateDeviceTokenOnServer:[BuzzrdAPI current].deviceToken];
}

- (void)userWillDeauthenticate:(NSNotification *)notification {
    NSLog(@"AppDelegate:userWillAuthenticate");
    [self updateDeviceTokenOnServer:nil];
}


// Trigger deviceToken registration
- (void)registerForRemoteNotifications {
    NSLog(@"AppDelegate:registerForRemoteNotifications");
    
    // register for notification -> move this after login so that it doesn't trigger request until user is logged in
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    bool currentRemoteRegistration = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    NSLog(@"  -> Current remote registration: %u", currentRemoteRegistration);
}

// Handle the registration of device
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"AppDelegate:didRegisterForRemoteNotificationsWithDeviceToken");
    NSLog(@"  -> DeviceToken %@", deviceToken);
    
    // Store the deviceToken for subsequent calls
    [BuzzrdAPI current].deviceToken = deviceToken;
    
    // Update deviceToken if user is currently authenticated
    if([BuzzrdAPI current].isAuthenticated) {
        [self updateDeviceTokenOnServer:deviceToken];
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"AppDelegate:didFailToRegisterForRemoteNotificationsWithError");
    NSLog(@"  -> Error %@", error);
    [BuzzrdAPI current].deviceToken = nil;
}

// Send the updated device token to the server
// This should be fired either from the initial deviceToken update if the user is already authenticated
//   or after authentication or deathentication as triggered by NSNotification events
- (void)updateDeviceTokenOnServer:(NSData *)deviceToken {
    NSLog(@"AppDelegate:updateDeviceTokenOnServer");
    UpdateUserDeviceCommand *command = [[UpdateUserDeviceCommand alloc]init];
    command.deviceToken = deviceToken;
    [[BuzzrdAPI dispatch] enqueueCommand:command];
}


- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"AppDelegate:didReceiveRemoteNotification");
    
    // Update when user is authenticated
    if([BuzzrdAPI current].isAuthenticated) {
    
        // update the badge count
        NSDictionary *aps = userInfo[@"aps"];
        int badgeCount = (int)[aps[@"badge"] integerValue];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeCount];
        
        // trigger notification
        [[NSNotificationCenter defaultCenter] postNotificationName:BZAppDidReceiveRoomUnreadNotification object:nil userInfo:
        @{
           BZAppDidReceiveRoomUnreadRoomIdKey: userInfo[@"roomId"]
        }];
        
        // trigger navigation to room
        if(!appIsActive) {
            [BuzzrdNav navigateToRoom:userInfo[@"roomId"]];
        }
        
    }
}




- (void)initializeCommandDispatchListeners {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(networkError:)
                                                name:[CommandBase getNetworkErrorNotificationName]
                                                object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showActivityView:)
                                                 name:[CommandBase getShowActivityViewNotificationName]
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideActivityView)
                                                 name:[CommandBase getHideActivityViewNotificationName]
                                               object:nil];
}

- (void) networkError:(NSNotification *)notif {
    
    CommandBase *command = notif.object;
    
    if (command.allowRetry) {
        [self showRetryAlertWithTitle:command.error.localizedDescription
                                    message:command.error.localizedRecoverySuggestion
                             retryOperation:command];
    }
    else {
        [self showRetryAlertWithTitle:command.error.localizedDescription
                              message:command.error.localizedRecoverySuggestion
                       retryOperation:nil];
    }
}

- (void) showActivityView:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    NSString *title = userInfo[@"title"];

    // queue these using GCD locking pattern
    // http://www.raywenderlich.com/4295/multithreading-and-grand-central-dispatch-on-ios-for-beginners-tutorial
    // http://www.fieryrobot.com/blog/2010/09/01/synchronization-using-grand-central-dispatch/
    dispatch_async(_activityLock, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            // create a new one if we have it
            if(!self.loadingOverlay) {
                self.loadingOverlay = [[LoadingOverlay alloc]init];
                self.loadingOverlay.title = title;
                [self.window addSubview:self.loadingOverlay];
                [self.loadingOverlay show];
            }
            // otherwise change the title
            // this will accommodate when commands don't have auto-hide enabled
            // where we chain multiple commands together
            else {
                self.loadingOverlay.title = title;
            }
        });
    });
}

- (void) hideActivityView {
    
    // queue these using GCD locking pattern
    // http://www.raywenderlich.com/4295/multithreading-and-grand-central-dispatch-on-ios-for-beginners-tutorial
    // http://www.fieryrobot.com/blog/2010/09/01/synchronization-using-grand-central-dispatch/
    dispatch_async(_activityLock, ^{
        dispatch_sync(dispatch_get_main_queue(), ^ {
            [self.loadingOverlay hide];
            self.loadingOverlay = nil;
        });
    });
}

- (void) showRetryAlertWithTitle:(NSString *)title
                         message:(NSString *)message
                  retryOperation:(NSOperation *)operation
{
    self.retryAlert = [[RetryAlert alloc]init];
    self.retryAlert.title = title;
    self.retryAlert.message = message;
    self.retryAlert.operation = operation;
    [self.retryAlert show];
}

@end
