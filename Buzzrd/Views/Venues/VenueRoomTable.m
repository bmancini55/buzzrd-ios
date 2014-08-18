//
//  VenueRoomTable.m
//  Buzzrd
//
//  Created by Brian Mancini on 8/14/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "VenueRoomTable.h"
#import "VenueRoomCell.h"

@implementation VenueRoomTable

- (id)init
{
    self = [super init];
    if(self) {

        [self configure];
        
    }
    return self;
}

- (void) configure
{
    self.dataSource = self;
    self.delegate = self;
    self.scrollEnabled = false;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}


- (void)setRooms:(NSArray *)rooms
{
    _rooms = rooms;
    [self reloadData];
    
    CGRect frame = self.frame;
    frame.size.height = self.contentSize.height;
    self.frame = frame;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rooms.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Room *room = self.rooms[indexPath.row];
    VenueRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VenueRoom"];
    if(cell == nil) {
        cell = [[VenueRoomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VenueRoom"];
    }
    
    cell.room = room;    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Room *room = self.rooms[indexPath.row];
    VenueRoomCell *cell = [[VenueRoomCell alloc]init];
    [cell setRoom:room];
    
    CGFloat height = [cell calculateHeight];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    Room *room = self.rooms[indexPath.row];
    [self.roomTableDelegate roomSelected:room];
}

@end
