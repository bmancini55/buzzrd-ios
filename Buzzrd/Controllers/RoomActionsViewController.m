//
//  RoomActionsViewController.m
//  Buzzrd
//
//  Created by Robert Beck on 10/24/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "RoomActionsViewController.h"
#import "ThemeManager.h"

@interface RoomActionsViewController ()

@end

@implementation RoomActionsViewController

-(id)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

-(void)loadView
{
    [super loadView];
    
    [self.view setBackgroundColor: [ThemeManager getPrimaryColorLight]];
    
    self.title = NSLocalizedString(@"Blah Blah Blah", nil);
    
    // Remove the extra row separators
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [NSString stringWithFormat:@"%d%d",(int)indexPath.section,(int)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [ThemeManager getPrimaryFontRegular:16.0];
        cell.textLabel.textColor = [ThemeManager getPrimaryColorDark];
        cell.contentView.backgroundColor=[ThemeManager getPrimaryColorLight];
        cell.backgroundColor = [ThemeManager getPrimaryColorLight];
        
        if(indexPath.section == 0) {
            switch (indexPath.row ) {
                case 0: {
                    cell.textLabel.text = NSLocalizedString(@"Update Profile", nil);
                    
                    break ;
                }
                case 1: {
                    cell.textLabel.text = NSLocalizedString(@"Buzzrd Disclaimers", nil);
                    
                    break ;
                }
                case 2: {
                    cell.textLabel.text = NSLocalizedString(@"Log Out", nil);
                    break ;
                }
            }
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

@end
