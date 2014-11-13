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
#import "NotificationInvitationCell.h"
#import "NotificationUnreadMessagesCell.h"
#import "RoomViewController.h"
#import "UpdateNotificationReadCommand.h"
#import "NotificationInvitation.h"
#import "NotificationUnreadMessages.h"
#import "GetRoomCommand.h"
#import "Room.h"

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
    
    [self addSettingsButton];
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(tableViewWillRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void) addSettingsButton
{
    UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithTitle:@"\u2699" style:UIBarButtonItemStylePlain target:self action:@selector(settingsTouch)];
    
    [settingsItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont fontWithName:@"Helvetica-Bold" size:26.0], NSFontAttributeName,
                                          nil]
                                forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = settingsItem;
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
    
    [[BuzzrdAPI current] updateBadgeCountWithArray:notifications];
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
    return 65;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *dataSource =  [self dataSourceForTableView:tableView];
    Notification *notification = dataSource[indexPath.row];
    
    if ([notification.typeId isEqualToNumber:@(1)])
    {
        static NSString *cellIdentifier = @"notification_invitation_cell";
    
        NotificationInvitationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
        if(cell == nil)
        {
            cell = [[NotificationInvitationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier notification:notification];
        }
    
        [cell setNotification:notification];
        
        return cell;
    }
    else {
        static NSString *cellIdentifier = @"notification_messages_cell";
        
        NotificationUnreadMessagesCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(cell == nil)
        {
            cell = [[NotificationUnreadMessagesCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier notification:notification];
        }
        
        [cell setNotification:notification];
        
        return cell;
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    
    Notification *notification = [self notificationForTableView:tableView indexPath:indexPath];
    NotificationCell *cell = (NotificationCell *) [tableView cellForRowAtIndexPath:indexPath];
    
    if (notification.read == false) {
        [cell markAsRead];
    }

    if ([notification.typeId isEqualToNumber:@(1)])
    {
        [self handleNotificationInvitation: (NotificationInvitation *)notification];
    }
    else
    {
        [self handleNotificationUnreadMessages: (NotificationUnreadMessages *)notification];
    }
}

- (void) handleNotificationInvitation:(NotificationInvitation *)notification
{
    if (notification.read == false) {
        notification.read = true;
        UpdateNotificationReadCommand *command = [[UpdateNotificationReadCommand alloc]init];
        command.notification = notification;
        [command listenForCompletion:self selector:@selector(updateNotificationReadDidComplete:)];
        [[BuzzrdAPI dispatch] enqueueCommand:command];
    }
    else
    {
        // Get the room
        GetRoomCommand *command = [[GetRoomCommand alloc]init];
        command.roomId = notification.roomId;
        [command listenForCompletion:self selector:@selector(getRoomDidComplete:)];
        [[BuzzrdAPI dispatch] enqueueCommand:command];
    }
}

- (void) handleNotificationUnreadMessages:(NotificationUnreadMessages *)notification
{
    // ignore updating read status for room related notifications, as these will be updated when the room loads
    if (notification.read == false && [notification.typeId intValue] != 1 && [notification.typeId intValue] != 2) {
        notification.read = true;
        UpdateNotificationReadCommand *command = [[UpdateNotificationReadCommand alloc]init];
        command.notification = notification;
        [command listenForCompletion:self selector:@selector(updateNotificationReadDidComplete:)];
        [[BuzzrdAPI dispatch] enqueueCommand:command];
    }
    else
    {
        // Get the room
        notification.read = true;
        GetRoomCommand *command = [[GetRoomCommand alloc]init];
        command.roomId = notification.roomId;
        [command listenForCompletion:self selector:@selector(getRoomDidComplete:)];
        [[BuzzrdAPI dispatch] enqueueCommand:command];
    }
}

- (void)updateNotificationReadDidComplete:(NSNotification *)info
{
    UpdateNotificationReadCommand *command = (UpdateNotificationReadCommand *)info.object;
    if(command.status == kSuccess) {
        
        if ([command.notification.typeId isEqualToNumber:@(1)])
        {
            NotificationInvitation *notification = (NotificationInvitation *) command.notification;
            
            // Get the room
            GetRoomCommand *command = [[GetRoomCommand alloc]init];
            command.roomId = notification.roomId;
            [command listenForCompletion:self selector:@selector(getRoomDidComplete:)];
            [[BuzzrdAPI dispatch] enqueueCommand:command];
        }
        else
        {
            NotificationUnreadMessages *notification = (NotificationUnreadMessages *) command.notification;
            
            // Get the room
            GetRoomCommand *command = [[GetRoomCommand alloc]init];
            command.roomId = notification.roomId;
            [command listenForCompletion:self selector:@selector(getRoomDidComplete:)];
            [[BuzzrdAPI dispatch] enqueueCommand:command];
        }
    }
    else
    {
        [self showRetryAlertWithTitle:NSLocalizedString(@"Unexpected Error", nil)
                              message:NSLocalizedString(@"An unexpected error occurred while processing your request", nil)
                       retryOperation:command];
    }
}

- (void)getRoomDidComplete:(NSNotification *)info
{
    GetRoomCommand *command = (GetRoomCommand *)info.object;
    if(command.status == kSuccess) {
        Room * room = (Room *) command.results;
        
        [self navigateToRoom: room];
    }
    else
    {
        [self showRetryAlertWithTitle:NSLocalizedString(@"Unexpected Error", nil)
                              message:NSLocalizedString(@"An unexpected error occurred while processing your request", nil)
                       retryOperation:command];
    }
}

- (void) navigateToRoom:(Room *)room
{
    RoomViewController *roomViewController = [[RoomViewController alloc]init];
    roomViewController.room = room;
    roomViewController.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:roomViewController animated:YES];
}

- (void) settingsTouch
{
    UIViewController *viewController = [BuzzrdNav createSettingsController];
    viewController.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:viewController animated:true];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y <= 10) {
        [self loadNotifications];
    }
}

- (void)tableViewWillRefresh
{
    [self.refreshControl endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadNotifications];
}

@end
