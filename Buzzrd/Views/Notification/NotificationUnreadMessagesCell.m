//
//  NotificationUnreadMessagesCell.m
//  Buzzrd
//
//  Created by Robert Beck on 11/5/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "NotificationUnreadMessagesCell.h"
#import "ThemeManager.h"
#import "BuzzrdAPI.h"
#import "NSDate+Helpers.h"
#import "CornerIndicator.h"
#import "NotificationUnreadMessages.h"
#import "UIImage+Alpha.h"

@interface NotificationUnreadMessagesCell()

@property (strong, nonatomic) UILabel *roomNameLabel;

@end

@implementation NotificationUnreadMessagesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier notification:(NotificationUnreadMessages *)notification
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupWithNotification:notification];
    }
    return self;
}

- (id)initWithNotification:(NotificationUnreadMessages *) notification
{
    self = [super init];
    if (self) {
        [self setupWithNotification:notification];
    }
    return self;
}

- (void) setupWithNotification:(NotificationUnreadMessages *) notification
{
    self.backgroundColor = [ThemeManager getPrimaryColorLight];
    
    float imageAlpha = 0.75;
    self.exclamationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 14, 34)];
    self.exclamationImageView.image = [[UIImage imageNamed:@"Notify_Y.png"] imageByApplyingAlpha:imageAlpha];
    [self.contentView addSubview:self.exclamationImageView];
    
    self.messageLabel = [[UILabel alloc]init];
    self.messageLabel.font = [ThemeManager getPrimaryFontMedium:12.0f];
    self.messageLabel.textColor = [ThemeManager getPrimaryColorDark];
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:self.messageLabel];
    
    self.roomNameLabel = [[UILabel alloc]init];
    self.roomNameLabel.font = [ThemeManager getPrimaryFontBold:13.0f];
    self.roomNameLabel.textColor = [ThemeManager getPrimaryColorDark];
    self.roomNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.roomNameLabel.numberOfLines = 0;
    self.roomNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:self.roomNameLabel];
    
    self.dateLabel = [[UILabel alloc]init];
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.dateLabel.font = [ThemeManager getPrimaryFontMedium:12.0f];
    self.dateLabel.textColor = [ThemeManager getPrimaryColorMedium];
    [self.contentView addSubview:self.dateLabel];
    
    CGRect cornerIndicatorFrame = CGRectMake(CGRectGetWidth(self.frame) - 10, 0, CGRectGetWidth(self.frame), 10);
    self.cornerIndicator = [[CornerIndicator alloc]initWithFrame:cornerIndicatorFrame];
    self.cornerIndicator.indicatorColor = [ThemeManager getTertiaryColorDark];
    self.cornerIndicator.hidden = true;
    [self.cornerIndicator setIndicatorColor:[[ThemeManager getTertiaryColorDark] colorWithAlphaComponent:0.75]];
    [self.contentView addSubview:self.cornerIndicator];
    
    [self updateConstraints:notification];
}

- (void) updateConstraints:(NotificationUnreadMessages *) notification
{
    if(!self.hasConstraints) {
        self.hasConstraints = true;
        
        NSDictionary *views =
        @{
          @"message": self.messageLabel,
          @"date": self.dateLabel,
          @"notifyIcon": self.exclamationImageView,
          @"room": self.roomNameLabel
          };
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[message]-6-[date]-12-|" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[message]-1-[room]" options:0 metrics:nil views:views]];
                
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[room]-6-|" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[date]" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[room]-(>=5)-|" options:0 metrics:nil views:views]];
        
        if (!notification.read)
        {
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[notifyIcon]-(>=5)-|" options:0 metrics:nil views:views]];
        }
    }
    
    [super updateConstraints];
}

- (void)setNotification:(NotificationUnreadMessages *)notification
{
    self.messageLabel.text = notification.message;
    self.roomNameLabel.text = notification.roomName;
    self.dateLabel.text = [self configureDate:notification.created];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    // handle indicator
    if(notification.read) {
        self.cornerIndicator.hidden = true;
        self.exclamationImageView.hidden = true;
    }
    else {
        self.cornerIndicator.hidden = false;
        self.exclamationImageView.hidden = false;
    }
}

@end