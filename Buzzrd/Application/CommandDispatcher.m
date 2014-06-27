//
//  CommandDispatcher.m
//  Buzzrd
//
//  Created by Brian Mancini on 6/26/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "CommandDispatcher.h"

@implementation CommandDispatcher

- (id) init
{
    self = [super init];
    if(self) {
        self.commandQueue = [[NSOperationQueue alloc]init];
    }
    return self;
}


// Add to command to an operation queue
- (void) enqueueCommand:(NSOperation *)command {
    
    [self.commandQueue addOperation:command];
}

@end
