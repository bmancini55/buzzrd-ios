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
#import "FoursquareAttribution.h"

#import "GetVenuesCommand.h"

@interface NearbyViewController ()

@property (strong, nonatomic) LocationService *locationService;

@end

@implementation NearbyViewController

- (void)loadView
{
    [super loadView];
    
    self.title = NSLocalizedString(@"nearby", nil);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self attachFooterToTableView:self.tableView];
    
    UIBarButtonItem *addRoomItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addRoomTouch)];
    self.navigationItem.rightBarButtonItem = addRoomItem;
    
    
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
    GetVenuesCommand *command = [[GetVenuesCommand alloc] init];
    command.location = [LocationService sharedInstance].currentLocation.coordinate;
    command.search = nil;
    command.includeRooms = true;
    [command listenForCompletion:self selector:@selector(venuesDidLoad:)];
    [[BuzzrdAPI dispatch] enqueueCommand:command];
}

- (void)venuesDidLoad:(NSNotification *) notif
{
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
    UIViewController *viewController = [BuzzrdNav createNewRoomViewController:^(Venue *venue, Room *newRoom)
                                       {
                                           [self addRoomToTable:newRoom forVenue:venue];
                                           [self joinRoom:newRoom];
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
        venue.rooms = @[ room ];
        venue.roomCount = 1;
        
        // insert venue
        NSMutableArray *temp = [NSMutableArray arrayWithArray:self.venues];
        [temp insertObject:venue atIndex:0];
        self.venues = [NSArray arrayWithArray:temp];
        
        // insert the venue cell
        [self.tableView beginUpdates];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
        [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
    
    // update existing
    else {
    
        // insert the room
        NSMutableArray *temp = [NSMutableArray arrayWithArray:indexedVenue.rooms];
        [temp insertObject:room atIndex:0];
        indexedVenue.rooms = [NSArray arrayWithArray:temp];
        
        // insert the room cell
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:venueIndex];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
