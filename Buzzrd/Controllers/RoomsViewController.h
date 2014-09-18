//
//  RoomsViewController.h
//  Buzzrd
//
//  Created by Robert Beck on 9/17/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "BaseTableViewController.h"
#import "GetLocationCommand.h"

@interface RoomsViewController : BaseTableViewController

@property (strong, nonatomic) NSArray *rooms;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *sectionHeaderTitle;

@property (strong, nonatomic) NSArray *searchResults;

- (void)loadRoomsWithSearch:(NSString *)search;

@end
