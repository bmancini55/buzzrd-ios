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
#import "BuzzrdAPI.h"

@implementation UserService

+(User*)deserializeFromJson:(NSDictionary *)json
{
    User *user = [[User alloc] init];
    user.iduser = json[@"id"];
    user.username = json[@"username"];
    user.firstName = json[@"firstName"];
    user.lastName = json[@"lastName"];
    user.genderId = json[@"sex"];
    
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
     failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
         failure(error);
     }];
}

-(void)getUser:(NSString *)username
          success:(void (^)(User *user))success
          failure:(void (^)(NSError *error, id responseObject))failure;

{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:username forKey:@"username"];
    
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    [manager
     POST:[self.apiURLBase stringByAppendingString:@"/api/user"]
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
             failure(error, responseObject);
         }
     }
     failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject)
     {
         failure(error, responseObject);
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
    [parameters setObject:newUser.genderId forKey:@"sex"];
    
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
     failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject)
     {
         failure(error);
     }];
}

-(void)usernameExists:(NSString *)username
              success:(void (^)(bool))success
              failure:(void (^)(NSError *))failure;
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:username forKey:@"username"];
    
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager
     POST:[self.apiURLBase stringByAppendingString:@"/api/users/usernameExists"]
     parameters:parameters
     success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if([responseObject[@"success"] boolValue])
         {
             BOOL usernameExists = [responseObject[@"results"] boolValue];
             
             if (!usernameExists)
             {
                 success(false);
             }
             else
             {
                 NSError *error = [[NSError alloc]initWithDomain:@"buzzrd-api" code:1 userInfo:@{ NSLocalizedDescriptionKey: NSLocalizedString(@"username", nil), NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"username_not_unique", nil) }];
                 failure(error);
             }
         }
         else
         {
             NSError *error = [[NSError alloc]initWithDomain:@"buzzrd-api" code:1 userInfo:@{ NSLocalizedDescriptionKey: responseObject[@"error"] }];
             failure(error);
         }
     }
     failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject)
     {
         failure(error);
     }];
}

-(void)updateProfilePic:(NSString *)userId
               imageURI:(NSString *)imageURI
                success:(void (^)(NSString *userId))success
                failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:userId forKey:@"userId"];
    [parameters setObject:imageURI forKey:@"profilePic"];
    
    AFHTTPSessionManager *manager = [self getJSONRequestManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager
     POST:[self.apiURLBase stringByAppendingString:@"/api/users/updateProfilePic"]
     parameters:parameters
     success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if([responseObject[@"success"] boolValue])
         {
             NSString *userId = responseObject[@"results"];
             success(userId);
             
         } else {
             NSError *error = [[NSError alloc]initWithDomain:@"buzzrd-api" code:1 userInfo:@{ NSLocalizedDescriptionKey: responseObject[@"error"] }];
             failure(error);
         }
     }
     failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject)
     {
         failure(error);
     }];
}

-(void)login:(NSString *)username :(NSString *) password
     success:(void (^)(User *user))success
     failure:(void (^)(NSError *error, id responseObject))failure
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:@"password" forKey:@"grant_type"];
    [parameters setObject:username forKey:@"username"];
    [parameters setObject:password forKey:@"password"];
    
    // create new manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSString *authorizationString = @"Basic YTRjZTkzMmZiM2E2MjNmNDc4ZjUzZmExMTMxMjlmNzM6YjBhZGQxY2I4MmE5MzAyMDQ1MzQ1ZTdkOWNhYTEzODc5MjRmYmI1MTZhODZjZjk3MGYyNGIyM2MyYzQ0OGQyNWNmZDU3YTRjNGIwMzc4MDdjOGJiOTMwMjgyNGY0NzI3NzMzYTI1Yzc3YmRiYzVhYWFjNTZmM2ZkY2U3OWU5MTA=";
    
    [manager.requestSerializer setValue:authorizationString forHTTPHeaderField:@"Authorization"];
    
    [manager
     POST:[self.apiURLBase stringByAppendingString:@"/oauth/grant"]
     parameters:parameters
     success:^(NSURLSessionDataTask *task, id responseObject)
     {
         // Get the bearerToken from the response, set the authorization and store the token locally
         [BuzzrdAPI current].authorization = [[Authorization alloc]initWithBearerToken: responseObject[@"access_token"]];

         // Make the call to get the user info
         [[BuzzrdAPI current].userService
          getUser: username
          success:^(User* user)
          {
              if (user != nil)
              {
                  // Set the current user and store it in local storage
                  [BuzzrdAPI current].user = user;
                  
                  // Return the user
                  success(user);
              }
              else {
                  [BuzzrdAPI current].user = nil;
              }
          }
          failure:^(NSError *error, id responseObject) {
              failure(error, responseObject);
          }];
     }
     failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject)
     {
         failure(error, responseObject);
     }];
}

-(void)logout
{
    // Clear the local storage
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];

}

@end
