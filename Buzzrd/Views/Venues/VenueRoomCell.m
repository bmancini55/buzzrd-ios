//
//  VenueRoomCell.m
//  Buzzrd
//
//  Created by Brian Mancini on 6/3/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "VenueRoomCell.h"
#import "ThemeManager.h"

@interface VenueRoomCell()

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *defaultLabel;

@property (strong, nonatomic) UILabel *userCountLabel;
@property (strong, nonatomic) UILabel *userLabel;

@property (strong, nonatomic) UILabel *lurkerCountLabel;
@property (strong, nonatomic) UILabel *lurkerLabel;

@property (strong, nonatomic) CALayer *bottomBorder;

@end

@implementation VenueRoomCell

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
    
    self.userCountLabel = [[UILabel alloc]init];
    self.userCountLabel.font = [ThemeManager getPrimaryFontBold:10.0];
    self.userCountLabel.textColor = [ThemeManager getPrimaryColorDark];
    self.userCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.userCountLabel];
    
    self.userLabel = [[UILabel alloc]init];
    self.userLabel.font = [ThemeManager getPrimaryFontMedium:10.0];
    self.userLabel.textColor = [ThemeManager getPrimaryColorDark];
    self.userLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.userLabel];
    
    self.lurkerCountLabel = [[UILabel alloc]init];
    self.lurkerCountLabel.font = [ThemeManager getPrimaryFontBold:10.0];
    self.lurkerCountLabel.textColor = [ThemeManager getPrimaryColorDark];
    self.lurkerCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.lurkerCountLabel];
    
    self.lurkerLabel = [[UILabel alloc]init];
    self.lurkerLabel.font = [ThemeManager getPrimaryFontMedium:10.0];
    self.lurkerLabel.textColor = [ThemeManager getPrimaryColorDark];
    self.lurkerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.lurkerLabel];
}

- (void) updateConstraints
{
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[title]" options:0 metrics:nil views:@{ @"title": self.nameLabel }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[title]-3-[default]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{ @"title": self.nameLabel, @"default": self.defaultLabel }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[default]-(>=6)-|" options:0 metrics:nil views:@{ @"default": self.defaultLabel }]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[title]" options:0 metrics:nil views:@{ @"title": self.nameLabel }]];
    
    // vertical spacing for address and user count, align them verticall on the left edge
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[title]-(-1)-[usercount]" options:NSLayoutFormatAlignAllLeft metrics:nil views:@{ @"title":                                                                                                                                                  self.nameLabel, @"usercount": self.userCountLabel }]];
    
    // vertical spacing for user and lurker counts from the bottom of the container
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[usercount]-6-|" options:0 metrics:nil views:@{ @"usercount": self.userCountLabel }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[users]-6-|" options:0 metrics:nil views:@{ @"users": self.userLabel }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lurkercount]-6-|" options:0 metrics:nil views:@{ @"lurkercount": self.lurkerCountLabel }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lurkers]-6-|" options:0 metrics:nil views:@{ @"lurkers": self.lurkerLabel }]];
    
    // horizontal spacing for the user and lurker counts, align them on the top edge
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[usercount]-3-[users]-16-[lurkercount]-3-[lurkers]" options:NSLayoutFormatAlignAllTop metrics:nil views:@{ @"usercount": self.userCountLabel, @"users": self.userLabel, @"lurkercount": self.lurkerCountLabel, @"lurkers": self.lurkerLabel }]];
    
    [super updateConstraints];
}

- (void)setRoom:(Room *)room
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
    
    self.userCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)room.userCount];
    self.userLabel.text = NSLocalizedString(@"USERS", nil);
    
    self.lurkerCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)room.lurkerCount];
    self.lurkerLabel.text = NSLocalizedString(@"LURKERS", nil);
    
    [self updateConstraints];
    [self addBorder];
}

- (void)addBorder
{
    CGFloat width = 2.0;
    CGFloat originY = [self calculateHeight];
    
    // create on new
    if(self.bottomBorder == nil) {
        self.bottomBorder = [CALayer layer];
        self.bottomBorder.backgroundColor = [ThemeManager getTertiaryColorDark].CGColor;
        [self.layer addSublayer:self.bottomBorder];
    }
    
    // adjust frame when reapplied
    self.bottomBorder.frame = CGRectMake(0, originY, self.frame.size.width, width);
}

- (CGFloat)calculateHeight
{
    CGFloat borderWidth = 2;
    CGFloat contentHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return contentHeight + borderWidth;
}

@end
