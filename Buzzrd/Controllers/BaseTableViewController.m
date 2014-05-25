//
//  BaseTableViewController.m
//  Buzzrd
//
//  Created by Brian Mancini on 5/17/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@property UITableViewStyle tableStyle;

@end

@implementation BaseTableViewController

-(id)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

-(id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if(self != nil)
    {
        self.tableStyle = style;
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    
    // construct the table view
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:self.tableStyle];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}

@end
