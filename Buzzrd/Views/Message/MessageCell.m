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

@interface MessageCell()

@property (strong, nonatomic) MessageBubble *messageBubble;
@property (strong, nonatomic) ProfileImageView *profilImage;
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
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-6-[bubble]-6-|" options:0 metrics:nil views:@{ @"bubble": self.messageBubble }]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[bubble]-6-|" options:0 metrics:nil views:@{ @"bubble": self.messageBubble }]];
    }
    return self;
}

- (void) setMessage:(Message *)message {
    _message = message;
    [self.messageBubble setText:message.message];
}

@end
