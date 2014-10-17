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


@implementation AppDelegate {
    dispatch_queue_t _activityLock;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
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
    
    return YES;
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

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
