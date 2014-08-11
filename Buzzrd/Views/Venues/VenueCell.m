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
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) ProfileImageView *categoryImage;

@property (strong, nonatomic) UILabel *userCountLabel;
@property (strong, nonatomic) UILabel *userLabel;
@property (strong, nonatomic) UILabel *lurkerCountLabel;
@property (strong, nonatomic) UILabel *lurkerLabel;

@end

@implementation VenueCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [ThemeManager getPrimaryColorMedium];
        [self addBottomBorder:[ThemeManager getSecondaryColorMedium] width:2.0];
        
        self.categoryImage = [[ProfileImageView alloc]init];
        self.categoryImage.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.categoryImage];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [ThemeManager getPrimaryFontRegular:16.0f];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.titleLabel];
        
        self.addressLabel = [[UILabel alloc]init];
        self.addressLabel.font = [ThemeManager getPrimaryFontMedium:7.0];
        self.addressLabel.textColor = [UIColor whiteColor];
        self.addressLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.addressLabel];
        
        self.distanceLabel = [[UILabel alloc] init];
        self.distanceLabel.font = [ThemeManager getPrimaryFontRegular:10.0];
        self.distanceLabel.textColor = [UIColor whiteColor];
        self.distanceLabel.textAlignment = NSTextAlignmentRight;
        self.distanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.distanceLabel];
        
        self.userCountLabel = [[UILabel alloc] init];
        self.userCountLabel.font = [ThemeManager getPrimaryFontBold:9.0];
        self.userCountLabel.textColor = [UIColor whiteColor];
        self.userCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.userCountLabel];

        self.userLabel = [[UILabel alloc] init];
        self.userLabel.font = [ThemeManager getPrimaryFontMedium:9.0];
        self.userLabel.textColor = [UIColor whiteColor];
        self.userLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.userLabel];
    }
    return self;
}

- (void) updateConstraints
{
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[image(44)]-12-[title]-6-|" options:0 metrics:nil views:@{ @"image": self.categoryImage, @"title": self.titleLabel }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[address]-6-[distance]-6-|" options:0 metrics:nil views:@{ @"address": self.addressLabel, @"distance": self.distanceLabel }]];
    
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[image(44)]" options:0 metrics:nil views:@{ @"image": self.categoryImage }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[title]" options:0 metrics:nil views:@{ @"title": self.titleLabel }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[title]-0-[address]" options:0 metrics:nil views:@{ @"title": self.titleLabel, @"address":                                                                                                                                                  self.addressLabel }]];

    // left align
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[title][address]" options:NSLayoutFormatAlignAllLeft metrics:nil views:@{ @"title": self.titleLabel, @"address": self.addressLabel }]];
    
    // top align
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[address][distance]" options:NSLayoutFormatAlignAllTop metrics:nil views:@{ @"address": self.addressLabel, @"distance": self.distanceLabel }]];
    
    
    
    [super updateConstraints];
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
    
    // set address
    self.addressLabel.text = @"Address goes here";
    
    // set distance
    CLLocationDistance distance = [userLocation distanceFromLocation:venue.location.location];
    self.distanceLabel.text = [NSString stringWithFormat:@"%.1f km", distance / 1000];
    
    [self updateConstraints];
    [self layoutIfNeeded];
}

@end
