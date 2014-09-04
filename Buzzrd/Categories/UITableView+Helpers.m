//
//  UITableView+Helpers.m
//  Buzzrd
//
//  Created by Brian Mancini on 9/4/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "UITableView+Helpers.h"

@implementation UITableView (Helpers)

// returns true if the table is currently scrolled to the bottom
- (bool) scrolledToBottom
{
    return self.contentOffset.y >= (self.contentSize.height - self.bounds.size.height);
}

@end
