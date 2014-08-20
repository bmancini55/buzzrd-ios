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
#import "VenueRoomTable.h"

@interface VenueCell()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) ProfileImageView *categoryImage;

@property (strong, nonatomic) UILabel *userCountLabel;
@property (strong, nonatomic) UILabel *userLabel;
@property (strong, nonatomic) UILabel *lurkerCountLabel;
@property (strong, nonatomic) UILabel *lurkerLabel;

@property (strong, nonatomic) VenueRoomTable *roomsTable;

@property (strong, nonatomic) UIImageView *subroomArrow;
@property (strong, nonatomic) UILabel *subroomCountLabel;
@property (strong, nonatomic) UILabel *subroomsLabel;

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
    self.showCounts = true;
    
    self.categoryImage = [[ProfileImageView alloc]init];
    self.categoryImage.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.categoryImage];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [ThemeManager getPrimaryFontRegular:17.0f];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.titleLabel];
    
    self.addressLabel = [[UILabel alloc]init];
    self.addressLabel.font = [ThemeManager getPrimaryFontMedium:9.0];
    self.addressLabel.textColor = [UIColor whiteColor];
    self.addressLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.addressLabel];
    
    self.distanceLabel = [[UILabel alloc] init];
    self.distanceLabel.font = [ThemeManager getPrimaryFontRegular:11.0];
    self.distanceLabel.textColor = [UIColor whiteColor];
    self.distanceLabel.textAlignment = NSTextAlignmentRight;
    self.distanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.distanceLabel];
    
    self.userCountLabel = [[UILabel alloc] init];
    self.userCountLabel.font = [ThemeManager getPrimaryFontBold:10.0];
    self.userCountLabel.textColor = [UIColor whiteColor];
    self.userCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.userCountLabel];
    
    self.userLabel = [[UILabel alloc] init];
    self.userLabel.font = [ThemeManager getPrimaryFontMedium:10.0];
    self.userLabel.textColor = [UIColor whiteColor];
    self.userLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.userLabel];
    
    self.lurkerCountLabel = [[UILabel alloc] init];
    self.lurkerCountLabel.font = [ThemeManager getPrimaryFontBold:10.0];
    self.lurkerCountLabel.textColor = [UIColor whiteColor];
    self.lurkerCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.lurkerCountLabel];
    
    self.lurkerLabel = [[UILabel alloc] init];
    self.lurkerLabel.font = [ThemeManager getPrimaryFontMedium:10.0];
    self.lurkerLabel.textColor = [UIColor whiteColor];
    self.lurkerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.lurkerLabel];
    
    self.roomsTable = [[VenueRoomTable alloc]init];
    self.roomsTable.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.roomsTable];
    
    self.subroomArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SubRooms.png"]];
    self.subroomArrow.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.subroomArrow];
    
    self.subroomCountLabel = [[UILabel alloc]init];
    self.subroomCountLabel.font = [ThemeManager getPrimaryFontBold:18.0];
    self.subroomCountLabel.textColor = [UIColor whiteColor];
    self.subroomCountLabel.textAlignment = NSTextAlignmentCenter;
    self.subroomCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.subroomCountLabel];
    
    self.subroomsLabel = [[UILabel alloc]init];
    self.subroomsLabel.font = [ThemeManager getPrimaryFontMedium:10.0];
    self.subroomsLabel.textColor = [UIColor whiteColor];
    self.subroomsLabel.textAlignment = NSTextAlignmentCenter;
    self.subroomsLabel.numberOfLines = 2;
    self.subroomsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.subroomsLabel];
}

- (void) updateConstraints
{
    // remove all constraints
    [self.contentView removeConstraints:self.contentView.constraints];
    
    if(self.showCounts) {
        
        // vertical spacing for the image from the top of the container
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[image(44)]" options:0 metrics:nil views:@{ @"image": self.categoryImage }]];
        
    } else {
        
        // vertical spacing for the image from the top of the container
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[image(44)]" options:0 metrics:nil views:@{ @"image": self.categoryImage }]];
        
    }

    
    // vertical spacing for the title from the top of the container
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[title]" options:0 metrics:nil views:@{ @"title": self.titleLabel }]];
    
    // vertical spacing for title and address, align them vertically on the left edge
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[title]-(-1)-[address]" options:NSLayoutFormatAlignAllLeft metrics:nil views:@{ @"title": self.titleLabel, @"address":                                                                                                                                                  self.addressLabel }]];
    
    
    if(self.showCounts) {
    
        // vertical spacing for address and user count, align them verticall on the left edge
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[address]-2-[usercount]" options:NSLayoutFormatAlignAllLeft metrics:nil views:@{ @"address":                                                                                                                                                  self.addressLabel, @"usercount": self.userCountLabel }]];
        
        if(self.venue.roomCount <= 1) {
            
            // vertical spacing for user and lurker counts from the bottom of the container
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[usercount]-8-|" options:0 metrics:nil views:@{ @"usercount": self.userCountLabel }]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[users]-8-|" options:0 metrics:nil views:@{ @"users": self.userLabel }]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lurkercount]-8-|" options:0 metrics:nil views:@{ @"lurkercount": self.lurkerCountLabel }]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lurkers]-8-|" options:0 metrics:nil views:@{ @"lurkers": self.lurkerLabel }]];
            
        } else {
        
            // vertical spacing for user and lurker counts from the bottom of the container
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[usercount]-6@500-[roomtable]" options:NSLayoutFormatAlignAllLeft metrics:nil views:@{ @"usercount": self.userCountLabel, @"roomtable": self.roomsTable }]];

            // vertical spacing for table
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[roomtable(==height)]-0-|" options:0 metrics:@{ @"height":[NSNumber numberWithFloat:self.roomsTable.frame.size.height] } views:@{ @"roomtable": self.roomsTable }]];
        
            // horizontal spacing for table
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[roomtable]-0-|" options:0 metrics:nil views:@{ @"roomtable": self.roomsTable }]];
            
            // horizontal spacing for arrow
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-22-[arrow(17)]-(>=12)-[roomtable]" options:NSLayoutFormatAlignAllTop metrics:nil views:@{ @"arrow": self.subroomArrow, @"roomtable": self.roomsTable } ]];
            
            // vertical spacing for subroom counts
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[arrow]-2-[count]-(-2)-[label]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{ @"arrow": self.subroomArrow, @"count": self.subroomCountLabel, @"label": self.subroomsLabel }]];
            
        }
        
    } else {
        
        // vertical spacing for address and bottom edge of container
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[address]-8-|" options:0 metrics:nil views:@{ @"address": self.addressLabel }]];
        
    }
    

    // horizontal spacing for image and title
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[image(44)]-8-[title]-6-|" options:0 metrics:nil views:@{ @"image": self.categoryImage, @"title": self.titleLabel }]];
    
    // horizontal spacing for distance to right container wall
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[distance]-6-|" options:0 metrics:nil views:@{ @"distance": self.distanceLabel }]];
    
    // horizontal spacing between address and distance, align them on the center
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[address]-6-[distance]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{ @"address": self.addressLabel, @"distance": self.distanceLabel }]];
    
    if(self.showCounts) {
    
        // horizontal spacing for the user and lurker counts, align them on the top edge
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[usercount]-3-[users]-16-[lurkercount]-3-[lurkers]" options:NSLayoutFormatAlignAllTop metrics:nil views:@{ @"usercount": self.userCountLabel, @"users": self.userLabel, @"lurkercount": self.lurkerCountLabel, @"lurkers": self.lurkerLabel }]];
        
    }
    
    [super updateConstraints];
}

- (void)setRoomTableDelegate:(id<VenueRoomTableDelegate>)roomTableDelegate
{
    _roomTableDelegate = roomTableDelegate;
    self.roomsTable.roomTableDelegate = roomTableDelegate;
}

- (void)setVenue:(Venue *)venue userLocation:(CLLocation *)userLocation
{
    self.venue = venue;
    
    // configure the rooms
    if(venue.roomCount > 1) {
        self.roomsTable.hidden = false;
        [self.roomsTable setRooms:venue.rooms];
        
        self.subroomArrow.hidden = false;
        self.subroomCountLabel.hidden = false;
        self.subroomsLabel.hidden = false;
        
    } else {
        self.roomsTable.hidden = true;
        [self.roomsTable setRooms:nil];
        
        self.subroomArrow.hidden = true;
        self.subroomCountLabel.hidden = true;
        self.subroomsLabel.hidden = true;
    }
    

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
    
    // set subrooms
    self.subroomsLabel.text = [NSString stringWithFormat:@"%@\r%@", NSLocalizedString(@"SUB", nil), NSLocalizedString(@"ROOMS", nil)];
    self.subroomCountLabel.text = [NSString stringWithFormat:@"%u", (uint)venue.roomCount];
    
    [self updateConstraints];
    
    [self addBorder];
}

- (void)setShowCounts:(bool)showCounts
{
    _showCounts = showCounts;
    
    self.userCountLabel.hidden = true;
    self.userLabel.hidden = true;
    self.lurkerCountLabel.hidden = true;
    self.lurkerLabel.hidden = true;
}


- (CGFloat)calculateHeight
{
    CGFloat borderWidth = 2;
    CGFloat contentHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return contentHeight + borderWidth;
}

- (void)addBorder
{
    CGFloat width = 2.0;
    CGFloat originY = [self calculateHeight] - 2;
    
    // create on new
    if(self.bottomBorder == nil) {
        self.bottomBorder = [CALayer layer];
        self.bottomBorder.backgroundColor = [ThemeManager getSecondaryColorMedium].CGColor;
        [self.layer addSublayer:self.bottomBorder];
    }
    
    // adjust frame when reapplied
    self.bottomBorder.frame = CGRectMake(0, originY, self.frame.size.width, width);
}

@end
