//
//  RoomVenueViewController.m
//  Buzzrd
//
//  Created by Brian Mancini on 6/14/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "RoomVenueViewController.h"
#import "VenueCell.h"
#import "BuzzrdAPI.h"
#import "RoomOptionsViewController.h"
#import "FoursquareAttribution.h"
#import "GetVenuesCommand.h"
#import "GetLocationCommand.h"

@interface RoomVenueViewController ()

@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSArray *venues;
@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) UISearchDisplayController *tempSearchController;

@end

@implementation RoomVenueViewController

-(id)initWithCallback:(void (^)(Venue *venue, Room *created))onRoomCreated
{
    self = [self initWithStyle:UITableViewStyleGrouped];
    if(self != nil)
    {
        self.onRoomCreated = onRoomCreated;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.title = NSLocalizedString(@"new_room", nil);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self attachFooterToTableView:self.tableView];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(tableViewWillRefresh) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTouch)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    self.tempSearchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.delegate = self;
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = searchBar;
 
    [self.refreshControl beginRefreshing];
    [self getUserLocation];
}

- (void)tableViewWillRefresh
{
    NSLog(@"Refreshing table");
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
        [self loadVenuesForTable:self.tableView withSearch:nil];
    }
    else
    {
        [self showRetryAlertWithTitle:NSLocalizedString(@"location_error", nil)
                              message:NSLocalizedString(@"location_error_message", nil)
                       retryOperation:command];
    }
}

- (void) loadVenuesForTable:(UITableView *)tableView withSearch:(NSString *)search
{
    GetVenuesCommand *command = [[GetVenuesCommand alloc] init];
    command.location = self.location.coordinate;
    command.search = search;
    command.includeRooms = false;
    [command listenForCompletion:self selector:@selector(venuesDidLoad:)];
    [[BuzzrdAPI dispatch] enqueueCommand:command];
}

- (void)venuesDidLoad:(NSNotification *) notif
{
    [self.refreshControl endRefreshing];
    
    GetVenuesCommand *command = notif.object;
    NSArray *venues = command.results;
    
    NSLog(@"%lu venues were loaded", (unsigned long)venues.count);
    
    if(command.search == nil) {
        self.venues = venues;
        [self.tableView reloadData];
    } else {
        self.searchResults = venues;
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}

- (void) cancelTouch
{
    [self dismissViewControllerAnimated:true completion:nil];
}

// Helper function that retrieves a data source for the specified table view
- (NSArray *) dataSourceForTableView:(UITableView *)tableView
{
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return self.searchResults;
    }
    else {
        return self.venues;
    }
}

// Helper function that retrieves a value for a tableview and index path
- (Venue *)venueForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSArray *dataSource = [self dataSourceForTableView:tableView];
    return (Venue *)dataSource[indexPath.row];
}

// Helper to add foursquare attribution to a table as the footer
- (void) attachFooterToTableView:(UITableView *)tableView;
{
    CGRect footerFrame = CGRectMake(0, 0, tableView.frame.size.width, 45);
    FoursquareAttribution *footer =[[FoursquareAttribution alloc]initWithFrame:footerFrame];
    tableView.tableFooterView = footer;
}


#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *dataSource = [self dataSourceForTableView:tableView];
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"choose_venue_cell";
    VenueCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    // construct a new cell
    if(cell == nil)
    {
        cell = [[VenueCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    Venue *venue = [self venueForTableView:tableView indexPath:indexPath];
    [cell setVenue:venue userLocation:self.location];
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    
    Venue *venue = [self venueForTableView:tableView indexPath:indexPath];
    Room *room = [[Room alloc]init];
    room.name = venue.name;
    room.venueId = venue.id;
    
    if(venue.roomCount == 0)
    {
        // create the default room
        [[BuzzrdAPI current].roomService
         createRoom:room
         success:^(Venue *venue, Room* createdRoom)
         {
             NSLog(@"Created room: %@, %@", createdRoom.id, createdRoom.name);
             [self dismissViewControllerAnimated:true completion:^{
                 self.onRoomCreated(venue, createdRoom);
              }];
         }
         failure:^(NSError *error) {
             NSLog(@"%@", error);
         }];
    }
    else
    {
        RoomOptionsViewController *viewController = [[RoomOptionsViewController alloc]initWithVenue:venue callback:self.onRoomCreated];
        [self.navigationController pushViewController:viewController animated:true];
    }
}


#pragma mark - Search display delegate

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    return false;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self loadVenuesForTable:self.searchDisplayController.searchResultsTableView withSearch:searchString];
    return false;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    [self attachFooterToTableView:tableView];
}

@end
