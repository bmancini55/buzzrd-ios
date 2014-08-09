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
#import "BuzzrdAPI.h"

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
    
    // add constraints for buble
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-6-[bubble]-6-|" options:0 metrics:nil views:@{ @"bubble": self.messageBubble }]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[bubble]" options:NSLayoutFormatAlignAllTop metrics:nil views:@{ @"bubble": self.messageBubble }]];
    
    if(self.message.revealed) {
        
        if([self isMine:self.message]) {
            
            // right align my messages
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-6-[username]-48-|" options:0 metrics:nil views:@{ @"username": self.usernameLabel }]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-6-[date]-48-|" options:0 metrics:nil views:@{ @"date": self.dateLabel }]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[image(==27)]-6-|" options:0 metrics:nil views:@{ @"image": self.profileImage }]];
            
        } else {
            
            // left align other messages
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-48-[username]-6-|" options:0 metrics:nil views:@{ @"username": self.usernameLabel }]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-48-[date]-6-|" options:0 metrics:nil views:@{ @"date": self.dateLabel }]];
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-6-[image(==27)]" options:0 metrics:nil views:@{ @"image": self.profileImage }]];
        }
        
        // set vertical constraints
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bubble]-0-[date]-0-[username]" options:0 metrics:nil views:@{ @"bubble": self.messageBubble, @"date": self.dateLabel, @"username": self.usernameLabel }]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[username]-0-|" options:NSLayoutFormatAlignAllBottom metrics:nil views:@{ @"username": self.usernameLabel }]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bubble]-3-[image(==27)]" options:0 metrics:nil views:@{ @"bubble": self.messageBubble, @"image": self.profileImage }]];
        
    } else {
        
        if([self isMine:self.message]) {

            // right align my messages
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-6-[date]-50-|" options:0 metrics:nil views:@{ @"date": self.dateLabel }]];
            
        } else {
      
            // left align other messages
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[date]-6-|" options:0 metrics:nil views:@{ @"date": self.dateLabel }]];
        
        }
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bubble]-0-[date]" options:0 metrics:nil views:@{ @"bubble": self.messageBubble, @"date": self.dateLabel }]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[date]-0-|" options:NSLayoutFormatAlignAllBottom metrics:nil views:@{ @"date": self.dateLabel }]];

    }
    
    [super updateConstraints];
}

- (bool) isMine:(Message *) message{
    return [[BuzzrdAPI current].user.iduser isEqualToString:message.userId];
}

- (UIColor *) getBubbleColor:(Message *)message {
    if (message.upvoteCount >= 5)
        return [ThemeManager getSecondaryColorDark];
    else if (message.upvoteCount >= 3 )
        return [ThemeManager getSecondaryColorMedium];
    else if (message.upvoteCount >= 1)
        return [ThemeManager getSecondaryColorLight];
    else
        return [ThemeManager getPrimaryColorLight];
}

- (void) setMessage:(Message *)message {
    _message = message;
    
    NSTextAlignment alignment = [self isMine:message] ? NSTextAlignmentRight : NSTextAlignmentLeft;
    UIColor *color = [self getBubbleColor:message];
    
    [self configureDate:message.created textAlignment:alignment];
    [self configureUsername:message textAlignment:alignment];
    [self.messageBubble update:message.message textAlignment:alignment color:color];
    
    [self updateConstraints];
    [self layoutIfNeeded];
    
    // configure image after layout of bubble
    [self configureImage:message];
    
    [self updateConstraints];
    [self layoutIfNeeded];
}

- (void) configureDate:(NSDate *)date textAlignment:(NSTextAlignment)textAlignment
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
    self.dateLabel.textAlignment = textAlignment;
}

- (void) configureUsername:(Message *)message textAlignment:(NSTextAlignment)textAlignment
{
    if (message.revealed) {
        self.usernameLabel.text = message.userName;
        self.usernameLabel.textAlignment = textAlignment;
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
        [self.profileImage loadImage:[NSString stringWithFormat:@"%@/api/users/%@/pic", [BuzzrdAPI apiURLBase], message.userId]];
        self.profileImage.hidden = false;
    } else {
        self.profileImage.hidden = true;
    }
}


@end
