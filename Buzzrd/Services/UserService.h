//
//  UserService.h
//  Buzzrd
//
//  Created by Brian Mancini on 3/9/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceBase.h"
#import "User.h"
#import "AFHTTPSessionManager.h"

@interface UserService : ServiceBase

-(void)getUsers:(void (^)(NSArray *theUsers))success
        failure:(void (^)(NSError *error))failure;

-(void)getUser:(NSString *)username
              success:(void (^)(User *user))success
              failure:(void (^)(NSError *error, id responseObject))failure;

-(void)createUser:(User *)newUser
          success:(void (^)(User *createdUser))success
          failure:(void (^)(NSError *error))failure;

-(void)usernameExists:(NSString *)username
              success:(void (^)(bool usernameExists))success
              failure:(void (^)(NSError *error))failure;

-(void)updateProfilePic:(NSString *)userId
               imageURI:(NSString *)imageURI
              success:(void (^)(NSString *userId))success
              failure:(void (^)(NSError *error))failure;

-(void)login:(NSString *)username :(NSString *) password
          success:(void (^)(User *user))success
          failure:(void (^)(NSError *error, id responseObject))failure;

-(void)logout;

@end
