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
    self.usernameLabel.font = [ThemeManager getPrimaryFontDemiBold:21.0f];
    self.usernameLabel.textColor = [ThemeManager getTertiaryColorDark];
    self.usernameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.usernameLabel];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [ThemeManager getPrimaryFontMedium:16.0f];
    self.nameLabel.textColor = [ThemeManager getPrimaryColorMedium];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.nameLabel];
    
    self.profileImage = [[ProfileImageView alloc] init];
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
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-57-[username]" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-6-[image(47)]" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-57-[name]" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[username]-0-[name]" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[image(==47)]" options:0 metrics:nil views:views]];
        
    }
    
    [super updateConstraints];
}

- (void)setUser:(User *)user
{
    _user = user;
    
    self.usernameLabel.text = user.username;
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    
    [self configureImage:user];
    
    [self addBorder];
}

- (void) configureImage:(User *)user
{
    if (user.profilePic != nil) {
        
        [self.profileImage loadImage:[NSString stringWithFormat:@"http://s3.amazonaws.com/buzzrd-dev/%@", user.profilePic]];
        
                self.profileImage.hidden = false;
    } else {
        // Use the anonymous buzzrd image
    }
    
    
    
    //    if ([BuzzrdAPI current].profilePic != nil) {
    //        profileImageView.image = [BuzzrdAPI current].profilePic;
    //    }
    //    else {
    //        profileImageView.image = [UIImage imageNamed:@"no_profile_pic.png"];
    //    }
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
//    CGFloat borderWidth = .5;
//    CGFloat contentHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    return contentHeight + borderWidth;
    return 55;
}

@end
