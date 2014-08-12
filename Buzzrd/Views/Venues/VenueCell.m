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
    
    
    // horizontal constraints
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[image(44)]-12-[title]-6-|" options:0 metrics:nil views:@{ @"image": self.categoryImage, @"title": self.titleLabel }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[distance]-6-|" options:0 metrics:nil views:@{ @"address": self.addressLabel, @"distance": self.distanceLabel }]];
    
    // vertical constraints
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[image(44)]" options:0 metrics:nil views:@{ @"image": self.categoryImage }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[title]" options:0 metrics:nil views:@{ @"title": self.titleLabel }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[title]-0-[address]" options:0 metrics:nil views:@{ @"title": self.titleLabel, @"address":                                                                                                                                                  self.addressLabel }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[address]-0-[usercount]" options:0 metrics:nil views:@{ @"address":                                                                                                                                                  self.addressLabel, @"usercount": self.userCountLabel }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[usercount]-6-|" options:0 metrics:nil views:@{ @"usercount": self.userCountLabel }]];

    // left align
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[title][address]" options:NSLayoutFormatAlignAllLeft metrics:nil views:@{ @"title": self.titleLabel, @"address": self.addressLabel }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[title][usercount]" options:NSLayoutFormatAlignAllLeft metrics:nil views:@{ @"title": self.titleLabel, @"usercount": self.userCountLabel }]];
    
    // top align
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[address][distance]" options:NSLayoutFormatAlignAllTop metrics:nil views:@{ @"address": self.addressLabel, @"distance": self.distanceLabel }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[usercount]-3-[users]" options:NSLayoutFormatAlignAllTop metrics:nil views:@{ @"usercount": self.userCountLabel, @"users": self.userLabel }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[users]-16-[lurkercount]" options:NSLayoutFormatAlignAllTop metrics:nil views:@{ @"users": self.userLabel, @"lurkercount": self.lurkerCountLabel }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[lurkercount]-3-[lurkers]" options:NSLayoutFormatAlignAllTop metrics:nil views:@{ @"lurkercount": self.lurkerCountLabel, @"lurkers": self.lurkerLabel }]];
    
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
    
    // set counts
    self.userCountLabel.text = [NSString stringWithFormat:@"%u", (uint)5];
    self.userLabel.text = @"USERS";
    
    self.lurkerCountLabel.text = [NSString stringWithFormat:@"%u", (uint)0];
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
