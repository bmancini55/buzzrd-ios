//
//  OptionalInfoView.m
//  Buzzrd
//
//  Created by Robert Beck on 5/22/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "OptionalInfoView.h"

@implementation OptionalInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *optionalInfoLbl = [ [UILabel alloc] initWithFrame:CGRectMake(0,100,self.frame.size.width,20)];
        [optionalInfoLbl setText:NSLocalizedString(@"optional_info", nil)];
        optionalInfoLbl.textAlignment = NSTextAlignmentCenter;
        optionalInfoLbl.font = [UIFont boldSystemFontOfSize:17.0];
        [self addSubview:optionalInfoLbl];
        
        CGFloat x = 0;
        CGFloat y = 50;
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height - 50;
        CGRect tableFrame = CGRectMake(x, y, width, height);
        
        _tableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
        _tableView.rowHeight = 45;
        _tableView.sectionFooterHeight = 22;
        _tableView.sectionHeaderHeight = 22;
        _tableView.scrollEnabled = YES;
        _tableView.showsVerticalScrollIndicator = YES;
        _tableView.userInteractionEnabled = YES;
        _tableView.bounces = YES;
        [self addSubview:_tableView];
        
        UITableViewCell *shareCell = [[UITableViewCell alloc]init];
        shareCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];
        shareCell.textLabel.text = @"Share with Friends";
        shareCell.textLabel.font = [UIFont systemFontOfSize:17];
        shareCell.textLabel.textColor = [UIColor colorWithRed:136.0f/255.0f green:51.0f/255.0f blue:97.0f/255.0f alpha:1.0];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1; //[your array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    // Configure the cell...
    cell.textLabel.text = @"asdf";
    
    return cell;
}

@end
