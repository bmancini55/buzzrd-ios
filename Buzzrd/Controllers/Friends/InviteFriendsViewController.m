//
//  InviteFriendsViewController.m
//  Buzzrd
//
//  Created by Robert Beck on 10/28/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "GetFriendsCommand.h"
#import "BuzzrdAPI.h"
#import "UserCell.h"
#import "TableSectionHeader.h"
#import "BuzzrdNav.h"
#import "InviteFriendsCommand.h"

@interface InviteFriendsViewController ()

@property (strong, nonatomic) NSMutableDictionary *selectedUsers;

@end

@implementation InviteFriendsViewController

- (void)loadView
{
    [super loadView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.title = NSLocalizedString(@"Invite Friends", nil);
    self.sectionHeaderTitle = [NSLocalizedString(@"Friends", nil) uppercaseString];
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                     style:UIBarButtonItemStylePlain target:self action:@selector(doneTouch)];
    
    self.navigationItem.rightBarButtonItem = doneItem;
    
    self.tableView.allowsMultipleSelection = YES;
    
    self.selectedUsers = [[NSMutableDictionary alloc] init];
    
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
    return 55;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *dataSource =  [self dataSourceForTableView:tableView];
    User *friend = dataSource[indexPath.row];
    
    static NSString *cellIdentifier = @"friend_cell";
    
    UserCell *cell = (UserCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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

#pragma mark - controller interaction methods

// Helper function that retrieves a value for a tableview and index path
- (User *)userForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *dataSource = [self dataSourceForTableView:tableView];
    return (User *)dataSource[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    
    User *user = [self userForTableView:tableView indexPath:indexPath];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        // Reflect selection in data model
        
        [self.selectedUsers setObject:user forKey:user.iduser];
        
    } else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        // Reflect deselection in data model
        
        [self.selectedUsers removeObjectForKey:user.iduser];
    }
}

-(void) doneTouch
{
    
    InviteFriendsCommand *command = [[InviteFriendsCommand alloc]init];
    command.room = self.room;
    command.users = self.selectedUsers;
    
    [command listenForCompletion:self selector:@selector(inviteFriendsDidComplete:)];
    [[BuzzrdAPI dispatch] enqueueCommand:command];
}

- (void)inviteFriendsDidComplete:(NSNotification *)info
{
    InviteFriendsCommand *command = (InviteFriendsCommand *)info.object;
    if(command.status == kSuccess) {
        [[self navigationController] popViewControllerAnimated:YES];
    }
    else
    {
        [self showRetryAlertWithTitle:NSLocalizedString(@"Unexpected Error", nil)
                              message:NSLocalizedString(@"An unexpected error occurred while processing your request", nil)
                       retryOperation:command];
    }
}

@end
