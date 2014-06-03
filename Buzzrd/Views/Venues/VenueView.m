//
//  VenueView.m
//  Buzzrd
//
//  Created by Brian Mancini on 6/2/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "VenueView.h"
#import "FrameUtils.h"
#import "ProfileImageView.h"

@interface VenueView()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) ProfileImageView *categoryImage;

@end

@implementation VenueView

- (id)initWithVenue:(Venue *)venue userLocation:(CLLocation *)userLocation;
{
    const int HEIGHT = 50;
    const int PADDING = 2;
    CGSize screenSize = [FrameUtils getScreenSize];
    CGRect viewFrame = CGRectMake(PADDING, PADDING, screenSize.width - 2 * PADDING, HEIGHT);
    
    self = [super initWithFrame:viewFrame];
    if(self) {
        
        self.backgroundColor = [[UIColor alloc]initWithRed:241.0f/255.0f green:178.0f/255.0f blue:69.0f/255.0f alpha:1.0f];
        
        if(venue.categories.count > 0) {
            VenueCategory *primaryCategory = venue.categories[0];
            self.categoryImage = [[ProfileImageView alloc]initWithFrame:CGRectMake(3, 3, 44, 44)];
            [self.categoryImage loadImage:[NSString stringWithFormat:@"%@%@%@", primaryCategory.iconPrefix, @"88", primaryCategory.iconSuffix]];
            [self addSubview:self.categoryImage];
        }
        
        CGRect titleFrame = CGRectMake(55, 10, viewFrame.size.width - 110, 30);
        self.titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
        self.titleLabel.text = venue.name;
        [self addSubview:self.titleLabel];
        
        
        CLLocationDistance distance = [userLocation distanceFromLocation:venue.location.location];
        CGRect distanceFrame = CGRectMake(viewFrame.size.width - 60, 12, 50, 30);
        self.distanceLabel = [[UILabel alloc] initWithFrame:distanceFrame];
        self.distanceLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        self.distanceLabel.textAlignment = NSTextAlignmentRight;
        self.distanceLabel.text = [NSString stringWithFormat:@"%.1f km", distance / 1000];
        [self addSubview:self.distanceLabel];
    }
    return self;
}



@end
