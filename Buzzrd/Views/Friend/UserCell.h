//
//  UserCell.h
//  Buzzrd
//
//  Created by Robert Beck on 10/9/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface UserCell : UITableViewCell

@property (strong, nonatomic) User* user;

- (CGFloat)calculateHeight;

- (void)setUser:(User *)user;

@end
