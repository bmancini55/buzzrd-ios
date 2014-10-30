//
//  BuzzrdNav.m
//  Buzzrd
//
//  Created by Brian Mancini on 5/14/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "BuzzrdNav.h"
#import "SettingsViewController.h"
#import "NearbyRoomsViewController.h"
#import "MyRoomsViewController.h"
#import "RoomVenueViewController.h"
#import "CreateRoomViewController.h"
#import "ThemeManager.h"
#import "Room.h"
#import "FriendsViewController.h"
#import "GetRoomCommand.h"
#import "MMDrawerController.h"

@implementation BuzzrdNav

+(UIViewController *) createSettingsController
{
    SettingsViewController *settingsViewController = [[SettingsViewController alloc]init];
    return settingsViewController;
}

+(RoomViewController *) getRoomViewController:(Room *)room
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




+ (void)dismissToRoot:(void (^)(UIViewController *))completed {
    UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [self dismissTillRootRecurive:rootController withCompleted:completed];
}


// Internal recursive method
+ (void)dismissTillRootRecurive:(UIViewController *)rootController withCompleted:(void (^)(UIViewController *))completed {
    
    UIViewController *topController = rootController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    if(topController.presentingViewController != rootController) {
        [topController dismissViewControllerAnimated:false completion:^{
            [self dismissTillRootRecurive:rootController withCompleted:completed];
        }];
    } else {
        [topController dismissViewControllerAnimated:false completion:^{
            completed(topController.presentingViewController);
        }];
    }
}


+ (void)dismissToPresented:(void (^)(UIViewController *))completed {
    UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [self dismissToPresentedRecursive:rootController withCompleted:completed];
}

// Internal recurisve method
+ (void)dismissToPresentedRecursive:(UIViewController *)rootController withCompleted:(void (^)(UIViewController *))completed {
    
    UIViewController *topController = rootController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    if(topController.presentingViewController != rootController) {
        [topController dismissViewControllerAnimated:false completion:^{
            [self dismissToPresentedRecursive:rootController withCompleted:completed];
        }];
    } else {
        completed(topController);
    }
}


+ (void)navigateToRoom:(NSString *)roomId {
    
    // Ensure we have a room to nav to
    if(![roomId isEqualToString:@""]) {
        
        // Retreive the room before we do anything else
        GetRoomCommand *command = [[GetRoomCommand alloc]init];
        command.roomId = roomId;
        command.success = ^(id result) {
            
            // Dismiss until we are at the logged in view information
            [BuzzrdNav dismissToPresented:^(UIViewController *presentedViewController) {
                
                // Ensure we have the MMDrawerController
                if([presentedViewController isMemberOfClass:[MMDrawerController class]]) {
            
                    // Traverse the presented stack... this could be hacky...
                    MMDrawerController *drawerController = (MMDrawerController *)presentedViewController;
                    UITabBarController *tabController = (UITabBarController *)drawerController.centerViewController;
                    UINavigationController *navController = (UINavigationController *)tabController.selectedViewController;
                    
                    // If we're in a room that isn't ours... we need to dismiss it before we pop
                    if([navController.topViewController isMemberOfClass:[RoomViewController class]]) {
                        
                        // abort if room is the same as current
                        if([((RoomViewController *)navController.topViewController).room.id isEqualToString:roomId]) {
                            return;
                        }
                        
                        // otherwise dismiss the current
                        [navController popViewControllerAnimated:false];
                    }
                    
                    // Finally we push our new room
                    RoomViewController *roomViewController = [BuzzrdNav getRoomViewController:(Room *)result];
                    [navController pushViewController:roomViewController animated:true];
                }
                
            }];
            
        };
        
        [[BuzzrdAPI dispatch] enqueueCommand:command];
    }
    
}

@end
