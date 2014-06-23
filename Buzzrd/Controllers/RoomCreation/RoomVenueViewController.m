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
#import "LocationService.h"
#import "RoomOptionsViewController.h"
#import "FoursquareAttribution.h"

@interface RoomVenueViewController ()

@property (strong, nonatomic) NSArray *venues;
@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) UISearchDisplayController *searchController;

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
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTouch)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    self.searchController.searchResultsDelegate = self;
    self.searchController.searchResultsDataSource = self;
    self.searchController.delegate = self;
    self.tableView.tableHeaderView = searchBar;
    
    [self loadVenuesForTable:self.tableView withSearch:nil];
}

- (void) loadVenuesForTable:(UITableView *)tableView withSearch:(NSString *)search
{
    //[self showActivityView];
    
    [[BuzzrdAPI current].venueService
     getVenues:[LocationService sharedInstance].currentLocation.coordinate
     search:search
     includeRooms:false
     success: ^(NSArray *theVenues) {
         NSLog(@"%lu venues were loaded", (unsigned long)theVenues.count);
         
         if(search == nil) {
             self.venues = theVenues;
         } else {
             self.searchResults = theVenues;
         }
         
         [self hideActivityView];
         [tableView reloadData];
     }
     failure:^(NSError *error) {
         NSLog(@"%@", error);
         [self hideActivityView];
     }];
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



#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *dataSource = [self dataSourceForTableView:tableView];
    
    switch (section) {
        case 0:
            return dataSource.count;
        case 1:
            return 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            NSString *identifier = @"choose_venue_cell";
            VenueCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            // construct a new cell
            if(cell == nil)
            {
                cell = [[VenueCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            
            Venue *venue = [self venueForTableView:tableView indexPath:indexPath];
            CLLocation *location = [LocationService sharedInstance].currentLocation;
            [cell setVenue:venue userLocation:location];
            
            return cell;
        }
        case 1:
        {
            NSString *identifier = @"foursquare_attribution";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.backgroundColor = [UIColor clearColor];

                FoursquareAttribution *foursquareAttribution = [[FoursquareAttribution alloc]initWithFrame:cell.frame];
                [cell addSubview:foursquareAttribution];
            }
            return cell;
        }
        default:
            return nil;
    }
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    
    if(indexPath.section == 0)
    {
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
}


#pragma mark - Search display delegate

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    return false;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self loadVenuesForTable:self.searchController.searchResultsTableView withSearch:searchString];
    return false;
}

@end
