//
//  Gender.m
//  Buzzrd
//
//  Created by Robert Beck on 5/26/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "Gender.h"

@implementation Gender

- (id)init
{
    self = [super init];
    return self;
}

- (id)initWithIdAndName:(NSNumber *)id_ name:(NSString *)name_
{
    self = [super init];
    if (self) {
        self.idgender = id_;
        self.name = name_;
    }
    return self;
}

@end
