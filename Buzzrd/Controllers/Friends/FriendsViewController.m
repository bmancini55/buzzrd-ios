//
//  FriendsViewController.m
//  Buzzrd
//
//  Created by Robert Beck on 10/9/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "FriendsViewController.h"
#import "GetFriendsCommand.h"
#import "BuzzrdAPI.h"
#import "UserCell.h"
#import "TableSectionHeader.h"
#import "BuzzrdNav.h"
#import "CreateFriendViewController.h"
#import "RemoveFriendCommand.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

- (void)loadView
{
    [super loadView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.title = NSLocalizedString(@"Friends", nil);
    self.navigationController.title = [NSLocalizedString(@"Friends", nil) uppercaseString];
    self.sectionHeaderTitle = [NSLocalizedString(@"Friends", nil) uppercaseString];
    
    UIBarButtonItem *addFriendItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriendTouch)];
    self.navigationItem.rightBarButtonItem = addFriendItem;
    
    UIBarButtonItem *settingsItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Settings.png"] style:UIBarButtonItemStylePlain target:self action:@selector(settingsTouch)];
    self.navigationItem.leftBarButtonItem = settingsItem;
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    [self loadFriends];
}

- (void)loadFriends
{
    GetFriendsCommand *command = [[GetFriendsCommand alloc] init];

    [command listenForCompletion:self selector:NSSelectorFromString(@"friendsDidLoad:")];
    [[BuzzrdAPI dispatch] enqueueCommand:command];
}

- (void)friendsDidLoad:(NSNotification *) notif
{
    GetFriendsCommand *command = notif.object;
    NSMutableArray *friends = command.results;
    
    [self.refreshControl endRefreshing];
    
    self.friends = friends;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

// Helper function that retrieves a data source for the specified table view
- (NSMutableArray *) dataSourceForTableView:(UITableView *)tableView
{
    return self.friends;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *dataSource =  [self dataSourceForTableView:tableView];
    return dataSource.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // No need to calculate these, lets just hardcode it
    return 30;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *dataSource =  [self dataSourceForTableView:tableView];
    User *friend = dataSource[indexPath.row];
    
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friend_cell"];
    if(cell == nil)
    {
        cell = [[UserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friend_cell"];
    }
    
    [cell setUser:friend];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = CGRectMake(0, 0, tableView.frame.size.width, 30);
    TableSectionHeader *headerView = [[TableSectionHeader alloc]initWithFrame:frame];
    headerView.titleText = self.sectionHeaderTitle;
    return headerView;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - controller interaction methods

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        User *user = [self userForTableView:self.tableView indexPath:indexPath];
        
        RemoveFriendCommand *command = [[RemoveFriendCommand alloc]init];
        command.user = user;
        command.indexPath = indexPath;
        [command listenForCompletion:self selector:@selector(removeFriendDidComplete:)];
        [[BuzzrdAPI dispatch] enqueueCommand:command];
    }
}

// Helper function that retrieves a value for a tableview and index path
- (User *)userForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *dataSource = [self dataSourceForTableView:tableView];
    return (User *)dataSource[indexPath.row];
}

- (void)removeFriendDidComplete:(NSNotification *)info
{
    RemoveFriendCommand *command = (RemoveFriendCommand *)info.object;
    if(command.status == kSuccess) {
        [self.friends removeObjectAtIndex:command.indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[command.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else
    {
        [self showRetryAlertWithTitle:NSLocalizedString(@"Unexpected Error", nil)
                              message:NSLocalizedString(@"An unexpected error occurred while processing your request", nil)
                       retryOperation:command];
    }
}

- (void) settingsTouch
{
    UIViewController *viewController = [BuzzrdNav createSettingsController];
    viewController.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:viewController animated:true];
}

-(void)addFriendTouch
{
    CreateFriendViewController *viewController = [[CreateFriendViewController alloc] initWithStyle:UITableViewStyleGrouped];
    viewController.onFriendCreated = ^(User *newFriend)
         {
             [self addFriendToTable:newFriend];
         };
    
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:viewController];
    
    [self presentViewController:navController animated:true completion:nil];
}

-(void)addFriendToTable:(User *)friend
{
    // insert friend
    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.friends];
    [temp insertObject:friend atIndex:0];
    self.friends = [NSMutableArray arrayWithArray:temp];
    
    // insert the friend cell
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:false];
}

@end
