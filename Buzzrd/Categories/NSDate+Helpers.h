//
//  NSDate+Helpers.h
//  Buzzrd
//
//  Created by Brian Mancini on 7/28/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Helpers)

- (NSDate *) initWithYear:(int)year month:(int)month day:(int)day;
- (NSDate *) getDate;
- (NSDateComponents *) getComponents;
- (bool) isToday;
- (bool) isYesterday;
- (int) daysAgo;

@end
