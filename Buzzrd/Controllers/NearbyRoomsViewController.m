//
//  NearbyRoomsViewController.m
//  Buzzrd
//
//  Created by Brian Mancini on 9/15/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "NearbyRoomsViewController.h"
#import "Room.h"
#import "BuzzrdAPI.h"
#import "BuzzrdNav.h"
#import "FrameUtils.h"
#import "FoursquareAttribution.h"
#import "GetLocationCommand.h"
#import "GetNearbyRoomsCommand.h"
#import "TableSectionHeader.h"
#import "LoginViewController.h"
#import "RoomCell.h"

@interface NearbyRoomsViewController ()

@property (strong, nonatomic) NSArray *rooms;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) RetryAlert *alert;
@property (strong, nonatomic) NSDate *lastLoad;

@end

@implementation NearbyRoomsViewController

- (void)loadView
{
    [super loadView];
    
    self.title = NSLocalizedString(@"nearby", nil);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self attachFooterToTableView:self.tableView];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(tableViewWillRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    UIBarButtonItem *addRoomItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addRoomTouch)];
    self.navigationItem.rightBarButtonItem = addRoomItem;
    
    UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Settings.png"] style:UIBarButtonItemStylePlain target:self action:@selector(settingsTouch)];
    self.navigationItem.leftBarButtonItem = settingsItem;
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Show the login view controller when not authenticated
    if ([BuzzrdAPI current].authorization.bearerToken == nil) {
        [self presentViewController:[BuzzrdNav createLoginViewController] animated:false completion:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self getUserLocation];
}

- (void)appDidBecomeActive
{
    [self getUserLocation];
}

- (void)tableViewWillRefresh
{
    self.lastLoad = nil;
    [self getUserLocation];
}

- (void)getUserLocation
{
    // Load the locations if we're authenticated and we haven't loaded, or it's been more than XX seconds since we last loaded
    if ([BuzzrdAPI current].authorization.bearerToken != nil && self.lastLoad == nil) {
        
        // flag last load time as now
        self.lastLoad = [NSDate dateWithTimeIntervalSinceNow:0];
        
        // start the spinner
        [self.refreshControl beginRefreshing];
        
        // build and dispatch the command
        GetLocationCommand *command = [[GetLocationCommand alloc]init];
        [command listenForCompletion:self selector:@selector(getLocationDidComplete:)];
        [[BuzzrdAPI dispatch] enqueueCommand:command];
    }
}

- (void)getLocationDidComplete:(NSNotification *)notif
{
    GetLocationCommand *command = notif.object;
    if(command.status == kSuccess)
    {
        self.location = (CLLocation *)command.results;
        [self loadRooms];
    }
    else
    {
        [self.refreshControl endRefreshing];
        [self showRetryAlertWithTitle:NSLocalizedString(@"location_error", nil)
                              message:NSLocalizedString(@"location_error_message", nil)
                       retryOperation:command];
    }
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self getUserLocation];
}

- (void)loadRooms
{
    GetNearbyRoomsCommand *command = [[GetNearbyRoomsCommand alloc] init];
    command.location = self.location.coordinate;
    command.search = nil;
    [command listenForCompletion:self selector:@selector(roomsDidLoad:)];
    [[BuzzrdAPI dispatch] enqueueCommand:command];
}

- (void)roomsDidLoad:(NSNotification *) notif
{
    GetNearbyRoomsCommand *command = notif.object;
    NSArray *rooms = command.results;
    
    self.rooms = rooms;
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void) joinRoom:(Room *)room
{
    UIViewController *viewController = [BuzzrdNav createRoomViewController:room];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void) attachFooterToTableView:(UITableView *)tableView;
{
    CGRect footerFrame = CGRectMake(0, 0, tableView.frame.size.width, 45);
    FoursquareAttribution *footer =[[FoursquareAttribution alloc]initWithFrame:footerFrame];
    tableView.tableFooterView = footer;
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rooms.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO OPTIMIZE WITH CACHE
    Room *room = self.rooms[indexPath.row];
    RoomCell *cell = [[RoomCell alloc]init];
    [cell setRoom:room userLocation:self.location];
    return [cell calculateHeight];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Room *room = (Room *)self.rooms[indexPath.row];
    RoomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nearby_room"];
    if(cell == nil)
    {
        cell = [[RoomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nearby_room"];
    }
    
    [cell setRoom:room userLocation:self.location];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Room *room = self.rooms[indexPath.row];
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
    headerView.titleText = NSLocalizedString(@"nearby_rooms", nil);
    return headerView;
}





#pragma mark - controller interaction methods

- (void) settingsTouch
{
    UIViewController *viewController = [BuzzrdNav createSettingsController];
    [self.navigationController pushViewController:viewController animated:true];
}


-(void)addRoomTouch
{
    UIViewController *viewController =
    [BuzzrdNav createNewRoomViewController:
        ^(Venue *venue, Room *newRoom)
        {
            [self addRoomToTable:newRoom forVenue:venue];
        }];
    
    [self presentViewController:viewController animated:true completion:nil];
}

-(void)addRoomToTable:(Room *)room forVenue:(Venue *)venue;
{
//    Venue *indexedVenue;
//    int venueIndex;
//    bool venueFound = false;
//    
//    // find the venue
//    for(venueIndex = 0; venueIndex < self.venues.count; venueIndex++)
//    {
//        indexedVenue = self.venues[venueIndex];
//        if([indexedVenue.id isEqualToString:room.venueId]) {
//            venueFound = true;
//            break;
//        }
//    }
//    
//    // insert venue
//    if(!venueFound) {
//        venue.defaultRoom = room;
//        venue.rooms = @[ room ];
//        venue.roomCount = 1;
//        
//        // insert venue
//        NSMutableArray *temp = [NSMutableArray arrayWithArray:self.venues];
//        [temp insertObject:venue atIndex:0];
//        self.venues = [NSArray arrayWithArray:temp];
//        
//        // insert the venue cell
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        [self.tableView beginUpdates];
//        [self.tableView insertRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [self.tableView endUpdates];
//        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:false];
//    }
//    
//    // update existing
//    else {
//        
//        // insert the room
//        NSMutableArray *temp = [NSMutableArray arrayWithArray:indexedVenue.rooms];
//        [temp insertObject:room atIndex:0];
//        indexedVenue.rooms = [NSArray arrayWithArray:temp];
//        indexedVenue.roomCount = indexedVenue.roomCount + 1;
//        
//        // insert the room cell
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:venueIndex inSection:0];
//        [self.tableView beginUpdates];
//        [self.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [self.tableView endUpdates];
//    }
//    
//    // join the room
//    [self joinRoom:room];
}

@end
