//
//  NSMutableDictionary+Helpers.m
//  Buzzrd
//
//  Created by Robert Beck on 10/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "NSMutableDictionary+Helpers.h"
#import "NSObject+Helpers.h"

@implementation NSMutableDictionary (Helpers)

- (NSString *)toJson
{
    NSMutableArray *usersArray = [[NSMutableArray alloc] init];
    
    for(id key in self)
    {
        [usersArray addObject:[[self objectForKey:key] toDictionary]];
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:usersArray
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (! jsonData)
    {
        NSLog(@"An error ocurred while converting the NSMutableDictionary to json: %@", error);
        
        return nil;
    }
    else
    {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
}

@end
