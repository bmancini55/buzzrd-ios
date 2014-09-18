//
//  MyRoomsViewController.m
//  Buzzrd
//
//  Created by Robert Beck on 9/17/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "MyRoomsViewController.h"
#import "BuzzrdAPI.h"
#import "GetNearbyRoomsCommand.h"

@interface MyRoomsViewController ()

@end

@implementation MyRoomsViewController

- (void)loadView
{
    [super loadView];
    
    self.title = NSLocalizedString(@"My Rooms", nil);
    
    self.sectionHeaderTitle = NSLocalizedString(@"MY ROOMS", nil);
    
    [self.tabBarController setTitle: NSLocalizedString(@"My Rooms", nil)];
}

- (void)loadRoomsWithSearch:(NSString *)search
{
    GetNearbyRoomsCommand *command = [[GetNearbyRoomsCommand alloc] init];
    command.location = self.location.coordinate;
    command.search = search;
    [command listenForCompletion:self selector:NSSelectorFromString(@"roomsDidLoad:")];
    [[BuzzrdAPI dispatch] enqueueCommand:command];
}

@end
