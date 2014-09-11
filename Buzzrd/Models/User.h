//
//  User.h
//  Buzzrd
//
//  Created by Brian Mancini on 3/9/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding, NSCopying>

@property (strong, nonatomic) NSString *iduser;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSNumber *genderId;
@property (strong, nonatomic) NSString *profilePic;

-(id) initWithJson:(NSDictionary *)json;
-(id) copyWithZone: (NSZone *) zone;

@end
