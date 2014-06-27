//
//  CommandDispatcher.h
//  Buzzrd
//
//  Created by Brian Mancini on 6/26/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommandDispatcher : NSObject

@property (strong, nonatomic) NSOperationQueue *commandQueue;

- (void) enqueueCommand:(NSOperation *)command;

@end
