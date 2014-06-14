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

@interface RoomVenueViewController ()

@property (strong, nonatomic) NSArray *venues;

@end

@implementation RoomVenueViewController

-(id)initWithCallback:(void (^)(Room *created))onRoomCreated
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
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTouch)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    [self loadVenues];
}

- (void) loadVenues
{
    [[BuzzrdAPI current].venueService
     getVenues:[LocationService sharedInstance].currentLocation.coordinate
     search:nil
     includeRooms:false
     success: ^(NSArray *theVenues) {
         NSLog(@"%lu venues were loaded", (unsigned long)theVenues.count);
         self.venues = theVenues;
         [self.tableView reloadData];
     }
     failure:^(NSError *error) {
         NSLog(@"%@", error);
     }];
}

- (void) cancelTouch
{
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - Table view data source

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.venues.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"select_venue", nil);
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
    
    Venue *venue = self.venues[indexPath.row];
    CLLocation *location = [LocationService sharedInstance].currentLocation;
    [cell setVenue:venue userLocation:location];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Venue *venue = self.venues[indexPath.row];
    Room *room = [[Room alloc]init];
    room.name = venue.name;
    room.venueId = venue.id;
    
    if(venue.roomCount == 0)
    {
        // create the default room
        [[BuzzrdAPI current].roomService
         createRoom:room
         success:^(Room* createdRoom)
         {
             NSLog(@"Created room: %@, %@", createdRoom.id, createdRoom.name);
             self.onRoomCreated(createdRoom);             
             [self dismissViewControllerAnimated:true completion:nil];
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
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:false];
}

@end
