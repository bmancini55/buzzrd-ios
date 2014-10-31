//
//  CreateFriendViewController.m
//  Buzzrd
//
//  Created by Robert Beck on 10/9/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "CreateFriendViewController.h"
#import "ThemeManager.h"
#import "TableSectionHeader.h"
#import "UserCell.h"
#import "GetPotentialFriendsCommand.h"
#import "BuzzrdAPI.h"
#import "CreateFriendCommand.h"

@interface CreateFriendViewController ()

@property (strong, nonatomic) NSArray *users;
@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) UISearchDisplayController *tempSearchController;
@property dispatch_source_t timer;

@end

@implementation CreateFriendViewController

-(id)initWithCallback:(void (^)(User *created))onFriendCreated
{
    self = [self initWithStyle:UITableViewStyleGrouped];
    if(self != nil)
    {
        self.onFriendCreated = onFriendCreated;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.title = NSLocalizedString(@"Add Friend", nil);
    self.tableView.backgroundColor = [ThemeManager getPrimaryColorLight];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancelTouch)];
    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(tableViewWillRefresh) forControlEvents:UIControlEventValueChanged];
    
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.barTintColor = [ThemeManager getPrimaryColorLight];
    self.tempSearchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.delegate = self;
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = searchBar;
    
    [self.refreshControl beginRefreshing];
}

- (void)tableViewWillRefresh
{
}

- (void) loadUsersForTable:(UITableView *)tableView withSearch:(NSString *)search
{
    GetPotentialFriendsCommand *command = [[GetPotentialFriendsCommand alloc] init];
    command.search = search;
    [command listenForCompletion:self selector:@selector(usersDidLoad:)];
    [[BuzzrdAPI dispatch] enqueueCommand:command];
}

- (void)usersDidLoad:(NSNotification *) notif
{
    [self.refreshControl endRefreshing];
    
    GetPotentialFriendsCommand *command = notif.object;
    NSArray *users = command.results;
    
    if(command.search == nil) {
        self.users = users;
        [self.tableView reloadData];
    } else {
        self.searchResults = users;
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}

-(void)onCancelTouch {
    [self dismissViewControllerAnimated:true completion:nil];
}

// Helper function that retrieves a data source for the specified table view
- (NSArray *) dataSourceForTableView:(UITableView *)tableView
{
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return self.searchResults;
    }
    else {
        return self.users;
    }
}

// Helper function that retrieves a value for a tableview and index path
- (User *)userForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSArray *dataSource = [self dataSourceForTableView:tableView];
    return (User *)dataSource[indexPath.row];
}

#pragma mark - Table view data source


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = CGRectMake(0, 0, tableView.frame.size.width, 30);
    TableSectionHeader *headerView = [[TableSectionHeader alloc]initWithFrame:frame];
    headerView.titleText = [NSLocalizedString(@"Select Friend", nil) uppercaseString];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *dataSource = [self dataSourceForTableView:tableView];
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"choose_user_cell";
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    // construct a new cell
    if(cell == nil)
    {
        cell = [[UserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    User *user = [self userForTableView:tableView indexPath:indexPath];
    [cell setUser: user];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    
    User *user = [self userForTableView:tableView indexPath:indexPath];
    
    CreateFriendCommand *command = [[CreateFriendCommand alloc]init];
    command.user = user;
    [command listenForCompletion:self selector:@selector(createFriendDidComplete:)];
    [[BuzzrdAPI dispatch] enqueueCommand:command];
}

- (void)createFriendDidComplete:(NSNotification *)info
{
    CreateFriendCommand *command = (CreateFriendCommand *)info.object;
    if(command.status == kSuccess) {
        
        [self dismissViewControllerAnimated:true completion:^{
            self.onFriendCreated(command.user);
        }];
    }
    else
    {
        [self showRetryAlertWithTitle:NSLocalizedString(@"Unexpected Error", nil)
                              message:NSLocalizedString(@"An unexpected error occurred while processing your request", nil)
                       retryOperation:command];
    }
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
        [self loadUsersForTable:self.searchDisplayController.searchResultsTableView withSearch:searchString];
    });
    
    
    return false;
}

@end
