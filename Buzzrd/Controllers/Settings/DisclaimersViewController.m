//
//  DisclaimersViewController.m
//  Buzzrd
//
//  Created by Robert Beck on 8/24/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "DisclaimersViewController.h"
#import "ThemeManager.h"
#import "AccessoryIndicatorView.h"
#import "PrivacyPolicyViewController.h"
#import "TermsOfServiceViewController.h"

@interface DisclaimersViewController ()

@end

@implementation DisclaimersViewController

-(id)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

-(void)loadView
{
    [super loadView];
    
    [self.view setBackgroundColor: [ThemeManager getPrimaryColorLight]];
    
    self.title = NSLocalizedString(@"Disclaimers", nil);
    
    // Remove the extra row separators
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
                    cell.textLabel.text = NSLocalizedString(@"Privacy Policy", nil);
                    break ;
                }
                case 1: {
                    cell.textLabel.text = NSLocalizedString(@"Terms of Service", nil);
                    break ;
                }
            }
        }
        
        cell.accessoryView = [[AccessoryIndicatorView alloc] initWithFrame:CGRectMake(cell.frame.size.width - ACCESSORY_WIDTH - CELL_PADDING, cell.frame.size.height/2 - ACCESSORY_HEIGHT/2, ACCESSORY_WIDTH, ACCESSORY_HEIGHT)];

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // 01 is the privacy policy cell
    if ([cell.reuseIdentifier isEqual: @"00"])
    {
        PrivacyPolicyViewController *viewController = [[PrivacyPolicyViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    // 02 is the privacy policy cell
    else if ([cell.reuseIdentifier isEqual: @"01"])
    {
        TermsOfServiceViewController *viewController = [[TermsOfServiceViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
