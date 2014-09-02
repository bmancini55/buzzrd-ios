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

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];

    [ThemeManager setTheme: defaultStyle];
    
    [self initializeCommandDispatchListeners];
    
    // initialize the window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [BuzzrdNav createHomeViewController];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)initializeCommandDispatchListeners {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(networkError:)
                                                name:[CommandBase getNetworkErrorNotificationName]
                                                object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showActivityView)
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

- (void) showActivityView {

    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.loadingOverlay = [[LoadingOverlay alloc]init];
        self.loadingOverlay.title = NSLocalizedString(@"Processing", nil);
        [self.window addSubview:self.loadingOverlay];
        [self.loadingOverlay show];
    });
}

- (void) hideActivityView {
    
    [self.loadingOverlay hide];
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
