//
//  Authorization
//  Buzzrd
//
//  Created by Brian Mancini on 5/24/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Authorization : NSObject

@property (strong, nonatomic) NSString *bearerToken;

- (id)initWithBearerToken:(NSString *)bearerToken;

@end
