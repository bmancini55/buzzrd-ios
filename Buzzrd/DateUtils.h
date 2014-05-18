//
//  DateUtils.h
//  Buzzrd
//
//  Created by Brian Mancini on 5/18/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtils : NSObject

+(NSDate *) stringToLocalDate:(NSString *)dateString dateFormat:(NSString *)dateFormat;

@end
