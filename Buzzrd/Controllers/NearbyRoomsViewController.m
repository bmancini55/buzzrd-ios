//
//  NearbyRoomsViewController.m
//  Buzzrd
//
//  Created by Brian Mancini on 9/15/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "NearbyRoomsViewController.h"
#import "BuzzrdAPI.h"
#import "GetNearbyRoomsCommand.h"
#import "ThemeManager.h"

@interface NearbyRoomsViewController ()

@property (strong, nonatomic) UISearchDisplayController *tempSearchController;

@end

@implementation NearbyRoomsViewController

- (void)loadView
{
    [super loadView];
    
    self.title = NSLocalizedString(@"nearby", nil);
    
    self.sectionHeaderTitle = NSLocalizedString(@"nearby_rooms", nil);
    
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.barTintColor = [ThemeManager getPrimaryColorLight];
    self.tempSearchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.delegate = self;
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = searchBar;
}

- (void)loadRoomsWithSearch:(NSString *)search
{
    GetNearbyRoomsCommand *command = [[GetNearbyRoomsCommand alloc] init];
    command.location = self.location.coordinate;
    command.search = search;
    [command listenForCompletion:self selector:NSSelectorFromString(@"roomsDidLoad:")];
    [[BuzzrdAPI dispatch] enqueueCommand:command];
}

@end
