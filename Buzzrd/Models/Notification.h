//
//  Notification.h
//  Buzzrd
//
//  Created by Robert Beck on 10/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notification : NSObject

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSNumber* typeId;
@property (strong, nonatomic) NSString *recipientId;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSDate *created;
@property (strong, nonatomic) NSDate *updated;
@property (nonatomic) bool read;
@property (nonatomic) uint badgeCount;
@property (strong, nonatomic) NSDictionary *payload;

-(id) initWithJson:(NSDictionary *)json;

@end
