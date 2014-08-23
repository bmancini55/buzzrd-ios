//
//  NearbyViewController.m
//  Buzzrd
//
//  Created by Brian Mancini on 6/1/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "NearbyViewController.h"
#import "Room.h"
#import "BuzzrdAPI.h"
#import "BuzzrdNav.h"
#import "FrameUtils.h"
#import "VenueCell.h"
#import "VenueRoomCell.h"
#import "FoursquareAttribution.h"
#import "GetLocationCommand.h"
#import "GetVenuesCommand.h"
#import "RetryAlert.h"
#import "TableSectionHeader.h"
#import "LoginViewController.h"

@interface NearbyViewController ()

@property (strong, nonatomic) NSArray *venues;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) RetryAlert *alert;

@end

@implementation NearbyViewController

- (void)loadView
{
    [super loadView];
    
    self.title = NSLocalizedString(@"nearby", nil);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self attachFooterToTableView:self.tableView];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(tableViewWillRefresh) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *addRoomItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addRoomTouch)];
    self.navigationItem.rightBarButtonItem = addRoomItem;
    
    UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Settings.png"] style:UIBarButtonItemStylePlain target:self action:@selector(settingsTouch)];
    self.navigationItem.leftBarButtonItem = settingsItem;
}

- (void)viewDidAppear:(BOOL)animated{
    
    // If user info is currently stored locally
    if ([BuzzrdAPI current].authorization.bearerToken != nil) {
        [self.refreshControl beginRefreshing];
        [self getUserLocation];
    }
    else {
        // Show the login view controller
        [self presentViewController:[BuzzrdNav createLoginViewController] animated:false completion:nil];
    }
}

- (void)tableViewWillRefresh
{
    [self getUserLocation];
}

- (void)getUserLocation
{
    GetLocationCommand *command = [[GetLocationCommand alloc]init];
    [command listenForCompletion:self selector:@selector(getLocationDidComplete:)];
    [[BuzzrdAPI dispatch] enqueueCommand:command];
}

- (void)getLocationDidComplete:(NSNotification *)notif
{
    GetLocationCommand *command = notif.object;
    if(command.status == kSuccess)
    {
        self.location = (CLLocation *)command.results;
        [self loadVenues];
    }
    else
    {
        [self showRetryAlertWithTitle:NSLocalizedString(@"location_error", nil)
                              message:NSLocalizedString(@"location_error_message", nil)
                       retryOperation:command];
    }
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self getUserLocation];
}


- (void)loadVenues
{
    GetVenuesCommand *command = [[GetVenuesCommand alloc] init];
    command.location = self.location.coordinate;
    command.search = nil;
    command.includeRooms = true;
    [command listenForCompletion:self selector:@selector(venuesDidLoad:)];
    [[BuzzrdAPI dispatch] enqueueCommand:command];
}

- (void)venuesDidLoad:(NSNotification *) notif
{
    [self.refreshControl endRefreshing];
    
    GetVenuesCommand *command = notif.object;
    NSArray *venues = command.results;
    
    NSLog(@"%lu venue were loaded", (unsigned long)venues.count);
    self.venues = venues;
    [self.tableView reloadData];
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
    return self.venues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Venue *venue = (Venue *)self.venues[indexPath.row];
    VenueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Venue"];
    if(cell == nil)
    {
        cell = [[VenueCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Venue"];
        cell.roomTableDelegate = self;
    }

    [cell setVenue:venue userLocation:self.location];    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Venue *venue = self.venues[indexPath.row];
    Room *room = venue.defaultRoom;
    [self joinRoom:room];
}




#pragma mark - UITableViewDelegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = CGRectMake(0, 0, tableView.frame.size.width, 30);
    TableSectionHeader *headerView = [[TableSectionHeader alloc]initWithFrame:frame];
    
    NSString *titleText;
    switch(section)
    {
        case 0:
//            titleText = NSLocalizedString(@"recently_visited_rooms", nil);
//            break;
//        case 1:
            titleText = NSLocalizedString(@"nearby_rooms", nil);
            break;
    }
    headerView.titleText = titleText;
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Venue *venue = self.venues[indexPath.row];
    VenueCell *cell = [[VenueCell alloc]init];
    [cell setVenue:venue userLocation:self.location];
    return [cell calculateHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}




#pragma mark - controller interaction methods

- (void) settingsTouch
{
    UIViewController *viewController = [BuzzrdNav createSettingsController];
    [self.navigationController pushViewController:viewController animated:true];
}


-(void)addRoomTouch
{
    UIViewController *viewController = [BuzzrdNav createNewRoomViewController:^(Venue *venue, Room *newRoom)
                                       {
                                           [self addRoomToTable:newRoom forVenue:venue];
                                       }];

    [self presentViewController:viewController animated:true completion:nil];
}

-(void)addRoomToTable:(Room *)room forVenue:(Venue *)venue;
{
    Venue *indexedVenue;
    int venueIndex;
    bool venueFound = false;
    
    // find the venue
    for(venueIndex = 0; venueIndex < self.venues.count; venueIndex++)
    {
        indexedVenue = self.venues[venueIndex];
        if([indexedVenue.id isEqualToString:room.venueId]) {
            venueFound = true;
            break;
        }
    }
    
    // insert venue
    if(!venueFound) {
        venue.defaultRoom = room;
        venue.rooms = @[ room ];
        venue.roomCount = 1;
        
        // insert venue
        NSMutableArray *temp = [NSMutableArray arrayWithArray:self.venues];
        [temp insertObject:venue atIndex:0];
        self.venues = [NSArray arrayWithArray:temp];
        
        // insert the venue cell
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:false];
    }
    
    // update existing
    else {
    
        // insert the room
        NSMutableArray *temp = [NSMutableArray arrayWithArray:indexedVenue.rooms];
        [temp insertObject:room atIndex:0];
        indexedVenue.rooms = [NSArray arrayWithArray:temp];
        indexedVenue.roomCount = indexedVenue.roomCount + 1;
        
        // insert the room cell
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:venueIndex inSection:0];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
    
    // join the room
    [self joinRoom:room];
}

#pragma VenueRoomTableDelegate

- (void) roomSelected:(Room *)room
{
    [self joinRoom:room];
}


@end
