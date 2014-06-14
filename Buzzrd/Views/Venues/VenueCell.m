//
//  VenueCell.m
//  Buzzrd
//
//  Created by Brian Mancini on 6/14/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "VenueCell.h"
#import "VenueView.h"

@interface VenueCell()

@property (strong, nonatomic) VenueView *venueView;

@end

@implementation VenueCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.venueView = [[VenueView alloc]init];        
        [self addSubview:self.venueView];
        
    }
    return self;
}

- (void)setVenue:(Venue *)venue userLocation:(CLLocation *)userLocation
{
    [self.venueView setVenue:venue userLocation:userLocation];
}

@end
