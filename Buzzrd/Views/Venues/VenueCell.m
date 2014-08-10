//
//  VenueCell.m
//  Buzzrd
//
//  Created by Brian Mancini on 6/14/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "VenueCell.h"
#import "FrameUtils.h"
#import "ProfileImageView.h"
#import "ThemeManager.h"
#import "UIView+UIView_Borders.h"

@interface VenueCell()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) ProfileImageView *categoryImage;


@end

@implementation VenueCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        const int HEIGHT = 50;
        const int PADDING = 2;
        CGSize screenSize = [FrameUtils getScreenSize];
        CGRect viewFrame = CGRectMake(PADDING, PADDING, screenSize.width - 2 * PADDING, HEIGHT);
                
        self.backgroundColor = [ThemeManager getPrimaryColorMedium];
        [self addBottomBorder:[ThemeManager getSecondaryColorMedium] width:2.0];
        
        CGRect categoryImageFrame = CGRectMake(3, 3, 44, 44);
        self.categoryImage = [[ProfileImageView alloc]initWithFrame:categoryImageFrame];
        [self addSubview:self.categoryImage];
        
        CGRect titleFrame = CGRectMake(55, 10, viewFrame.size.width - 110, 30);
        self.titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
        self.titleLabel.font = [ThemeManager getPrimaryFontRegular:16.0f];
        self.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        
        CGRect distanceFrame = CGRectMake(viewFrame.size.width - 60, 12, 50, 30);
        self.distanceLabel = [[UILabel alloc] initWithFrame:distanceFrame];
        self.distanceLabel.font = [ThemeManager getPrimaryFontRegular:10.0];
        self.distanceLabel.textColor = [UIColor whiteColor];
        self.distanceLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.distanceLabel];
        
    }
    return self;
}

- (void)setVenue:(Venue *)venue userLocation:(CLLocation *)userLocation
{
    self.venue = venue;
    
    // set category image
    if(venue.categories.count > 0) {
        VenueCategory *primaryCategory = venue.categories[0];
        [self.categoryImage loadImage:[NSString stringWithFormat:@"%@%@%@", primaryCategory.iconPrefix, @"88", primaryCategory.iconSuffix]];
    }
    
    // set title
    self.titleLabel.text = venue.name;
    
    // set distance
    CLLocationDistance distance = [userLocation distanceFromLocation:venue.location.location];
    self.distanceLabel.text = [NSString stringWithFormat:@"%.1f km", distance / 1000];
}

@end
