//
//  Message.h
//  FizBuz
//
//  Created by Brian Mancini on 3/10/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (strong, atomic) NSString *idmessage;
@property (strong, atomic) NSString *text;
@property (strong, atomic) NSDate *when;

@end
