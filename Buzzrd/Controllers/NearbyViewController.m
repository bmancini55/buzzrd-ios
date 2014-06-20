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
#import "VenueView.h"
#import "VenueRoomView.h"
#import "VenueRoomCell.h"
#import "LocationService.h"

@interface NearbyViewController ()

@property (strong, nonatomic) LocationService *locationService;

@end

@implementation NearbyViewController

- (void)loadView
{
    [super loadView];
    
    self.title = NSLocalizedString(@"nearby", nil);
    
    UIBarButtonItem *addRoomItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addRoomTouch)];
    self.navigationItem.rightBarButtonItem = addRoomItem;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[LocationService sharedInstance] addObserver:self forKeyPath:@"currentLocation" options:NSKeyValueObservingOptionNew context:nil];
    [[LocationService sharedInstance] startUpdatingLocation];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object  change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"currentLocation"]) {
        [self loadVenues];
    }
}

- (void) loadVenues
{
    [[BuzzrdAPI current].venueService
     getVenues:[LocationService sharedInstance].currentLocation.coordinate
     search:nil
     includeRooms:true
     success: ^(NSArray *theVenues) {
         NSLog(@"%lu venue were loaded", (unsigned long)theVenues.count);
         self.venues = theVenues;
         [self.tableView reloadData];
     }
     failure:^(NSError *error) {
         NSLog(@"%@", error);
     }];
}

- (void) joinRoom:(Room *)room
{
    UIViewController *viewController = [BuzzrdNav createRoomViewController:room];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.venues.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((Venue *)self.venues[section]).rooms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Venue *venue = (Venue *)self.venues[indexPath.section];
    Room *room = venue.rooms[indexPath.row];
    
    VenueRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VenueRoom"];
    if(cell == nil)
    {
        cell = [[VenueRoomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VenueRoom"];
    }

    [cell.roomView setRoom:room];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Venue *venue = self.venues[indexPath.section];
    Room *room = venue.rooms[indexPath.row];
    [self joinRoom:room];
}

#pragma mark - UITableViewDelegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    Venue *venue = self.venues[section];
    
    VenueView *venueView = [[VenueView alloc]init];
    [venueView setVenue:venue userLocation:[LocationService sharedInstance].currentLocation];
    
    UIView *view = [[UIView alloc]init];
    [view addSubview:venueView];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 52;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}

#pragma mark - controller interaction methods

-(void)addRoomTouch
{
    UIViewController *viewController = [BuzzrdNav createNewRoomViewController:^(Room *newRoom)
                                       {
                                           [self addRoomToTable:newRoom];
                                           [self joinRoom:newRoom];
                                       }];

    [self presentViewController:viewController animated:true completion:nil];
}

-(void)addRoomToTable:(Room *)room
{
    int venueIndex;
    Venue *venue;
    
    // find the venue
    for(venueIndex = 0; venueIndex < self.venues.count; venueIndex++)
    {
        venue = self.venues[venueIndex];
        if([venue.id isEqualToString:room.venueId])
            break;
    }
    
    // insert the room
    NSMutableArray *temp = [NSMutableArray arrayWithArray:venue.rooms];
    [temp insertObject:room atIndex:0];
    venue.rooms = [NSArray arrayWithArray:temp];
    
    // insert the room cell
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:venueIndex];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
