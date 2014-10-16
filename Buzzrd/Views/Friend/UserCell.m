//
//  UserCell.m
//  Buzzrd
//
//  Created by Robert Beck on 10/9/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "UserCell.h"
#import "ThemeManager.h"

@interface UserCell()

@property (nonatomic) bool hasConstraints;

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) CALayer *bottomBorder;

@end

@implementation UserCell

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
    
    [self updateConstraints];
}

- (void) updateConstraints
{
    if(!self.hasConstraints) {
        self.hasConstraints = true;
        
        NSDictionary *views =
        @{
          @"title": self.nameLabel
          };
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-6-[title]-6-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[title]-6-|" options:0 metrics:nil views:views]];
    }
    
    [super updateConstraints];
}

- (void)setUser:(User *)user
{
    _user = user;
    
    self.nameLabel.text = user.firstName;
    
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
//    return contentHeight + borderWidth;
    return 30;
}  // Configure the view for the selected state

@end
