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
    self.backgroundColor = [ThemeManager getPrimaryColorMedium];
    
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
    
    self.lurkerCountLabel = [[UILabel alloc] init];
    self.lurkerCountLabel.font = [ThemeManager getPrimaryFontBold:9.0];
    self.lurkerCountLabel.textColor = [UIColor whiteColor];
    self.lurkerCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.lurkerCountLabel];
    
    self.lurkerLabel = [[UILabel alloc] init];
    self.lurkerLabel.font = [ThemeManager getPrimaryFontMedium:9.0];
    self.lurkerLabel.textColor = [UIColor whiteColor];
    self.lurkerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.lurkerLabel];
}

- (void) updateConstraints
{
    // remove all constraints
    [self.contentView removeConstraints:self.contentView.constraints];
    
    // vertical spacing for the image from the top of the container
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[image(44)]" options:0 metrics:nil views:@{ @"image": self.categoryImage }]];
    
    // vertical spacing for the title from the top of the container
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[title]" options:0 metrics:nil views:@{ @"title": self.titleLabel }]];
    
    // vertical spacing for title and address, align them vertically on the left edge
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[title]-(-2)-[address]" options:NSLayoutFormatAlignAllLeft metrics:nil views:@{ @"title": self.titleLabel, @"address":                                                                                                                                                  self.addressLabel }]];
    
    // vertical spacing for address and user count, align them verticall on the left edge
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[address]-1-[usercount]" options:NSLayoutFormatAlignAllLeft metrics:nil views:@{ @"address":                                                                                                                                                  self.addressLabel, @"usercount": self.userCountLabel }]];
    
    // vertical spacing for user and lurker counts from the bottom of the container
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[usercount]-8-|" options:0 metrics:nil views:@{ @"usercount": self.userCountLabel }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[users]-8-|" options:0 metrics:nil views:@{ @"users": self.userLabel }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lurkercount]-8-|" options:0 metrics:nil views:@{ @"lurkercount": self.lurkerCountLabel }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lurkers]-8-|" options:0 metrics:nil views:@{ @"lurkers": self.lurkerLabel }]];
    

    // horizontal spacing for image and title
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[image(44)]-8-[title]-6-|" options:0 metrics:nil views:@{ @"image": self.categoryImage, @"title": self.titleLabel }]];
    
    // horizontal spacing for distance to right container wall
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[distance]-6-|" options:0 metrics:nil views:@{ @"distance": self.distanceLabel }]];
    
    // horizontal spacing between address and distance, align them on the center
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[address]-6-[distance]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{ @"address": self.addressLabel, @"distance": self.distanceLabel }]];
    
    // horizontal spacing for the user and lurker counts, align them on the top edge
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[usercount]-3-[users]-16-[lurkercount]-3-[lurkers]" options:NSLayoutFormatAlignAllTop metrics:nil views:@{ @"usercount": self.userCountLabel, @"users": self.userLabel, @"lurkercount": self.lurkerCountLabel, @"lurkers": self.lurkerLabel }]];
    
    
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
    self.addressLabel.text = [self.venue.location prettyString];
    
    // set distance
    CLLocationDistance distance = [userLocation distanceFromLocation:venue.location.location];
    CGFloat distanceInFeet = distance / 1609.344 * 5280;
    if(distanceInFeet < 500)
        self.distanceLabel.text = [NSString stringWithFormat:@"%1.f ft", distanceInFeet];
    else
        self.distanceLabel.text = [NSString stringWithFormat:@"%.1f mi", distanceInFeet / 5280];
    
    // set counts
    self.userCountLabel.text = [NSString stringWithFormat:@"%u", (uint)self.venue.userCount];
    self.userLabel.text = @"USERS";
    
    self.lurkerCountLabel.text = [NSString stringWithFormat:@"%u", (uint)self.venue.lurkerCount];
    self.lurkerLabel.text = @"LURKERS";
    
    [self updateConstraints];
    [self layoutIfNeeded];
    
    [self addBorder];
}

- (void)addBorder
{
    CGFloat width = 2.0;
    CGFloat height = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    // create on new
    if(self.bottomBorder == nil) {
        self.bottomBorder = [CALayer layer];
        self.bottomBorder.backgroundColor = [ThemeManager getSecondaryColorMedium].CGColor;
        [self.layer addSublayer:self.bottomBorder];
    }
    
    // adjust frame when reapplied
    self.bottomBorder.frame = CGRectMake(0, height, self.frame.size.width, width);
}

@end
