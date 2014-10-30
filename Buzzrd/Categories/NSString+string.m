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

+ (NSString *) generateRandomString:(uint)length {
    NSMutableString *result = [NSMutableString stringWithCapacity:length];
    for(uint i = 0; i < length; i++) {
        [result appendFormat:@"%C", (unichar)('a' + arc4random_uniform(25))];
    }
    return result;
}


@end
