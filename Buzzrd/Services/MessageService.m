//
//  MessageService.m
//  Buzzrd
//
//  Created by Brian Mancini on 5/18/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "MessageService.h"


@implementation MessageService

+(Message*) deserializeFromJson:(NSDictionary *)json
{
    Message *message = [[Message alloc] init];
    message.idmessage = json[@"id"];
    message.message = [NSString stringWithFormat:@"%@", json[@"message"]];
    message.created = [ServiceBase parseMongoDateString:json[@"created"]];
    
    return message;
}

- (void)getMessagesForRoom:(Room *)room
                      page:(uint)page
                   success:(void (^)(NSArray *messages))success
                   failure:(void (^)(NSError *error))failure
{
    NSString *url = [self.apiURLBase stringByAppendingString:[NSString stringWithFormat:@"/api/rooms/%@/messages?page=%d", room.id, page]];
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    [manager
     GET:url
     parameters:nil
     success:^(NSURLSessionDataTask *task, id responseObject) {
         
         if([responseObject[@"success"] boolValue])
         {
             // parse rooms
             NSArray *results = responseObject[@"results"];
             NSMutableArray *temp = [[NSMutableArray alloc] init];
             for(NSDictionary *dic in results)
             {
                 Message* message = [MessageService deserializeFromJson:dic];
                 [temp addObject:message];
             }
             results = [[NSArray alloc]initWithArray:temp];
             
             // call success callback
             success(results);
         } else
         {
             NSError *error = [[NSError alloc]initWithDomain:@"buzzrd-api" code:1 userInfo:@{ NSLocalizedDescriptionKey: responseObject[@"error"] }];
             failure(error);
         }
         
     }
     failure:^(NSURLSessionDataTask *task, NSError *error) {
         failure(error);
     }];
    
}

@end
