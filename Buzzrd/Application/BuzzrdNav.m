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
#import "NearbyViewController.h"
#import "RoomVenueViewController.h"
#import "RoomOptionsViewController.h"

#import "Room.h"

@implementation BuzzrdNav

+(UIViewController *) createLoginViewController
{
    LoginViewController *viewController = [[LoginViewController alloc]init];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:viewController];
    return navController;
}

+(UIViewController *) createHomeViewController
{
    NearbyViewController *nearbyViewController = [[NearbyViewController alloc] init];
    UINavigationController *nearbyNavController = [[UINavigationController alloc] initWithRootViewController:nearbyViewController];
    
    //SettingsViewController *SettingsViewController = [[SettingsViewController alloc]init];
    //UINavigationController *userOptionsNavController = [[UINavigationController alloc]initWithRootViewController:SettingsViewController];
    
    //UITabBarController *tabBarController = [[UITabBarController alloc] init];
    //tabBarController.viewControllers = @[nearbyNavController, userOptionsNavController];
    //[[tabBarController.tabBar.items objectAtIndex:0] setTitle:NSLocalizedString(@"nearby", nil)];
    //[[tabBarController.tabBar.items objectAtIndex:1] setTitle:NSLocalizedString(@"options", nil)];
    
    //return tabBarController;
    
    return nearbyNavController;
}

+(UIViewController *) createSettingsController
{
    SettingsViewController *settingsViewController = [[SettingsViewController alloc]init];
    //UINavigationController *userOptionsNavController = [[UINavigationController alloc]initWithRootViewController:SettingsViewController];
    //return userOptionsNavController;
    return settingsViewController;
}

+(UIViewController *) createRoomViewController:(Room *)room
{
    RoomViewController *roomViewController = [[RoomViewController alloc]init];
    roomViewController.room = room;
    roomViewController.hidesBottomBarWhenPushed = true;
    return roomViewController;
}

+(UIViewController *) createNewRoomViewController:(void (^)(Venue *, Room *))roomCreatedCallback
{
    RoomVenueViewController *viewController = [[RoomVenueViewController alloc]initWithStyle:UITableViewStyleGrouped];
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
