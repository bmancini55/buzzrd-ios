//
//  Authorization
//  Buzzrd
//
//  Created by Brian Mancini on 5/24/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "Authorization.h"

@implementation Authorization

- (id)initWithBearerToken:(NSString *)bearerToken
{
    self = [self init];
    if(self != nil)
    {
        self.bearerToken = bearerToken;
    }
    return self;
}

@end
