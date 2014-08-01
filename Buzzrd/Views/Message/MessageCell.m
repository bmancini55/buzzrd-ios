//
//  MessageCell.m
//  Buzzrd
//
//  Created by Brian Mancini on 7/24/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "MessageCell.h"
#import "MessageBubble.h"
#import "ProfileImageView.h"
#import "ThemeManager.h"
#import "NSDate+Helpers.h"

@interface MessageCell()

@property (strong, nonatomic) MessageBubble *messageBubble;
@property (strong, nonatomic) ProfileImageView *profileImage;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *usernameLabel;

@end

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.messageBubble = [[MessageBubble alloc]init];
        self.messageBubble.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.messageBubble];
        
        self.dateLabel = [[UILabel alloc]init];
        self.dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.dateLabel.font = [ThemeManager getPrimaryFontRegular:12.0];
        self.dateLabel.textColor = [ThemeManager getPrimaryColorMedium];
        [self.contentView addSubview:self.dateLabel];
        
        self.usernameLabel = [[UILabel alloc]init];
        self.usernameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.usernameLabel.font = [ThemeManager getPrimaryFontDemiBold:12.0];
        self.usernameLabel.textColor = [ThemeManager getTertiaryColorDark];
        [self.contentView addSubview:self.usernameLabel];
        
        self.profileImage = [[ProfileImageView alloc] init];
        self.profileImage.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.profileImage];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void) updateConstraints
{
    // remove all constraints
    [self.contentView removeConstraints:self.contentView.constraints];
    
    // add constraints
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-6-[bubble]-6-|" options:0 metrics:nil views:@{ @"bubble": self.messageBubble }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[bubble]" options:NSLayoutFormatAlignAllTop metrics:nil views:@{ @"bubble": self.messageBubble }]];
    
    if(self.message.revealed) {

        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-48-[username]-6-|" options:0 metrics:nil views:@{ @"username": self.usernameLabel }]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-48-[date]-6-|" options:0 metrics:nil views:@{ @"date": self.dateLabel }]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-6-[image(==27)]" options:0 metrics:nil views:@{ @"image": self.profileImage }]];

        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bubble]-0-[date]-0-[username]" options:0 metrics:nil views:@{ @"bubble": self.messageBubble, @"date": self.dateLabel, @"username": self.usernameLabel }]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[username]-0-|" options:NSLayoutFormatAlignAllBottom metrics:nil views:@{ @"username": self.usernameLabel }]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bubble]-3-[image(==27)]" options:0 metrics:nil views:@{ @"bubble": self.messageBubble, @"image": self.profileImage }]];
        
    } else {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[date]-6-|" options:0 metrics:nil views:@{ @"date": self.dateLabel }]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bubble]-0-[date]" options:0 metrics:nil views:@{ @"bubble": self.messageBubble, @"date": self.dateLabel }]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[date]-0-|" options:NSLayoutFormatAlignAllBottom metrics:nil views:@{ @"date": self.dateLabel }]];
    }
    
    [super updateConstraints];
}



- (void) setMessage:(Message *)message {
    _message = message;
    [self configureDate:message.created];
    [self configureUsername:message];
    [self.messageBubble setText:message.message];
    
    [self updateConstraints];
    [self layoutIfNeeded];
    
    // configure image after layout of bubble
    [self configureImage:message];
    
    [self updateConstraints];
    [self layoutIfNeeded];
}

- (void) configureDate:(NSDate *)date {
    
    NSString *dateString = nil;
    if([date isToday]) {
        dateString = @"";
    } else if ([date isYesterday]) {
        dateString = NSLocalizedString(@"Yesterday", nil);
    } else if ([date daysAgo] < 7) {
        dateString = [NSString stringWithFormat:@"%u %@", [date daysAgo], NSLocalizedString(@"DaysAgo", nil)];
    } else {
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
        [dateFormater setDateFormat:@"M/d"];
        dateString = [dateFormater stringFromDate:date];
    }
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    [timeFormatter setDateFormat:@"hh:mm a"];
    NSString *timeString = [timeFormatter stringFromDate:date];
    
    NSString *text = [NSString stringWithFormat:@"%@ %@", dateString, timeString ];
    self.dateLabel.text = text;
}

- (void) configureUsername:(Message *)message
{
    if (message.revealed) {
        self.usernameLabel.text = message.userName;
        self.usernameLabel.hidden = false;
    }
    else {
        self.usernameLabel.text = @"";
        self.usernameLabel.hidden = true;
    }
}

- (void) configureImage:(Message *)message
{
    if (message.revealed) {
        
            NSLog(@"bubble left: %f, top: %f, width: %f, height: %f", self.messageBubble.frame.origin.x, self.messageBubble.frame.origin.y, self.messageBubble.frame.size.width, self.messageBubble.frame.size.height);
        //self.profileImage.frame = CGRectMake(self.messageBubble.frame.origin.x, self.messageBubble.frame.origin.y + self.messageBubble.frame.size.height + 16, 26, 26);
        [self.profileImage loadImage:[NSString stringWithFormat:@"http://devapi.buzzrd.io:5050/api/users/%@/pic", message.userId]];
        self.profileImage.hidden = false;
    } else {
        self.profileImage.hidden = true;
    }
}


@end
