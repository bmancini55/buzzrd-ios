//
//  RoomsTableViewController.h
//  FizBuz
//
//  Created by Brian Mancini on 3/9/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Room.h"

@interface RoomsViewController : UITableViewController <CLLocationManagerDelegate>

@property NSArray *rooms;
@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

-(IBAction)unwindFromNewRoom:(UIStoryboardSegue*)segue;

-(void)addRoomToTable:(Room *)room;

@end
