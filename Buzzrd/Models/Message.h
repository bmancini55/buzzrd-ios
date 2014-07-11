//
//  Message.h
//  Buzzrd
//
//  Created by Brian Mancini on 3/10/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject <NSCopying>

@property (strong, nonatomic) NSString *idmessage;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSDate *created;

- (id)initWithJson:(NSDictionary *)json;

@end
