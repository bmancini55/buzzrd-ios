//
//  NSDate+Helpers.m
//  Buzzrd
//
//  Created by Brian Mancini on 7/28/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "NSDate+Helpers.h"

@implementation NSDate (helpers)

- (NSDate *) initWithYear:(int)year month:(int)month day:(int)day {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc]init];
    components.year = year;
    components.month = month;
    components.day = day;
    return [calendar dateFromComponents:components];
}

- (NSDate *) getDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    return [calendar dateFromComponents:components];
}

- (NSDateComponents *) getComponents
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit units = NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit |
        NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSQuarterCalendarUnit |
        NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSYearForWeekOfYearCalendarUnit;
    return [calendar components:units fromDate:self];
}

- (bool) isToday
{
    NSDate *today = [[NSDate date ] getDate];
    NSComparisonResult result = [today compare:self];
    return  result == NSOrderedAscending ||
            result == NSOrderedSame;
}

- (bool) isYesterday
{
    NSDate *today = [[NSDate date ] getDate];
    NSDate *yesterday = [[[NSDate date ] getDate] dateByAddingTimeInterval:-1*24*60*60];
    return  [yesterday compare:self] == NSOrderedAscending &&
            [today compare:self] == NSOrderedDescending;
}

- (long) daysAgo
{
    NSDate *today = [[NSDate date] getDate];
    NSDate *myDate = [self getDate];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [calendar components:NSDayCalendarUnit
                       fromDate:myDate
                         toDate:today
                        options:0].day;
}


@end
