//
//  NotificationCell.m
//  Buzzrd
//
//  Created by Robert Beck on 10/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "NotificationCell.h"
#import "ThemeManager.h"
#import "BuzzrdAPI.h"
#import "NSDate+Helpers.h"

@interface NotificationCell()

@property (nonatomic) bool hasConstraints;

@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) CALayer *bottomBorder;

@end

@implementation NotificationCell

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
    
    self.messageLabel = [[UILabel alloc]init];
    self.messageLabel.font = [ThemeManager getPrimaryFontRegular:12.0f];
    self.messageLabel.textColor = [ThemeManager getPrimaryColorDark];
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:self.messageLabel];
    
    self.dateLabel = [[UILabel alloc]init];
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.dateLabel.font = [ThemeManager getPrimaryFontRegular:12.0f];
    self.dateLabel.textColor = [ThemeManager getPrimaryColorMedium];
    [self.contentView addSubview:self.dateLabel];
    
    [self updateConstraints];
}

- (void) configureDate:(NSDate *)date
{
    NSString *dateString = nil;
    if([date isToday]) {
        dateString = @"";
    } else if ([date isYesterday]) {
        dateString = NSLocalizedString(@"Yesterday", nil);
    } else if ([date daysAgo] < 7) {
        dateString = [NSString stringWithFormat:@"%u %@", [date daysAgo], NSLocalizedString(@"DaysAgo", nil)];
    } else {
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
        [dateFormater setDateFormat:@"MMM d"];
        dateString = [dateFormater stringFromDate:date];
    }
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    [timeFormatter setDateFormat:@"h:mm a"];
    NSString *timeString = [timeFormatter stringFromDate:date];
    
    NSString *text = [NSString stringWithFormat:@"%@ %@", dateString, timeString ];
    self.dateLabel.text = text;
}

- (void) updateConstraints
{
    if(!self.hasConstraints) {
        self.hasConstraints = true;
        
        NSDictionary *views =
        @{
          @"message": self.messageLabel,
          @"date": self.dateLabel
        };
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[message]-6-|" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[date]" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[message]-3-[date]" options:0 metrics:nil views:views]];
    }
    
    [super updateConstraints];
}

- (void)setNotification:(Notification *)notification
{
    _notification = notification;
    
    self.messageLabel.text = notification.message;
    [self configureDate:notification.created];
    
    [self addBorder];
}

- (void)addBorder
{
//    CGFloat width = .5;
//    CGFloat originY = [self calculateHeight] - width;
//    
//    // create on new
//    if(self.bottomBorder == nil) {
//        self.bottomBorder = [CALayer layer];
//        self.bottomBorder.backgroundColor = [ThemeManager getSecondaryColorMedium].CGColor;
//        [self.layer addSublayer:self.bottomBorder];
//    }
//    
//    // adjust frame when reapplied
//    self.bottomBorder.frame = CGRectMake(12, originY, self.frame.size.width - 24, width);
}

//- (CGFloat)calculateHeight
//{
//    return 85;
//}

@end
