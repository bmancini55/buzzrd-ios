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

@property (strong, nonatomic) NSString *emptyNote;
@property (strong, nonatomic) NSMutableArray *rooms;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *sectionHeaderTitle;

@property (strong, nonatomic) NSMutableArray *searchResults;

- (void)didTouchAddRoom;
- (void)loadRoomsWithSearch:(NSString *)search;
- (NSMutableArray *) dataSourceForTableView:(UITableView *)tableView;
- (void)attachFooterToTableView:(UITableView *)tableView;

@end
