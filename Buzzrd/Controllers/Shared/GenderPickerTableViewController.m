//
//  GenderPickerTableViewController.m
//  Buzzrd
//
//  Created by Robert Beck on 5/26/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "GenderPickerTableViewController.h"

@interface GenderPickerTableViewController ()

@property (strong, nonatomic) NSArray *genders;

@end

@implementation GenderPickerTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.genders = [StaticData listOfGenders];
    
    // Remove the extra row separators
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.genders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    Gender *gender = self.genders[indexPath.row];
    
    NSString *genderString = [NSMutableString stringWithFormat:@"gender_%@", gender.idgender];
    
    cell.textLabel.text = NSLocalizedString(genderString, nil);
    
    if (gender.idgender == _selectedGenderId)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        [self.tableView selectRowAtIndexPath:indexPath
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionNone];
        [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    Gender *gender = self.genders[indexPath.row];
    
    _selectedGenderId = gender.idgender;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* uncheckCell = [tableView cellForRowAtIndexPath:indexPath];
    uncheckCell.accessoryType = UITableViewCellAccessoryNone;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[self delegate ] processGenderPickerSuccessful:_selectedGenderId];
}

@end
