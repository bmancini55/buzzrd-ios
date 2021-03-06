//
//  RoomsViewController.m
//  Buzzrd
//
//  Created by Robert Beck on 9/17/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "RoomsViewController.h"
#import "Room.h"
#import "BuzzrdAPI.h"
#import "BuzzrdNav.h"
#import "FrameUtils.h"
#import "FoursquareAttribution.h"
#import "TableSectionHeader.h"
#import "LoginViewController.h"
#import "RoomCell.h"
#import "ThemeManager.h"
#import "GetNearbyRoomsCommand.h"
#import "GetMyRoomsCommand.h"

@interface RoomsViewController ()

@property (strong, nonatomic) RetryAlert *alert;

@end

@implementation RoomsViewController

- (id)init {
    self = [super init];
    if(self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveRoomUnreadNotification:) name:BZAppDidReceiveRoomUnreadNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveClearBadgeNotification:) name:BZRoomDidClearBadgeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveRoomPropChangeNotification:) name:BZRoomPropsDidChangeNotification object:nil];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(tableViewWillRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    UIBarButtonItem *addRoomItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didTouchAddRoom)];
    self.navigationItem.rightBarButtonItem = addRoomItem;
    
    [self addSettingsButton];
    
    [self getUserLocation];
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

- (void)tableViewWillRefresh
{
    NSLog(@"%p:RoomsViewController:tableViewWillRefresh", self);
    [self.refreshControl endRefreshing];
    [self getUserLocation];
}

- (void)getUserLocation
{
    NSLog(@"%p:RoomsViewController:getUserLocation", self);
    GetLocationCommand *command = [[GetLocationCommand alloc]init];
    command.autoHideActivityIndicator = false;  // disable hiding so it chains properly
    [command listenForCompletion:self selector:@selector(getLocationDidComplete:)];
    [[BuzzrdAPI dispatch] enqueueCommand:command];
}

- (void)getLocationDidComplete:(NSNotification *)notif
{
    GetLocationCommand *command = notif.object;
    if(command.status == kSuccess)
    {
        self.location = (CLLocation *)command.results;
        [self loadRoomsWithSearch:nil];
    }
    else
    {
        NSDictionary *results = command.results;
        BZLocationManagerStatus status = [results[@"status"] intValue];

        // when not determined
        if (status == BZLocationManagerStatusNotDetermined) {
            [self showMandatoryRetryAlertWithTitle:NSLocalizedString(@"location_error",nil)
                                           message:NSLocalizedString(@"location_error_message",nil)
                                    retryOperation:command];
        }
        // when disabled
        else if(status == BZLocationManagerStatusDisabled)
        {
            [self showMandatoryRetryAlertWithTitle:NSLocalizedString(@"location_services_disabled",nil)
                                  message:NSLocalizedString(@"location_services_disabled_message",nil)
                           retryOperation:command];
        }
        // when denied
        else if (status == BZLocationManagerStatusDenied)
        {
            [self showMandatoryRetryAlertWithTitle:NSLocalizedString(@"location_services_denied",nil)
                                           message:NSLocalizedString(@"location_services_denied_message",nil)
                                    retryOperation:command];
        }
        // when error
        else
        {
            [self showMandatoryRetryAlertWithTitle:NSLocalizedString(@"location_error", nil)
                                  message:NSLocalizedString(@"location_error_message", nil)
                           retryOperation:command];

        }
    }
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self getUserLocation];
}

- (void)loadRoomsWithSearch:(NSString *)search
{
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];

}

- (void)roomsDidLoad:(NSNotification *) notif
{
    if ([notif.object isKindOfClass:[GetNearbyRoomsCommand class]])
    {
        GetNearbyRoomsCommand *command = notif.object;
        NSMutableArray *rooms = command.results;
        
        if(command.search == nil) {
            self.rooms = rooms;
            [self.tableView reloadData];
            [self attachFooterToTableView:self.tableView];
        } else {
            self.searchResults = rooms;
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    }
    else if ([notif.object isKindOfClass:[GetMyRoomsCommand class]])
    {
        GetMyRoomsCommand *command = notif.object;
        NSMutableArray *rooms = command.results;
        
        self.rooms = rooms;
        [self.tableView reloadData];
        [self attachFooterToTableView:self.tableView];
    }
}

- (void) joinRoom:(Room *)room
{
    UIViewController *viewController = [BuzzrdNav getRoomViewController:room];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void) didReceiveRoomUnreadNotification:(NSNotification *)notification {
    NSString *roomId = notification.userInfo[BZAppDidReceiveRoomUnreadRoomIdKey];

    // declare iterator that will clear the badge
    id iterator = ^(id object, NSUInteger idx, bool *stop) {
        Room *room = (Room *)object;
        
        // check for a room match
        if([room.id isEqualToString:roomId]) {
            
            // update room data
            room.newMessages = true;
            
            // update table row for room
            [self tableView:self.tableView reloadRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
        }
    };
    
    // clear the badges
    [self.rooms enumerateObjectsUsingBlock:iterator];
    [self.searchResults enumerateObjectsUsingBlock:iterator];
}

- (void) didReceiveClearBadgeNotification:(NSNotification*)notification {
    NSString *roomId = notification.userInfo[BZRoomDidClearBadgeRoomKey];
    
    // declare iterator that will clear the badge
    id iterator = ^(id object, NSUInteger idx, bool *stop) {
        Room *room = (Room *)object;
        if([room.id isEqualToString:roomId]) {
            room.newMessages = false;
            [self tableView:self.tableView reloadRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
        }
    };
    
    // clear the badges
    [self.rooms enumerateObjectsUsingBlock:iterator];
    [self.searchResults enumerateObjectsUsingBlock:iterator];
}

- (void) didReceiveRoomPropChangeNotification:(NSNotification*)notification {
    NSString *roomId = notification.userInfo[BZRoomPropsDidChangeRoomIdKey];
    NSDictionary *properties = notification.userInfo[BZRoomPropsDidChangePropertiesKey];

    // declare iterator that will update
    id iterator = ^(id object, NSUInteger idx, bool *stop) {
        Room *room = (Room *)object;
        if([room.id isEqualToString:roomId]) {
            
            // set any/all properties
            for (NSString* key in properties.keyEnumerator) {
                [room setValue:properties[key] forKey:key];
            }
            
            // update the table
            [self tableView:self.tableView reloadRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
        }
    };
    
    // clear the badges
    [self.rooms enumerateObjectsUsingBlock:iterator];
    [self.searchResults enumerateObjectsUsingBlock:iterator];
}


#pragma mark - Table view data source

// Helper function that retrieves a data source for the specified table view
- (NSMutableArray *) dataSourceForTableView:(UITableView *)tableView
{
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return self.searchResults;
    }
    else {
        return self.rooms;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *dataSource =  [self dataSourceForTableView:tableView];
    return dataSource.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // No need to calculate these, lets just hardcode it
    return 66;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *dataSource =  [self dataSourceForTableView:tableView];
    Room *room = dataSource[indexPath.row];
    
    RoomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"room_cell"];
    if(cell == nil)
    {
        cell = [[RoomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"room_cell"];
    }
    
    [cell setRoom:room userLocation:self.location];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *dataSource =  [self dataSourceForTableView:tableView];
    Room *room = dataSource[indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self joinRoom:room];
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




- (void) attachFooterToTableView:(UITableView *)tableView
{
    [NSException raise:@"attachFooterToTableView needs to be implemented" format:nil];
}


- (void)tableView:(UITableView *)tableView reloadRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
}



#pragma mark - controller interaction methods

- (void) settingsTouch
{
    UIViewController *viewController = [BuzzrdNav createSettingsController];
    viewController.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:viewController animated:true];
}


-(void)didTouchAddRoom
{
    UIViewController *viewController =
    [BuzzrdNav createNewRoomViewController:^(Room *newRoom)
     {
         [self addRoomToTable:newRoom];
     }];
    
    [self presentViewController:viewController animated:true completion:nil];
}

-(void)addRoomToTable:(Room *)room
{
    // insert room
    [self.rooms insertObject:room atIndex:0];

    // insert the room cell
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:false];
    
    // attach footer view
    [self attachFooterToTableView:self.tableView];

    // join the room
    [self joinRoom:room];
}

@end
