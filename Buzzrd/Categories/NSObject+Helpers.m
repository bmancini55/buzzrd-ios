//
//  NSObject+Helpers.m
//  Buzzrd
//
//  Created by Robert Beck on 10/28/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "NSObject+Helpers.h"
#import <objc/runtime.h>

@implementation NSObject (Helpers)

- (NSDictionary *)toDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        
        id value = [self valueForKey:key];
        
        if (value != nil)
        {
            [dict setObject:[self valueForKey:key] forKey:key];
        }
        else{
            [dict setObject:[NSNull null] forKey:key];
        }
    }
    
    free(properties);
    
    return [NSDictionary dictionaryWithDictionary:dict];
    
    
    
//    NSArray *attributes = [[self.entity attributesByName] allKeys];
//    NSDictionary *dict = [self dictionaryWithValuesForKeys:attributes];
//    return dict;
}

@end
