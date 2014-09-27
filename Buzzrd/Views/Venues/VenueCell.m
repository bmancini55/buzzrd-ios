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

@interface VenueCell()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UILabel *distanceLabel;

@property (strong, nonatomic) CALayer *bottomBorder;

@end

@implementation VenueCell

- (id)init
{
    self = [super init];
    if(self) {
        [self configure];
    }
    return self;        
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configure];
    }
    return self;
}

- (void) configure
{
    self.backgroundColor = [ThemeManager getPrimaryColorLight];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [ThemeManager getPrimaryFontRegular:17.0f];
    self.titleLabel.textColor = [ThemeManager getPrimaryColorDark];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.titleLabel];
    
    self.addressLabel = [[UILabel alloc]init];
    self.addressLabel.font = [ThemeManager getPrimaryFontMedium:9.0];
    self.addressLabel.textColor = [ThemeManager getPrimaryColorDark];
    self.addressLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.addressLabel];
    
    self.distanceLabel = [[UILabel alloc] init];
    self.distanceLabel.font = [ThemeManager getPrimaryFontRegular:11.0];
    self.distanceLabel.textColor = [ThemeManager getPrimaryColorDark];
    self.distanceLabel.textAlignment = NSTextAlignmentRight;
    self.distanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.distanceLabel];
    
    [self setConstraints];
}

- (void) setConstraints
{
    
    NSDictionary *views =
        @{
            @"title": self.titleLabel,
            @"address": self.addressLabel,
            @"distance": self.distanceLabel
          };
    
    // vertical spacing for the title from the top of the container
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[title]" options:0 metrics:nil views:views]];
    
    // vertical spacing for title and address, align them vertically on the left edge
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[title]-(-3)-[address]" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    
    // vertical spacing for address and bottom edge of container
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[address]-8-|" options:0 metrics:nil views:views]];
    
    // horizontal spacing for title
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[title]-6-|" options:0 metrics:nil views:views]];
    
    // horizontal spacing for distance to right container wall
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[distance]-12-|" options:0 metrics:nil views:views]];
    
    // horizontal spacing between address and distance, align them on the center
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[address]-6-[distance]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];    
}

- (void)setVenue:(Venue *)venue userLocation:(CLLocation *)userLocation
{
    self.venue = venue;
    
    // set title
    self.titleLabel.text = venue.name;
    
    // set address
    self.addressLabel.text = [self.venue.location prettyString];
    
    // set distance
    CLLocationDistance distance = [userLocation distanceFromLocation:venue.location.location];
    CGFloat distanceInFeet = distance / 1609.344 * 5280;
    if(distanceInFeet < 500)
        self.distanceLabel.text = [NSString stringWithFormat:@"%1.f ft", distanceInFeet];
    else
        self.distanceLabel.text = [NSString stringWithFormat:@"%.1f mi", distanceInFeet / 5280];
    
    [self addBorder];
}


- (CGFloat)calculateHeight
{
    CGFloat borderWidth = 0.5;
    CGFloat contentHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return contentHeight + borderWidth;
}

- (void)addBorder
{
    CGFloat borderWidth = 0.5;
    CGFloat originY = [self calculateHeight] - borderWidth;
    
    // create on new
    if(self.bottomBorder == nil) {
        self.bottomBorder = [CALayer layer];
        self.bottomBorder.backgroundColor = [ThemeManager getSecondaryColorDark].CGColor;
        [self.layer addSublayer:self.bottomBorder];
    }
    
    // adjust frame when reapplied
    self.bottomBorder.frame = CGRectMake(12, originY, self.frame.size.width - 24, borderWidth);
}

@end
