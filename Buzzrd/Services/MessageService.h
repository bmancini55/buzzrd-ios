//
//  MessageService.h
//  Buzzrd
//
//  Created by Brian Mancini on 5/18/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "ServiceBase.h"
#import "Room.h"
#import "Message.h"

@interface MessageService : ServiceBase

- (void)getMessagesForRoom:(Room *)room
                      page:(uint)page
                   success:(void (^)(NSArray *messages))success
                   failure:(void (^)(NSError *error))failure;

@end
