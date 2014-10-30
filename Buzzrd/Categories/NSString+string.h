//
//  NSString+string.h
//  Buzzrd
//
//  Created by Robert Beck on 6/12/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (string)

- (BOOL) isAlphaNumeric;

+ (NSString *) emptyStringIfNil:(NSString *)string;

+ (NSString *) generateRandomString:(uint)length;

@end
