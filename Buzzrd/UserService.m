//
//  UserService.m
//  Buzzrd
//
//  Created by Brian Mancini on 3/9/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "UserService.h"
#import "User.h"
#import "AFHTTPSessionManager.h"

@implementation UserService

+(User*)deserializeFromJson:(NSDictionary *)json
{
    User *user = [[User alloc] init];
    //user.iduser = json[@"_id"];
    user.username = json[@"username"];
    return user;
}

-(void)getUsers:(void (^)(NSArray *theUsers))success
        failure:(void (^)(NSError *error))failure;
{
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    [manager
     GET:[self.apiURLBase stringByAppendingString:@"/api/users"]
     parameters:nil
     success:^(NSURLSessionDataTask *task, id responseObject) {
         
         if([responseObject[@"success"] boolValue])
         {
             // parse users
             NSArray *results = responseObject[@"results"];
             NSMutableArray *temp = [[NSMutableArray alloc] init];
             for(NSDictionary *dic in results)
             {
                 User* user = [UserService deserializeFromJson:dic];
                 [temp addObject:user];
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

-(void)createUser:(User *)newUser
          success:(void (^)(User *createdUser))success
          failure:(void (^)(NSError *error))failure;

{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:newUser.username forKey:@"username"];
    [parameters setObject:newUser.password forKey:@"password"];
    [parameters setObject:newUser.firstName forKey:@"firstName"];
    [parameters setObject:newUser.lastName forKey:@"lastName"];
    [parameters setObject:newUser.sex forKey:@"sex"];
    
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager
     POST:[self.apiURLBase stringByAppendingString:@"/api/users"]
     parameters:parameters
     success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if([responseObject[@"success"] boolValue])
         {
             NSDictionary *json = responseObject[@"results"];
             User *user = [UserService deserializeFromJson:json];
             success(user);
             
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
