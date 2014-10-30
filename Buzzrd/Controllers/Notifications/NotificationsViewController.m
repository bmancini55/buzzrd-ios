//
//  NotificationsViewController.m
//  Buzzrd
//
//  Created by Robert Beck on 10/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "NotificationsViewController.h"
#import "BuzzrdAPI.h"
#import "Notification.h"
#import "GetNotificationsCommand.h"
#import "RemoveNotificationCommand.h"
#import "TableSectionHeader.h"
#import "BuzzrdNav.h"
#import "NotificationCell.h"

@interface NotificationsViewController ()

@end

@implementation NotificationsViewController

- (void)loadView
{
    [super loadView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.title = NSLocalizedString(@"Notifications", nil);
    self.navigationController.title = [NSLocalizedString(@"Notifications", nil) uppercaseString];
    self.sectionHeaderTitle = [NSLocalizedString(@"Notifications", nil) uppercaseString];
    
    UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Settings.png"] style:UIBarButtonItemStylePlain target:self action:@selector(settingsTouch)];
    self.navigationItem.leftBarButtonItem = settingsItem;
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    [self loadNotifications];
}

- (void)loadNotifications
{
    GetNotificationsCommand *command = [[GetNotificationsCommand alloc] init];
    
    [command listenForCompletion:self selector:NSSelectorFromString(@"notificationsDidLoad:")];
    [[BuzzrdAPI dispatch] enqueueCommand:command];
}

- (void)notificationsDidLoad:(NSNotification *) notif
{
    GetNotificationsCommand *command = notif.object;
    NSMutableArray *notifications = command.results;
    
    [self.refreshControl endRefreshing];
    
    self.notifications = notifications;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

// Helper function that retrieves a data source for the specified table view
- (NSMutableArray *) dataSourceForTableView:(UITableView *)tableView
{
    return self.notifications;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *dataSource =  [self dataSourceForTableView:tableView];
    return dataSource.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // No need to calculate these, lets just hardcode it
    NSMutableArray *dataSource =  [self dataSourceForTableView:tableView];
    Notification *notification = dataSource[indexPath.row];
    
    
    NotificationCell *cell = [[NotificationCell alloc]initWithNotification:notification];
    [cell setNotification:notification];
    
    // Do the layout pass on the cell, which will calculate the frames for all the views based on the constraints
    // (Note that the preferredMaxLayoutWidth is set on multi-line UILabels inside the -[layoutSubviews] method
    // in the UITableViewCell subclass
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    // Get the actual height required for the cell
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    // Add an extra point to the height to account for the cell separator, which is added between the bottom
    // of the cell's contentView and the bottom of the table view cell.
    //    height += 15;
    
    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *dataSource =  [self dataSourceForTableView:tableView];
    Notification *notification = dataSource[indexPath.row];
    
    static NSString *cellIdentifier = @"notification_cell";
    
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[NotificationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier notification:notification];
    }
    
    [cell setNotification:notification];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = CGRectMake(0, 0, tableView.frame.size.width, 30);
    TableSectionHeader *headerView = [[TableSectionHeader alloc]initWithFrame:frame];
    headerView.titleText = self.sectionHeaderTitle;
    return headerView;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - controller interaction methods

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Notification *notification = [self notificationForTableView:self.tableView indexPath:indexPath];
        
        RemoveNotificationCommand *command = [[RemoveNotificationCommand alloc]init];
        command.notification = notification;
        command.indexPath = indexPath;
        [command listenForCompletion:self selector:@selector(removeNotificationDidComplete:)];
        [[BuzzrdAPI dispatch] enqueueCommand:command];
    }
}

// Helper function that retrieves a value for a tableview and index path
- (Notification *)notificationForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *dataSource = [self dataSourceForTableView:tableView];
    return (Notification *)dataSource[indexPath.row];
}

- (void)removeNotificationDidComplete:(NSNotification *)info
{
    RemoveNotificationCommand *command = (RemoveNotificationCommand *)info.object;
    if(command.status == kSuccess) {
        [self.notifications removeObjectAtIndex:command.indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[command.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else
    {
        [self showRetryAlertWithTitle:NSLocalizedString(@"Unexpected Error", nil)
                              message:NSLocalizedString(@"An unexpected error occurred while processing your request", nil)
                       retryOperation:command];
    }
}

- (void) settingsTouch
{
    UIViewController *viewController = [BuzzrdNav createSettingsController];
    viewController.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:viewController animated:true];
}

@end
