//
//  RoomService.m
//  FizBuz
//
//  Created by Brian Mancini on 3/9/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "RoomService.h"
#import "Room.h"
#import "AFHTTPSessionManager.h"

@implementation RoomService

+(void)getRooms:(void (^)(NSArray *theRooms))callback
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager
     
            GET:@"http://derpturkey.listmill.com:8055/api/rooms"
     parameters:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {
         
            if(responseObject[@"success"])
            {
                // parse rooms
                NSArray *results = responseObject[@"results"];
                NSMutableArray *temp = [[NSMutableArray alloc] init];
                for(NSDictionary *dic in results)
                {
                    Room *room = [[Room alloc] init];
                    room.idroom = dic[@"_id"];
                    room.name = dic[@"name"];
                    room.lon = dic[@"lon"];
                    room.lat = dic[@"lat"];
                    [temp addObject:room];
                }
                results = [[NSArray alloc]initWithArray:temp];
             
                // fire rooms loaded event
                //[[NSNotificationCenter defaultCenter]
                // postNotificationName:@"RoomsLoadedSuccessfully"
                //            object:results];
                
                // return the results;
                callback(results);                
            } else
            {
             NSLog(@"Response was not successful");
            }
         
        }
        failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
}

@end
