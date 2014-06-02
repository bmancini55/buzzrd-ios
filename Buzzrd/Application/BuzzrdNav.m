//
//  BuzzrdNav.m
//  Buzzrd
//
//  Created by Brian Mancini on 5/14/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "BuzzrdNav.h"
#import "LoginViewController.h"
#import "RoomsViewController.h"
#import "RoomViewController.h"
#import "NewRoomViewController.h"
#import "UserOptionsViewController.h"
#import "VenuesViewController.h"

#import "Room.h"

@implementation BuzzrdNav

+(UIViewController *) createLoginViewController
{
    LoginViewController *loginViewController = [[LoginViewController alloc]init];
    return loginViewController;
}

+(UIViewController *) createHomeViewController
{
    VenuesViewController *venuesViewController = [[VenuesViewController alloc] init];
    UINavigationController *venuesNavController = [[UINavigationController alloc] initWithRootViewController:venuesViewController];
    
    RoomsViewController *roomsViewController = [[RoomsViewController alloc] init];
    UINavigationController *roomsNavController = [[UINavigationController alloc] initWithRootViewController:roomsViewController];
    
    UserOptionsViewController *userOptionsViewController = [[UserOptionsViewController alloc]init];
    UINavigationController *userOptionsNavController = [[UINavigationController alloc]initWithRootViewController:userOptionsViewController];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[venuesNavController, roomsNavController, userOptionsNavController];
    [[tabBarController.tabBar.items objectAtIndex:0] setTitle:NSLocalizedString(@"nearby", nil)];
    [[tabBarController.tabBar.items objectAtIndex:1] setTitle:NSLocalizedString(@"rooms", nil)];
    [[tabBarController.tabBar.items objectAtIndex:2] setTitle:NSLocalizedString(@"options", nil)];
    
    return tabBarController;
}

+(UIViewController *) createRoomViewController:(Room *)room
{
    RoomViewController *roomViewController = [[RoomViewController alloc]init];
    roomViewController.room = room;
    roomViewController.hidesBottomBarWhenPushed = true;
    return roomViewController;
}

+(UIViewController *) createNewRoomViewController:(void (^)(Room *newRoom))roomCreatedCallback
{
    NewRoomViewController *newRoomViewController = [[NewRoomViewController alloc]initWithStyle:UITableViewStyleGrouped];
    newRoomViewController.onRoomCreated = roomCreatedCallback;
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:newRoomViewController];
    return navController;
}

+(UINavigationController *) joinBuzzrdViewController
{
    JoinBuzzrdViewController *viewController = [[JoinBuzzrdViewController alloc]init];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:viewController];
    return navController;
}

+(RequiredInfoTableViewController *) requiredInfoTableViewController
{
    RequiredInfoTableViewController *viewController = [[RequiredInfoTableViewController alloc]init];
    return viewController;
}

+(OptionalInfoTableViewController *) optionalInfoTableViewController
{
    OptionalInfoTableViewController *viewController = [[OptionalInfoTableViewController alloc]init];
    return viewController;
}

@end
