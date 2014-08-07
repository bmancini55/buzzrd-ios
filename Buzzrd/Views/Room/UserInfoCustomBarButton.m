//
//  UserInfoCustomBarButton.m
//  Buzzrd
//
//  Created by Brian Mancini on 8/6/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "UserInfoCustomBarButton.h"
#import "ThemeManager.h"

@interface UserInfoCustomBarButton()

@property (strong, nonatomic) UILabel *userCountLabel;
@property (strong, nonatomic) UILabel *userLabel;

@property (strong, nonatomic) UILabel *lurkerCountLabel;
@property (strong, nonatomic) UILabel *lurkerLabel;

@end

@implementation UserInfoCustomBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userCountLabel = [[UILabel alloc]init];
        self.userCountLabel.text = @"0";
        self.userCountLabel.textColor = [ThemeManager getTertiaryColorDark];
        self.userCountLabel.textAlignment = NSTextAlignmentRight;
        self.userCountLabel.font = [ThemeManager getPrimaryFontBold:10.0];
        self.userCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.userCountLabel];
        
        self.userLabel = [[UILabel alloc]init];
        self.userLabel.text = NSLocalizedString(@"USERS", nil);
        self.userLabel.textColor = [ThemeManager getPrimaryColorMedium];
        self.userLabel.font = [ThemeManager getPrimaryFontMedium:10.0];
        self.userLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.userLabel];
        
        self.lurkerCountLabel = [[UILabel alloc]init];
        self.lurkerCountLabel.text = @"0";
        self.lurkerCountLabel.textColor = [ThemeManager getTertiaryColorDark];
        self.lurkerCountLabel.textAlignment = NSTextAlignmentRight;
        self.lurkerCountLabel.font = [ThemeManager getPrimaryFontBold:10.0];
        self.lurkerCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.lurkerCountLabel];
        
        self.lurkerLabel = [[UILabel alloc]init];
        self.lurkerLabel.text = NSLocalizedString(@"LURKERS", nil);
        self.lurkerLabel.textColor = [ThemeManager getPrimaryColorMedium];
        self.lurkerLabel.font = [ThemeManager getPrimaryFontMedium:10.0];
        self.lurkerLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.lurkerLabel];
    }
    return self;
}

- (void) updateConstraints
{
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[usercount]-3-[userlabel]-(-10)-|" options:0 metrics:nil views:@{ @"usercount": self.userCountLabel, @"userlabel": self.userLabel }]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[lurkercount]-3-[lurkerlabel]-(-10)-|" options:0 metrics:nil views:@{ @"lurkercount": self.lurkerCountLabel, @"lurkerlabel": self.lurkerLabel }]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[userlabel]-(-3)-[lurkerlabel]" options:0 metrics:nil views:@{ @"userlabel": self.userLabel, @"lurkerlabel": self.lurkerLabel }]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[usercount]-(-3)-[lurkercount]" options:0 metrics:nil views:@{ @"usercount": self.userCountLabel, @"lurkercount": self.lurkerCountLabel }]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[userlabel][lurkerlabel]" options:NSLayoutFormatAlignAllLeft metrics:nil views:@{ @"userlabel": self.userLabel, @"lurkerlabel": self.lurkerLabel }]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[usercount][lurkercount]" options:NSLayoutFormatAlignAllRight metrics:nil views:@{ @"usercount": self.userCountLabel, @"lurkercount": self.lurkerCountLabel }]];
    
    [super updateConstraints];
}

- (void) setUserCount:(uint)userCount
{
    _userCount = userCount;
    self.userCountLabel.text = [NSString stringWithFormat:@"%i", (int)_userCount];
}

@end
