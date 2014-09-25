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
@property dispatch_source_t timer;

@end

@implementation NearbyRoomsViewController

- (void)loadView
{
    [super loadView];
    
    self.title = NSLocalizedString(@"nearby_rooms", nil);
    
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

#pragma mark - Search display delegate

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    return false;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    float interval = 0.75;
    
    if(!self.timer) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_resume(timer);
        self.timer = timer;
    }
    
    dispatch_source_t timer = self.timer;
    dispatch_source_set_timer(timer, dispatch_walltime(DISPATCH_TIME_NOW, NSEC_PER_SEC * interval), interval * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        dispatch_source_cancel(self.timer);
        self.timer = nil;
        [self loadRoomsWithSearch:searchString];
    });
    
    
    return false;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    [self attachFooterToTableView:tableView];
}

@end
