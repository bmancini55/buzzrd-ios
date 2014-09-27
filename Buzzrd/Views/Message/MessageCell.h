//
//  MessageCell.h
//  Buzzrd
//
//  Created by Brian Mancini on 7/24/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface MessageCell : UITableViewCell

- (id)initWithMyMessage:(bool)myMessage revealedMessage:(bool)revealedMessage;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier myMessage:(bool)myMessage revealedMessage:(bool)revealedMessage;

@property (strong, nonatomic) Message *message;

@end
