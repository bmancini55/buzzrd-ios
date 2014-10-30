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
#import "CornerIndicator.h"

@interface NotificationCell()

@property (nonatomic) bool hasConstraints;

@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) CALayer *bottomBorder;
@property (strong, nonatomic) CornerIndicator *cornerIndicator;

@end

@implementation NotificationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier notification:(Notification *)notification
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupWithNotification:notification];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [ThemeManager getSecondaryColorMedium].CGColor);
    CGContextSetLineWidth(context, 0.5f);
    CGContextMoveToPoint(context, 12.0f, CGRectGetHeight(rect));
    CGContextAddLineToPoint(context, CGRectGetWidth(rect), CGRectGetHeight(rect));
    CGContextStrokePath(context);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Set the preferredMaxLayoutWidth of the mutli-line bodyLabel based on the evaluated width of the label's frame,
    // as this will allow the text to wrap correctly, and as a result allow the label to take on the correct height.
    self.messageLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.messageLabel.frame);
}

- (id)initWithNotification:(Notification *) notification
{
    self = [super init];
    if (self) {
        [self setupWithNotification:notification];
    }
    return self;
}

- (void) setupWithNotification:(Notification *) notification
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
    self.dateLabel.font = [ThemeManager getPrimaryFontRegular:10.0f];
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
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[message]" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[message]-4-[date]" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[date]-5-|" options:0 metrics:nil views:views]];
    }
    
    [super updateConstraints];
}

- (void)setNotification:(Notification *)notification
{
    _notification = notification;
    
    self.messageLabel.text = notification.message;
    [self configureDate:notification.created];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];

    // handle indicator
    if(notification.read) {
        self.cornerIndicator.hidden = true;
    }
    else {
        self.cornerIndicator.hidden = false;
    }
}

- (void)markAsRead
{
    self.cornerIndicator.hidden = true;    
}

@end