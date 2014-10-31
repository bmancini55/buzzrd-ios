//
//  UserCell.m
//  Buzzrd
//
//  Created by Robert Beck on 10/9/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "UserCell.h"
#import "ThemeManager.h"
#import "ProfileImageView.h"
#import "BuzzrdAPI.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface UserCell()

@property (nonatomic) bool hasConstraints;

@property (strong, nonatomic) UILabel *usernameLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) ProfileImageView *profileImage;
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

    self.usernameLabel = [[UILabel alloc]init];
    self.usernameLabel.font = [ThemeManager getPrimaryFontMedium:18.0f];
    self.usernameLabel.textColor = [ThemeManager getPrimaryColorDark];
    self.usernameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.usernameLabel];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [ThemeManager getPrimaryFontMedium:12.0f];
    self.nameLabel.textColor = [ThemeManager getPrimaryColorMedium];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.nameLabel];

    self.profileImage = [[ProfileImageView alloc] initWithFrame:CGRectMake(0, 0, 62.5, 62.5)];
    self.profileImage.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.profileImage];
    
    [self updateConstraints];
}

- (void) updateConstraints
{
    if(!self.hasConstraints) {
        self.hasConstraints = true;
        
        NSDictionary *views =
        @{
          @"username": self.usernameLabel,
          @"image": self.profileImage,
          @"name": self.nameLabel
        };
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-72.5-[username]" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[image(62.5)]" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-72.5-[name]" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[username]-(-3)-[name]" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[image(==62.5)]" options:0 metrics:nil views:views]];
        
    }
    
    [super updateConstraints];
}

- (void)setUser:(User *)user
{
    _user = user;
    
    self.usernameLabel.text = user.username;
    
    if ([user.firstName length] > 0) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    }
    else {
        self.nameLabel.text = user.lastName;
    }
    
    [self configureImage:user];
}

- (void) configureImage:(User *)user
{
    if (user.profilePic != nil) {
        [self.profileImage loadImageFromUrl:[NSString stringWithFormat:@"http://s3.amazonaws.com/buzzrd-dev/%@", user.profilePic]];
    }
    else {
        [self.profileImage loadImage:[UIImage imageNamed:@"no_profile_pic.png"]];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [ThemeManager getSecondaryColorMedium].CGColor);
    CGContextSetLineWidth(context, 0.5f);
    CGContextMoveToPoint(context, 0.0f, CGRectGetHeight(rect));
    CGContextAddLineToPoint(context, CGRectGetWidth(rect), CGRectGetHeight(rect));
    CGContextStrokePath(context);
}


- (CGFloat)calculateHeight
{
    return 63;
}

@end
