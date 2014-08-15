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

@property (strong,nonatomic) UILabel *nameLabel;
@property (strong,nonatomic) UILabel *userCountLabel;

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
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.nameLabel];
    
    self.userCountLabel = [[UILabel alloc]init];
    self.userCountLabel.font = [ThemeManager getPrimaryFontBold:10.0];
    self.userCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.userCountLabel];
}

- (void) updateConstraints
{
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-6-[title]-6-|" options:0 metrics:nil views:@{ @"title": self.nameLabel }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[title]-6-|" options:0 metrics:nil views:@{ @"title": self.nameLabel }]];
    
    [super updateConstraints];
}

- (void)setRoom:(Room *)room
{
    self.nameLabel.text = room.name;
    self.userCountLabel.text = [NSString stringWithFormat:@"%lu %@", (unsigned long)room.userCount, NSLocalizedString(@"users", nil)];
}

@end
