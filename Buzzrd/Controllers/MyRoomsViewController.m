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
#import "RemoveRoomCommand.h"

@interface MyRoomsViewController ()

@end

@implementation MyRoomsViewController

- (void)loadView
{
    [super loadView];
    
    self.title = NSLocalizedString(@"my_rooms", nil);
    self.navigationController.title = [NSLocalizedString(@"my_rooms", nil) uppercaseString];
    self.sectionHeaderTitle = [NSLocalizedString(@"my_rooms", nil) uppercaseString];
    self.emptyNote = NSLocalizedString(@"myrooms_empty_note", nil);
}

- (void)loadRoomsWithSearch:(NSString *)search
{
    GetMyRoomsCommand *command = [[GetMyRoomsCommand alloc] init];
    [command listenForCompletion:self selector:NSSelectorFromString(@"roomsDidLoad:")];
    [[BuzzrdAPI dispatch] enqueueCommand:command];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Room *room = [self roomForTableView:self.tableView indexPath:indexPath];
        
        RemoveRoomCommand *command = [[RemoveRoomCommand alloc]init];
        command.room = room;
        command.indexPath = indexPath;
        [command listenForCompletion:self selector:@selector(removeRoomDidComplete:)];
        [[BuzzrdAPI dispatch] enqueueCommand:command];
    }
}

// Helper function that retrieves a value for a tableview and index path
- (Room *)roomForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *dataSource = [self dataSourceForTableView:tableView];
    return (Room *)dataSource[indexPath.row];
}

- (void)removeRoomDidComplete:(NSNotification *)info
{
    RemoveRoomCommand *command = (RemoveRoomCommand *)info.object;
    if(command.status == kSuccess) {
        [self.rooms removeObjectAtIndex:command.indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[command.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        NSDictionary *userInfo =
        @{
            BZRoomPropsDidChangeRoomIdKey: command.room.id,
            BZRoomPropsDidChangePropertiesKey:
                                        @{  @"notify": [NSNumber numberWithBool:false],
                                            @"watchedRoom": [NSNumber numberWithBool:false],
                                            @"newMessages": [NSNumber numberWithUnsignedInt:0] }
        };
        [[NSNotificationCenter defaultCenter] postNotificationName:BZRoomPropsDidChangeNotification object:nil userInfo:userInfo];
    }
    else
    {
        [self showRetryAlertWithTitle:NSLocalizedString(@"Unexpected Error", nil)
                              message:NSLocalizedString(@"An unexpected error occurred while processing your request", nil)
                       retryOperation:command];
    }
}

- (NSMutableArray *) dataSourceForTableView:(UITableView *)tableView
{
    return self.rooms;
}

@end
