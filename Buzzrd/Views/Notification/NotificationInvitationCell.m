//
//  NotificationInvitationCell.m
//  Buzzrd
//
//  Created by Robert Beck on 11/5/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "NotificationInvitationCell.h"
#import "ThemeManager.h"
#import "BuzzrdAPI.h"
#import "NSDate+Helpers.h"
#import "CornerIndicator.h"
#import "NotificationInvitation.h"

@interface NotificationInvitationCell()

@property (strong, nonatomic) UILabel *senderNameLabel;
@property (strong, nonatomic) UILabel *roomNameLabel;

@end

@implementation NotificationInvitationCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier notification:(NotificationInvitation *)notification
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupWithNotification:notification];
    }
    return self;
}

- (id)initWithNotification:(NotificationInvitation *) notification
{
    self = [super init];
    if (self) {
        [self setupWithNotification:notification];
    }
    return self;
}

- (void) setupWithNotification:(NotificationInvitation *) notification
{
    self.backgroundColor = [ThemeManager getPrimaryColorLight];
    
    self.exclamationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 17, 40)];
    self.exclamationImageView.image = [UIImage imageNamed:@"Notify_Y.png"];
    [self.contentView addSubview:self.exclamationImageView];
    
    self.senderNameLabel = [[UILabel alloc]init];
    self.senderNameLabel.font = [ThemeManager getPrimaryFontMedium:17.0f];
    self.senderNameLabel.textColor = [ThemeManager getPrimaryColorDark];
    self.senderNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.senderNameLabel.numberOfLines = 0;
    self.senderNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:self.senderNameLabel];
    
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
    
    [self updateConstraints];
}

- (void) updateConstraints
{
    if(!self.hasConstraints) {
        self.hasConstraints = true;
        
        NSDictionary *views =
        @{
          @"sender": self.senderNameLabel,
          @"message": self.messageLabel,
          @"room": self.roomNameLabel,
          @"date": self.dateLabel
          };
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[sender]-(>=6)-[date]" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[message]-6-|" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[room]-6-|" options:0 metrics:nil views:views]];

        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[date]-12-|" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[sender]-1-[message]-1-[room]" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[date]" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[room]-5-|" options:0 metrics:nil views:views]];
    }
    
    [super updateConstraints];
}

- (void)setNotification:(NotificationInvitation *)notification
{
    self.senderNameLabel.text = notification.senderName;
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