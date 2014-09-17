//
//  RoomCell.m
//  Buzzrd
//
//  Created by Brian Mancini on 9/15/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "RoomCell.h"
#import "ThemeManager.h"

@interface RoomCell()

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *defaultLabel;
@property (strong, nonatomic) UILabel *venueLabel;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UILabel *userCountLabel;
@property (strong, nonatomic) UILabel *userLabel;
@property (strong, nonatomic) UILabel *messageCountLabel;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) CALayer *bottomBorder;

@end

@implementation RoomCell

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
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [ThemeManager getPrimaryFontRegular:14.0];
    self.nameLabel.textColor = [ThemeManager getPrimaryColorDark];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.nameLabel];
    
    self.defaultLabel = [[UILabel alloc]init];
    self.defaultLabel.font = [ThemeManager getPrimaryFontRegular:9.0];
    self.defaultLabel.textColor = [ThemeManager getPrimaryColorDark];
    self.defaultLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.defaultLabel];
    
    self.venueLabel = [[UILabel alloc] init];
    self.venueLabel.font = [ThemeManager getPrimaryFontRegular:12.0f];
    self.venueLabel.textColor = [ThemeManager getPrimaryColorDark];
    self.venueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.venueLabel];
    
    self.addressLabel = [[UILabel alloc]init];
    self.addressLabel.font = [ThemeManager getPrimaryFontMedium:9.0];
    self.addressLabel.textColor = [ThemeManager getPrimaryColorDark];
    self.addressLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.addressLabel];
    
    self.messageCountLabel = [[UILabel alloc]init];
    self.messageCountLabel.font = [ThemeManager getPrimaryFontBold:10.0];
    self.messageCountLabel.textColor = [ThemeManager getPrimaryColorDark];
    self.messageCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.messageCountLabel];

    self.messageLabel = [[UILabel alloc]init];
    self.messageLabel.font = [ThemeManager getPrimaryFontMedium:10.0];
    self.messageLabel.textColor = [ThemeManager getPrimaryColorDark];
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.messageLabel];
    
    self.distanceLabel = [[UILabel alloc] init];
    self.distanceLabel.font = [ThemeManager getPrimaryFontRegular:11.0];
    self.distanceLabel.textColor = [ThemeManager getPrimaryColorDark];
    self.distanceLabel.textAlignment = NSTextAlignmentRight;
    self.distanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.distanceLabel];
}

- (void) updateConstraints
{
    NSDictionary *views =
        @{
            @"title": self.nameLabel,
            @"default": self.defaultLabel,
            @"venue": self.venueLabel,
            @"distance": self.distanceLabel,
            @"address": self.addressLabel,
            @"msgCount": self.messageCountLabel,
            @"msg": self.messageLabel
        };
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[title]" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[title]-3-[default]" options:NSLayoutFormatAlignAllBaseline metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[address]-(>=6)-[distance]" options:NSLayoutFormatAlignAllBottom metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[distance]-12-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[title]-(>=6)-[msgCount]" options:NSLayoutFormatAlignAllBaseline metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[msgCount]-3-[msg]" options:NSLayoutFormatAlignAllBaseline metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[msg]-12-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[title]" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[title]-(2)-[venue]" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[venue]-(-1)-[address]" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[address]-6-|" options:0 metrics:nil views:views]];
    
    
    [super updateConstraints];
}

- (void)setRoom:(Room *)room userLocation:(CLLocation *)userLocation
{
    _room = room;
    
    self.nameLabel.text = room.name;
    
    if(room.venueDefault) {
        self.defaultLabel.text = [NSString stringWithFormat:@"(%@)", NSLocalizedString(@"Default", nil)];
        self.defaultLabel.hidden = false;
    } else {
        self.defaultLabel.text = @"";
        self.defaultLabel.hidden = true;
    }
    
    self.venueLabel.text = room.venue.name;
    self.addressLabel.text = [room.venue.location prettyString];
    
    self.messageCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)room.messageCount];
    self.messageLabel.text = NSLocalizedString(@"msgs", nil);
    
    // set distance
    CLLocationDistance distance = [userLocation distanceFromLocation:room.location];
    CGFloat distanceInFeet = distance / 1609.344 * 5280;
    if(distanceInFeet < 500)
        self.distanceLabel.text = [NSString stringWithFormat:@"%1.f ft", distanceInFeet];
    else
        self.distanceLabel.text = [NSString stringWithFormat:@"%.1f mi", distanceInFeet / 5280];
    
    [self updateConstraints];
    [self addBorder];
}

- (void)addBorder
{
    CGFloat width = .5;
    CGFloat originY = [self calculateHeight] - width;
    
    // create on new
    if(self.bottomBorder == nil) {
        self.bottomBorder = [CALayer layer];
        self.bottomBorder.backgroundColor = [ThemeManager getTertiaryColorDark].CGColor;
        [self.layer addSublayer:self.bottomBorder];
    }
    
    // adjust frame when reapplied
    self.bottomBorder.frame = CGRectMake(12, originY, self.frame.size.width - 24, width);
}

- (CGFloat)calculateHeight
{
    CGFloat borderWidth = .5;
    CGFloat contentHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return contentHeight + borderWidth;
}  // Configure the view for the selected state


@end
