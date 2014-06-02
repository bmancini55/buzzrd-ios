//
//  VenueService.m
//  Buzzrd
//
//  Created by Brian Mancini on 6/1/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "VenueService.h"

@implementation VenueService

-(void)getVenuesNearby:(CLLocationCoordinate2D)location
               success:(void (^)(NSArray *theVenues))success
               failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    [manager
     GET:[self.apiURLBase stringByAppendingString:[NSString stringWithFormat:@"/api/rooms/nearby?lat=%f&lng=%f", location.latitude, location.longitude]]
     parameters:nil
     success:^(NSURLSessionDataTask *task, id responseObject) {
         
         if([responseObject[@"success"] boolValue])
         {
             // parse results
             NSArray *results = responseObject[@"results"];
             NSMutableArray *temp = [[NSMutableArray alloc] init];
             for(NSDictionary *dic in results)
             {
                 Venue* instance = [[Venue alloc]initWithJson:dic];
                 [temp addObject:instance];
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
