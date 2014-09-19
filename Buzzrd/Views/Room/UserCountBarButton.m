//
//  UserCountBarButton.m
//  Buzzrd
//
//  Created by Brian Mancini on 8/6/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "UserCountBarButton.h"
#import "ThemeManager.h"

@interface UserCountBarButton()

@property (strong, nonatomic) UILabel *userCountLabel;
@property (strong, nonatomic) UILabel *userLabel;

@property (strong, nonatomic) UILabel *lurkerCountLabel;
@property (strong, nonatomic) UILabel *lurkerLabel;

@end

@implementation UserCountBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userCountLabel = [[UILabel alloc]init];
        self.userCountLabel.text = @"0";
        self.userCountLabel.textColor = [ThemeManager getTertiaryColorDark];
        self.userCountLabel.textAlignment = NSTextAlignmentRight;
        self.userCountLabel.font = [ThemeManager getPrimaryFontBold:12.0];
        self.userCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.userCountLabel];
        
        self.userLabel = [[UILabel alloc]init];
        self.userLabel.text = NSLocalizedString(@"USERS", nil);
        self.userLabel.textColor = [ThemeManager getPrimaryColorMedium];
        self.userLabel.font = [ThemeManager getPrimaryFontMedium:12.0];
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
        
        self.lurkerCountLabel.hidden = true;
        self.lurkerLabel.hidden = true;
        
    }
    return self;
}

- (void) updateConstraints
{
    NSDictionary *views =
    @{
        @"usercount": self.userCountLabel,
        @"userlabel": self.userLabel,
        @"lurkercount": self.lurkerCountLabel,
        @"lurkerlabel": self.lurkerLabel
    };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[usercount]-3-[userlabel]-(-10)-|" options:0 metrics:nil views:views]];
    //[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[lurkercount]-3-[lurkerlabel]-(-10)-|" options:0 metrics:nil views:views]];
    //[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[userlabel]" options:0 metrics:nil views:views]];
    //[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[usercount]" options:0 metrics:nil views:views]];
    //[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[userlabel][lurkerlabel]" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
    //[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[usercount][lurkercount]" options:NSLayoutFormatAlignAllRight metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[usercount]" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[userlabel]" options:0 metrics:nil views:views]];
    
    [super updateConstraints];
}

- (void) setUserCount:(uint)userCount
{
    _userCount = userCount;
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3;
    animation.type = kCATransitionFade;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.userCountLabel.layer addAnimation:animation forKey:@"changeTextTransition"];
    
    self.userCountLabel.text = [NSString stringWithFormat:@"%i", (int)_userCount];
    
    if(_userCount == 1) {
        self.userLabel.text = NSLocalizedString(@"USER", nil);
    } else {
        self.userLabel.text = NSLocalizedString(@"USERS", nil);
    }
}

@end
