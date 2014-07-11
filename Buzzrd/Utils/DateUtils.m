//
//  DateUtils.m
//  Buzzrd
//
//  Created by Brian Mancini on 5/18/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "DateUtils.h"

@implementation DateUtils


+(NSDate *) stringToLocalDate:(NSString *)dateString dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: date];
    
    return [NSDate dateWithTimeInterval: seconds sinceDate: date];
}

+ (NSDate *) parseMongoDateString:(NSString *)dateString
{
    return [DateUtils stringToLocalDate:dateString dateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
}

@end
