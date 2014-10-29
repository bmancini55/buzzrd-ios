//
//  NotificationType.h
//  Buzzrd
//
//  Created by Robert Beck on 10/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationType : NSObject

@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *name;

- (id)initWithIdAndName:(NSNumber *)id_ name:(NSString *)name_;

@end
