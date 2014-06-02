//
//  VenuesViewController.m
//  Buzzrd
//
//  Created by Brian Mancini on 6/1/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "VenuesViewController.h"
#import "Room.h"
#import "BuzzrdAPI.h"
#import "BuzzrdNav.h"
#import "FrameUtils.h"

@interface VenuesViewController ()

@end

@implementation VenuesViewController

- (void)loadView
{
    [super loadView];
    
    self.title = NSLocalizedString(@"nearby", nil);
    UIBarButtonItem *addRoomItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addRoomTouch)];
    self.navigationItem.rightBarButtonItem = addRoomItem;
    
    if(self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLDistanceFilterNone;
    self.locationManager.distanceFilter = 100; // meters
    [self.locationManager startMonitoringSignificantLocationChanges];
    
    
    
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray*)locations{
    
    CLLocation *location = [locations lastObject];
    self.currentLocation = location;
    NSLog(@"latitude %+.6f, latitute %+.6f\n",
          location.coordinate.latitude,
          location.coordinate.longitude);
    
    [[BuzzrdAPI current].venueService
     getVenuesNearby:location.coordinate
     success: ^(NSArray *theVenues) {
         NSLog(@"%d venue were loaded", theVenues.count);
         self.venues = theVenues;
         [self.tableView reloadData];
     }
     failure:^(NSError *error) {
         NSLog(@"%@", error);
     }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Venue"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Venue"];
    }
    cell.textLabel.text = [self.venues[indexPath.row] name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Venue *venue = self.venues[indexPath.row];
    Room *room = venue.rooms[0];
    UIViewController *roomViewController = [BuzzrdNav createRoomViewController:room];
    [self.navigationController pushViewController:roomViewController animated:YES];
}


-(void)addRoomTouch
{
    UIViewController *newRoomViewController = [BuzzrdNav createNewRoomViewController:^(Room *newRoom)
                                               {
                                                   [self addRoomToTable:newRoom];
                                               }];
    [self presentViewController:newRoomViewController animated:true completion:nil];
}

-(void)addRoomToTable:(Room *)room
{
    /*
    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.rooms];
    [temp insertObject:room atIndex:0];
    self.rooms = [NSArray arrayWithArray:temp];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    */
}

@end
