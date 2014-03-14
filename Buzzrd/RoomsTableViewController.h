//
//  RoomsTableViewController.h
//  FizBuz
//
//  Created by Brian Mancini on 3/9/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RoomsTableViewController : UITableViewController <CLLocationManagerDelegate>

@property NSArray *rooms;
@property CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end
