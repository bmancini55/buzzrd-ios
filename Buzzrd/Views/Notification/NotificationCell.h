//
//  NotificationCell.h
//  Buzzrd
//
//  Created by Robert Beck on 10/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notification.h"
#import "CornerIndicator.h"

@interface NotificationCell : UITableViewCell

@property (nonatomic) bool hasConstraints;

@property (strong, nonatomic) UIImageView *exclamationImageView;
@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) CALayer *bottomBorder;
@property (strong, nonatomic) CornerIndicator *cornerIndicator;

- (id)initWithNotification:(Notification *)notification;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier notification:(Notification *)notification;

- (void)setNotification:(Notification *)notification;

- (void)markAsRead;

- (NSString *) configureDate:(NSDate *)date;

@end
