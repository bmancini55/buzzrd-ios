//
//  Message.h
//  Buzzrd
//
//  Created by Brian Mancini on 3/10/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BuzzrdAPI.h"

@interface Message : NSObject <NSCopying>

@property (strong, nonatomic) NSString *idmessage;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSDate *created;
@property (nonatomic) bool revealed;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *userName;
@property (nonatomic) uint upvoteCount;

- (id)initWithJson:(NSDictionary *)json;

- (bool)isMine;

@end
