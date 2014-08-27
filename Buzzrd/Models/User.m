//
//  User.m
//  Buzzrd
//
//  Created by Brian Mancini on 3/9/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "User.h"

@implementation User

-(id) init
{
    self = [super init];
    
    if (self = [super init])  {

    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.iduser forKey:@"iduser"];
    [coder encodeObject:self.username forKey:@"username"];
    [coder encodeObject:self.firstName forKey:@"firstName"];
    [coder encodeObject:self.lastName forKey:@"lastName"];
    [coder encodeObject:self.genderId forKey:@"genderId"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[User alloc] init];
    
    if (self != nil)
    {
        self.iduser = [coder decodeObjectForKey:@"iduser"];
        self.username = [coder decodeObjectForKey:@"username"];
        self.firstName = [coder decodeObjectForKey:@"firstName"];
        self.lastName = [coder decodeObjectForKey:@"lastName"];
        self.genderId = [coder decodeObjectForKey:@"genderId"];
    }
    
    return self;
}

-(id) initWithJson:(NSDictionary *)json
{
    self = [self init];
    if(self) {
        self.iduser = json[@"id"];
        self.username = json[@"username"];
        self.firstName = json[@"firstName"];
        self.lastName = json[@"lastName"];
        self.genderId = json[@"sex"];
        
    }
    return self;
}

-(id) copyWithZone: (NSZone *) zone
{
    User *userCopy = [[User allocWithZone: zone] init];
    
    userCopy.iduser = self.iduser;
    userCopy.username = self.username;
    userCopy.firstName = self.firstName;
    userCopy.lastName = self.lastName;
    userCopy.genderId = self.genderId;
    
    return userCopy;
}

@end
