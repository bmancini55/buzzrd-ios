//
//  MyRoomsViewController.m
//  Buzzrd
//
//  Created by Robert Beck on 9/17/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "MyRoomsViewController.h"
#import "BuzzrdAPI.h"
#import "GetMyRoomsCommand.h"

@interface MyRoomsViewController ()

@end

@implementation MyRoomsViewController

- (void)loadView
{
    [super loadView];
    
    self.title = NSLocalizedString(@"my_rooms", nil);
    self.navigationController.title = [NSLocalizedString(@"my_rooms", nil) uppercaseString];
    self.sectionHeaderTitle = [NSLocalizedString(@"my_rooms", nil) uppercaseString];
}

- (void)loadRoomsWithSearch:(NSString *)search
{
    GetMyRoomsCommand *command = [[GetMyRoomsCommand alloc] init];
//    command.location = self.location.coordinate;
//    command.search = search;
    [command listenForCompletion:self selector:NSSelectorFromString(@"roomsDidLoad:")];
    [[BuzzrdAPI dispatch] enqueueCommand:command];
}

@end
