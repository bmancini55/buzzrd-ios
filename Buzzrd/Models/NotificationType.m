//
//  NotificationType.m
//  Buzzrd
//
//  Created by Robert Beck on 10/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "NotificationType.h"

@implementation NotificationType

- (id)init
{
    self = [super init];
    return self;
}

- (id)initWithIdAndName:(NSNumber *)id_ name:(NSString *)name_
{
    self = [super init];
    if (self) {
        self.id = id_;
        self.name = name_;
    }
    return self;
}


@end
