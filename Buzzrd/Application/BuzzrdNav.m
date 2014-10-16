//
//  BuzzrdNav.m
//  Buzzrd
//
//  Created by Brian Mancini on 5/14/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "BuzzrdNav.h"
#import "LoginViewController.h"
#import "RoomViewController.h"
#import "SettingsViewController.h"
#import "NearbyRoomsViewController.h"
#import "MyRoomsViewController.h"
#import "RoomVenueViewController.h"
#import "CreateRoomViewController.h"
#import "ThemeManager.h"
#import "Room.h"
#import "FriendsViewController.h"

@implementation BuzzrdNav

+(UIViewController *) createLoginViewController
{
    LoginViewController *viewController = [[LoginViewController alloc]init];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:viewController];
    return navController;
}

+(UIViewController *) createHomeViewController
{
    NearbyRoomsViewController *nearbyRoomsViewController = [[NearbyRoomsViewController alloc]init];
    UINavigationController *nearbyRoomsNavController = [[UINavigationController alloc] initWithRootViewController:nearbyRoomsViewController];

    MyRoomsViewController *myRoomsViewController = [[MyRoomsViewController alloc]init];
    UINavigationController *myRoomsNavController = [[UINavigationController alloc] initWithRootViewController:myRoomsViewController];

    FriendsViewController *friendsViewController = [[FriendsViewController alloc]init];
    UINavigationController *friendsNavController = [[UINavigationController alloc] initWithRootViewController:friendsViewController];
    
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[nearbyRoomsNavController, myRoomsNavController, friendsNavController];
    
    [[tabBarController.tabBar.items objectAtIndex:0] setTitle:[NSLocalizedString(@"nearby_rooms", nil) uppercaseString]];
    
    [[tabBarController.tabBar.items objectAtIndex:1] setTitle:[NSLocalizedString(@"my_rooms", nil) uppercaseString]];
    
    [[tabBarController.tabBar.items objectAtIndex:2] setTitle:[NSLocalizedString(@"Friends", nil) uppercaseString]];
    
    [[UITabBar appearance] setBarTintColor:[ThemeManager getPrimaryColorDark]];
    [[UITabBar appearance] setTintColor:([ThemeManager getSecondaryColorMedium])];
    
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -14)];
     
    NSDictionary *normalTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [ThemeManager getPrimaryFontBold:12.0], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [[UITabBarItem appearance] setTitleTextAttributes:(normalTitleTextAttributes) forState:UIControlStateNormal];
    
    
    NSDictionary *selectedTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [ThemeManager getPrimaryFontBold:12.0], NSFontAttributeName, [ThemeManager getSecondaryColorMedium], NSForegroundColorAttributeName, nil];
    
    [[UITabBarItem appearance] setTitleTextAttributes:(selectedTitleTextAttributes) forState:UIControlStateSelected];
    

    [tabBarController.tabBar addTopBorder:[ThemeManager getSecondaryColorMedium] width:3.0];
    tabBarController.tabBar.clipsToBounds = YES;
    
    return tabBarController;
}

+(UIViewController *) createSettingsController
{
    SettingsViewController *settingsViewController = [[SettingsViewController alloc]init];
    return settingsViewController;
}

+(UIViewController *) createRoomViewController:(Room *)room
{
    RoomViewController *roomViewController = [[RoomViewController alloc]init];
    roomViewController.room = room;
    roomViewController.hidesBottomBarWhenPushed = true;
    return roomViewController;
}

+(UIViewController *) createNewRoomViewController:(void (^)(Room *))roomCreatedCallback
{
    CreateRoomViewController *viewController = [[CreateRoomViewController alloc]initWithStyle:UITableViewStyleGrouped];
    viewController.onRoomCreated = roomCreatedCallback;
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:viewController];
    return navController;
}

+(UIViewController *) joinBuzzrdViewController
{
    JoinBuzzrdViewController *viewController = [[JoinBuzzrdViewController alloc]init];
    return viewController;
}

+(CreateAccountTableViewController *) createAccountTableViewController
{
    CreateAccountTableViewController *viewController = [[CreateAccountTableViewController alloc]init];
    return viewController;
}

+(ProfileImageViewController *) profileImageViewController;
{
    ProfileImageViewController *viewController = [[ProfileImageViewController alloc]init];
    return viewController;
}

+(TermsOfServiceViewController *) termsOfServiceViewController
{
    TermsOfServiceViewController *viewController = [[TermsOfServiceViewController alloc]init];
    return viewController;
}

+(PrivacyPolicyViewController *) privacyPolicyViewController;
{
    PrivacyPolicyViewController *viewController = [[PrivacyPolicyViewController alloc]init];
    return viewController;
}

@end
