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

@property (nonatomic) bool hasConstraints;

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *venueLabel;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UILabel *userCountLabel;
@property (strong, nonatomic) UILabel *userLabel;
@property (strong, nonatomic) UILabel *messageCountLabel;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) CALayer *bottomBorder;
@property (strong, nonatomic) UIImageView *typeImage;

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
    self.nameLabel.font = [ThemeManager getPrimaryFontMedium:17.0f];
    self.nameLabel.textColor = [ThemeManager getPrimaryColorDark];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.nameLabel];
    
    self.venueLabel = [[UILabel alloc] init];
    self.venueLabel.font = [ThemeManager getPrimaryFontMedium:12.0];
    self.venueLabel.textColor = [ThemeManager getPrimaryColorDark];
    self.venueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.venueLabel];
    
    self.addressLabel = [[UILabel alloc]init];
    self.addressLabel.font = [ThemeManager getPrimaryFontRegular:11.0];
    self.addressLabel.textColor = [ThemeManager getPrimaryColorDark];
    self.addressLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.addressLabel];
    
    self.messageCountLabel = [[UILabel alloc]init];
    self.messageCountLabel.font = [ThemeManager getPrimaryFontBold:20.0];
    self.messageCountLabel.textColor = [ThemeManager getTertiaryColorDark];
    self.messageCountLabel.textAlignment = NSTextAlignmentRight;
    self.messageCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.messageCountLabel];

    self.messageLabel = [[UILabel alloc]init];
    self.messageLabel.font = [ThemeManager getPrimaryFontMedium:10.0];
    self.messageLabel.textColor = [ThemeManager getPrimaryColorDark];
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.messageLabel];
    
    self.distanceLabel = [[UILabel alloc] init];
    self.distanceLabel.font = [ThemeManager getPrimaryFontMedium:10.0];
    self.distanceLabel.textColor = [ThemeManager getPrimaryColorDark];
    self.distanceLabel.textAlignment = NSTextAlignmentRight;
    self.distanceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.distanceLabel];
    
    self.typeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Venue.png"]];
    self.typeImage.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.typeImage];
    
    [self updateConstraints];
}

- (void) updateConstraints
{
    if(!self.hasConstraints) {
        self.hasConstraints = true;
        
        NSDictionary *views =
            @{
                @"title": self.nameLabel,
                @"venue": self.venueLabel,
                @"distance": self.distanceLabel,
                @"address": self.addressLabel,
                @"msgCount": self.messageCountLabel,
                @"msg": self.messageLabel,
                @"image": self.typeImage
            };
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[image(17)]-6-[title]" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[title]-(>=6)-[msgCount(>=40)]" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[title]-(>=6)-[msg]" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[msgCount]-12-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[image]-6-[venue]-(>=6)-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[image]-6-[address]" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[address]-(>=6)-[distance]" options:NSLayoutFormatAlignAllBaseline metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[distance]-12-|" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-9-[image(22)]" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[title]" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[title]-(-1)-[venue]-(-3)-[address]" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[address]-6-|" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[msgCount]" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[msgCount]-(-9)-[msg]" options:NSLayoutFormatAlignAllRight metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[msg]-(>=6)-[distance]" options:0 metrics:nil views:views]];
    }
    
    [super updateConstraints];
}

- (void)setRoom:(Room *)room userLocation:(CLLocation *)userLocation
{
    _room = room;
    
    self.nameLabel.text = room.name;
    
    self.messageCountLabel.text = [self formatMessages:(int)room.messageCount];
    self.messageLabel.text = NSLocalizedString(@"msgs", nil);
    
    // set distance
    CLLocationDistance distance = [userLocation distanceFromLocation:room.coord];
    CGFloat distanceInFeet = distance / 1609.344 * 5280;
    if(distanceInFeet < 500)
        self.distanceLabel.text = [NSString stringWithFormat:@"(%1.f ft)", distanceInFeet];
    else
        self.distanceLabel.text = [NSString stringWithFormat:@"(%.1f mi)", distanceInFeet / 5280];
    
    // set type information
    if(room.venueId != nil && ![room.venueId isEqualToString:@""]) {
        self.typeImage.image = [UIImage imageNamed:@"Venue.png"];
        self.venueLabel.text = room.venueName;
        self.addressLabel.text = [room.location prettyString];
    } else {
        self.typeImage.image = [UIImage imageNamed:@"Pinpoint.png"];
        self.venueLabel.text = @" ";
        self.addressLabel.text = [room.location prettyString];
    }
    
    [self addBorder];
}

- (void)addBorder
{
    CGFloat width = .5;
    CGFloat originY = [self calculateHeight] - width;
    
    // create on new
    if(self.bottomBorder == nil) {
        self.bottomBorder = [CALayer layer];
        self.bottomBorder.backgroundColor = [ThemeManager getSecondaryColorMedium].CGColor;
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


- (NSString *)formatMessages:(int)messageCount
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber *messageNumber = [NSNumber numberWithInt:messageCount];
    
    if(messageCount < 1000) {
        [numberFormatter setPositiveFormat:@"###0"];
    }
    else if (messageCount < 10000) {
        [numberFormatter setPositiveFormat:@"0.0k"];
        messageNumber = [NSNumber numberWithFloat:[messageNumber floatValue] / 1000.0];
    }
    else if (messageCount < 1000000) {
        [numberFormatter setPositiveFormat:@"###0k"];
        messageNumber = [NSNumber numberWithFloat:[messageNumber floatValue] / 1000.0];
    }
    
    return [numberFormatter stringFromNumber:messageNumber];
}

@end
