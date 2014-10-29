//
//  NotificationCell.h
//  Buzzrd
//
//  Created by Robert Beck on 10/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notification.h"

@interface NotificationCell : UITableViewCell

@property (strong, nonatomic) Notification* notification;

//- (CGFloat)calculateHeight;

- (void)setNotification:(Notification *)notification;

@end
