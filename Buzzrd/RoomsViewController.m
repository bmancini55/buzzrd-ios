//
//  RoomsTableViewController.m
//  Buzzrd
//
//  Created by Brian Mancini on 3/9/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "Room.h"
#import "BuzzrdAPI.h"
#import "RoomsViewController.h"
#import "RoomViewController.h"
#import "NewRoomViewController.h"

@implementation RoomsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Rooms";
        self.tabBarItem.title = @"Rooms";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.spinner startAnimating];
    
    if(self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    self.locationManager.delegate = self;
    //self.locationManager.desiredAccuracy = kCLDistanceFilterNone;
    //self.locationManager.distanceFilter = 100; // meters
    [self.locationManager startMonitoringSignificantLocationChanges];    
    
    
    
    [[BuzzrdAPI current].roomService getRooms:^(NSArray *theRooms) {
        
        NSLog(@"Rooms have loaded");
        
        self.rooms = theRooms;
        [self.tableView reloadData];
        
        [self.spinner stopAnimating];
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray*)locations{
    
    CLLocation *location = [locations lastObject];
    self.currentLocation = location;
    NSLog(@"latitude %+.6f, latitute %+.6f\n",
    location.coordinate.latitude,
    location.coordinate.longitude);
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
    return self.rooms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Room"];
    cell.textLabel.text = [self.rooms[indexPath.row] name];    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RoomViewController *roomViewController = [[RoomViewController alloc] init];
    roomViewController.hidesBottomBarWhenPushed=YES;
    roomViewController.room = self.rooms[indexPath.row];
    
    [self.navigationController pushViewController:roomViewController animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"AddRoom"])
    {
        UINavigationController *navController = segue.destinationViewController;
        NewRoomViewController *newRoomViewController = (NewRoomViewController *)navController.topViewController;
        newRoomViewController.currentLocation = self.currentLocation;
    }
}

-(IBAction)unwindFromNewRoom:(UIStoryboardSegue*)segue
{
    if([segue.identifier isEqualToString:@"CreateRoom"])
    {
        NewRoomViewController *newRoomViewController = segue.sourceViewController;
        Room *room = newRoomViewController.room;
        NSLog(@"Creating room called %@ at lon %@ and lat %@", room.name, room.lon, room.lat);
        
        [[BuzzrdAPI current].roomService createRoom:room
                       callback:^(Room* createdRoom){
                           [self addRoomToTable:createdRoom];
                           NSLog(@"Created room: %@", createdRoom.idroom);
                       }];
        
    }
}

-(void)addRoomToTable:(Room *)room
{
    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.rooms];
    [temp insertObject:room atIndex:0];
    self.rooms = [NSArray arrayWithArray:temp];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
