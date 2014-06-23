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
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:[NSNumber numberWithFloat:location.latitude] forKey:@"lat"];
    [parameters setValue:[NSNumber numberWithFloat:location.longitude] forKey:@"lng"];
    [parameters setValue:[NSNumber numberWithBool:includeRooms] forKey:@"includeRooms"];
    [parameters setValue:[NSString emptyStringIfNil:search] forKey:@"search"];
    
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    [manager
     GET:[self.apiURLBase stringByAppendingString:@"/api/venues/"]
     parameters:parameters
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
