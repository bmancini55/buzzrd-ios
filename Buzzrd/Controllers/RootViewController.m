//
//  RootViewController.m
//  Buzzrd
//
//  Created by Robert Beck on 10/2/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "RootViewController.h"
#import "BuzzrdNav.h"
#import "BuzzrdAPI.h"
#import "NearbyRoomsViewController.h"
#import "MyRoomsViewController.h"
#import "FriendsViewController.h"
#import "ThemeManager.h"
#import "LoginViewController.h"
#import "NotificationsViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidAppear:(BOOL)animated
{
    // Show the login view controller when not authenticated
    if ([BuzzrdAPI current].authorization.bearerToken == nil) {
        [self presentLoginViewController];
    }
    else {
        [[BuzzrdAPI current] registerForRemoteNotifications];
        [self presentHomeViewController];
    }
}

- (void) presentLoginViewController
{
    LoginViewController *viewController = [[LoginViewController alloc]init];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:viewController];
    
    [self presentViewController:navController animated:false completion:nil];
}


- (void)presentHomeViewController
{
    NearbyRoomsViewController *nearbyRoomsViewController = [[NearbyRoomsViewController alloc]init];
    UINavigationController *nearbyRoomsNavController = [[UINavigationController alloc] initWithRootViewController:nearbyRoomsViewController];
    nearbyRoomsNavController.tabBarItem.image = [[UIImage imageNamed:@"Nearby_W.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nearbyRoomsNavController.tabBarItem.selectedImage = [UIImage imageNamed:@"Nearby_W.png"];
    
    MyRoomsViewController *myRoomsViewController = [[MyRoomsViewController alloc]init];
    UINavigationController *myRoomsNavController = [[UINavigationController alloc] initWithRootViewController:myRoomsViewController];
    myRoomsNavController.tabBarItem.image = [[UIImage imageNamed:@"MyRoom_W.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myRoomsNavController.tabBarItem.selectedImage = [UIImage imageNamed:@"MyRoom_W.png"];
    
    FriendsViewController *friendsViewController = [[FriendsViewController alloc]init];
    UINavigationController *friendsNavController = [[UINavigationController alloc] initWithRootViewController:friendsViewController];
    friendsNavController.tabBarItem.image = [[UIImage imageNamed:@"Friends_W.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    friendsNavController.tabBarItem.selectedImage = [UIImage imageNamed:@"Friends_W.png"];

    
    NotificationsViewController *notificationsViewController = [[NotificationsViewController alloc]init];
    UINavigationController *notificationsNavController = [[UINavigationController alloc] initWithRootViewController:notificationsViewController];
    notificationsNavController.tabBarItem.image = [[UIImage imageNamed:@"Notify_W.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    notificationsNavController.tabBarItem.selectedImage = [UIImage imageNamed:@"Notify_W.png"];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    tabBarController.viewControllers = @[nearbyRoomsNavController, myRoomsNavController, friendsNavController, notificationsNavController];
    
    [[tabBarController.tabBar.items objectAtIndex:0] setTitle:[NSLocalizedString(@"nearby", nil) uppercaseString]];
    
    [[tabBarController.tabBar.items objectAtIndex:1] setTitle:[NSLocalizedString(@"my_rooms", nil) uppercaseString]];
    
    [[tabBarController.tabBar.items objectAtIndex:2] setTitle:[NSLocalizedString(@"Friends", nil) uppercaseString]];
    
    [[tabBarController.tabBar.items objectAtIndex:3] setTitle:[NSLocalizedString(@"Notifications", nil) uppercaseString]];
    
    [[UITabBar appearance] setBarTintColor:[ThemeManager getPrimaryColorDark]];
    [[UITabBar appearance] setTintColor:([ThemeManager getSecondaryColorMedium])];

    
//    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -14)];
    
    [self.tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    
//    [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor whiteColor]];

    
    NSDictionary *normalTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [ThemeManager getPrimaryFontBold:8.5], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [[UITabBarItem appearance] setTitleTextAttributes:(normalTitleTextAttributes) forState:UIControlStateNormal];
    
    
    NSDictionary *selectedTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                 [ThemeManager getPrimaryFontBold:8.5], NSFontAttributeName, [ThemeManager getSecondaryColorMedium], NSForegroundColorAttributeName, nil];
    
    [[UITabBarItem appearance] setTitleTextAttributes:(selectedTitleTextAttributes) forState:UIControlStateSelected];
    
    [tabBarController.tabBar addTopBorder:[ThemeManager getSecondaryColorMedium] width:3.0];
    tabBarController.tabBar.clipsToBounds = YES;
    
    MMDrawerController * drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:tabBarController
                                             rightDrawerViewController:nil];
    
    [drawerController setRestorationIdentifier:@"MMDrawer"];
    [drawerController setMaximumRightDrawerWidth:200.0];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [drawerController setShowsShadow:NO];
    
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningNavigationBar];
    
    [self presentViewController:drawerController animated:false completion:nil];
}

@end
