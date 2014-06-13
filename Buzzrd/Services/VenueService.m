//
//  VenueService.m
//  Buzzrd
//
//  Created by Brian Mancini on 6/1/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "VenueService.h"

@implementation VenueService


-(void)getVenues:(CLLocationCoordinate2D)location
          search:(NSString *)search
    includeRooms:(bool)includeRooms
         success:(void (^)(NSArray *theVenues))success
         failure:(void (^)(NSError *error))failure
{
    NSString *url = [self.apiURLBase stringByAppendingString:[NSString stringWithFormat:@"/api/venues/?lat=%f&lng=%f&includeRooms=%d&search=%@", location.latitude, location.longitude, includeRooms, [NSString emptyStringIfNil:search]]];
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    [manager
     GET:url
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
