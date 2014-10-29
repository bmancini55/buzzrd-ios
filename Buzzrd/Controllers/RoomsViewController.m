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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveClearBadgeNotification:) name:@"clearBadgeNotification" object:nil];
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
    
    UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Settings.png"] style:UIBarButtonItemStylePlain target:self action:@selector(didTouchSettings)];
    self.navigationItem.leftBarButtonItem = settingsItem;
    
    [self getUserLocation];
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
        NSArray *rooms = command.results;
        
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
        NSArray *rooms = command.results;
        
        self.rooms = rooms;
        [self.tableView reloadData];
        [self attachFooterToTableView:self.tableView];
    }
}

- (void) joinRoom:(Room *)room
{
    UIViewController *viewController = [BuzzrdNav createRoomViewController:room];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void) didReceiveClearBadgeNotification:(NSNotification*)notification {
    NSString *roomId = notification.userInfo[@"roomId"];
    
    // declare iterator that will clear the badge
    void(^clearBadge)(id object, NSUInteger idx, bool *stop) = ^(id object, NSUInteger idx, bool *stop) {
        Room *room = (Room *)object;
        if([room.id isEqualToString:roomId]) {
            room.newMessages = false;
            [self tableView:self.tableView reloadRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
        }
    };
    
    // clear the badges
    [self.rooms enumerateObjectsUsingBlock:clearBadge];
    [self.searchResults enumerateObjectsUsingBlock:clearBadge];
}


#pragma mark - Table view data source

// Helper function that retrieves a data source for the specified table view
- (NSArray *) dataSourceForTableView:(UITableView *)tableView
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
    
    NSArray *dataSource = [self dataSourceForTableView:tableView];
    
    // no rows, show the create button
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
        
        UIButton *button = [[UIButton alloc]init];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.backgroundColor = [ThemeManager getTertiaryColorDark];
        button.layer.cornerRadius = 6.0f;
        button.titleLabel.font = [ThemeManager getPrimaryFontRegular:15.0];
        [button setTitle:NSLocalizedString(@"create_room", nil) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didTouchAddRoom) forControlEvents:UIControlEventTouchUpInside];
        [footer addSubview:button];
        
        tableView.tableFooterView = footer;
        
        NSDictionary *views =
        @{
          @"note": note,
          @"button": button
          };
        
        [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=12)-[button(120)]-(>=12)-|" options:0 metrics:nil views:views]];
        [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(24)-[note]-(24)-|" options:0 metrics:nil views:views]];
        [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=12)-[note]-24-[button]-(>=12)-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    }
    
    // have rows, show foursquare
    else {
        CGRect footerFrame = CGRectMake(0, 0, tableView.frame.size.width, 45);
        FoursquareAttribution *footer =[[FoursquareAttribution alloc]initWithFrame:footerFrame];
        tableView.tableFooterView = footer;
    }
}


- (void)tableView:(UITableView *)tableView reloadRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
}



#pragma mark - controller interaction methods

- (void) didTouchSettings
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
    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.rooms];
    [temp insertObject:room atIndex:0];
    self.rooms = [NSArray arrayWithArray:temp];

    // insert the room cell
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:false];

    // join the room
    [self joinRoom:room];
}

@end
