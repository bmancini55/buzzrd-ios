//
//  RoomService.m
//  Buzzrd
//
//  Created by Brian Mancini on 3/9/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "RoomService.h"
#import "Room.h"
#import "AFHTTPSessionManager.h"

@implementation RoomService

+(Room*)deserializeFromJson:(NSDictionary *)json
{
    Room *room = [[Room alloc] init];
    room.idroom = json[@"id"];		
    room.name = json[@"name"];
    room.lon = json[@"lon"];
    room.lat = json[@"lat"];
    return room;
}

-(void)getRooms:(void (^)(NSArray *theRooms))success
        failure:(void (^)(NSError *error))failure;
{
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    [manager
            GET:[self.apiURLBase stringByAppendingString:@"/api/rooms"]
     parameters:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {
         
            if([responseObject[@"success"] boolValue])
            {
                // parse rooms
                NSArray *results = responseObject[@"results"];
                NSMutableArray *temp = [[NSMutableArray alloc] init];
                for(NSDictionary *dic in results)
                {
                    Room* room = [RoomService deserializeFromJson:dic];
                    [temp addObject:room];
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

-(void)createRoom:(Room *)newRoom
          success:(void (^)(Room *createdRoom))success
          failure:(void (^)(NSError *error))failure;

{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:newRoom.name forKey:@"name"];
    [parameters setObject:newRoom.lon forKey:@"lon"];
    [parameters setObject:newRoom.lat forKey:@"lat"];
    
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager
        POST:[self.apiURLBase stringByAppendingString:@"/api/rooms"]
  parameters:parameters
     success:^(NSURLSessionDataTask *task, id responseObject)
     {
        if([responseObject[@"success"] boolValue])
        {
            NSDictionary *json = responseObject[@"results"];
            Room *room = [RoomService deserializeFromJson:json];
            success(room);
            
        } else {
            NSError *error = [[NSError alloc]initWithDomain:@"buzzrd-api" code:1 userInfo:@{ NSLocalizedDescriptionKey: responseObject[@"error"] }];
            failure(error);
        }
     }
     failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         failure(error);
     }];
}

@end
