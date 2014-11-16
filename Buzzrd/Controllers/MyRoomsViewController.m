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
#import "ThemeManager.h"
#import "FoursquareAttribution.h"

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
        
        // attach the footer
        [self attachFooterToTableView:self.tableView];
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

- (void) attachFooterToTableView:(UITableView *)tableView
{
    
    NSArray *dataSource = [self dataSourceForTableView:tableView];
    
    // no rows, show the message
    if(dataSource.count == 0) {
        UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 130)];
        
        UILabel *note = [[UILabel alloc]init];
        note.translatesAutoresizingMaskIntoConstraints = NO;
        note.numberOfLines = 0;
        note.font = [ThemeManager getPrimaryFontRegular:13.0];
        note.textColor = [ThemeManager getPrimaryColorDark];
        note.text = self.emptyNote;
        note.textAlignment = NSTextAlignmentCenter;
        [footer addSubview:note];
        
        tableView.tableFooterView = footer;
        
        NSDictionary *views =
        @{
          @"note": note
          };
        
        [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(24)-[note]-(24)-|" options:0 metrics:nil views:views]];
        [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(48)-[note]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    }
    else {
        CGRect footerFrame = CGRectMake(0, 0, tableView.frame.size.width, 45);
        FoursquareAttribution *footer =[[FoursquareAttribution alloc]initWithFrame:footerFrame];
        tableView.tableFooterView = footer;
    }
}

@end
