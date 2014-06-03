//
//  VenueRoomCell.m
//  Buzzrd
//
//  Created by Brian Mancini on 6/3/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "VenueRoomCell.h"

@interface VenueRoomCell()

@end

@implementation VenueRoomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.roomView = [[VenueRoomView alloc]init];
        [self addSubview:self.roomView];
    }
    return self;
}

@end
