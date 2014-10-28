//
//  BuzzrdNav.m
//  Buzzrd
//
//  Created by Brian Mancini on 5/14/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "BuzzrdNav.h"
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
