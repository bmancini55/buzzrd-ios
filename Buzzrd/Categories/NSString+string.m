//
//  NSString+string.m
//  Buzzrd
//
//  Created by Robert Beck on 6/12/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "NSString+string.h"

@implementation NSString (string)

- (BOOL) isAlphaNumeric
{
    NSCharacterSet *unwantedCharacters =
    [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    
    return ([self rangeOfCharacterFromSet:unwantedCharacters].location == NSNotFound);
}

+ (NSString *) emptyStringIfNil:(NSString *)string
{
    return string ? string : @"";
}


@end
