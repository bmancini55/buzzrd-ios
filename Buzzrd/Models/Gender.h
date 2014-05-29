//
//  Gender.h
//  Buzzrd
//
//  Created by Robert Beck on 5/26/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Gender : NSObject

@property (strong, nonatomic) NSNumber *idgender;
@property (strong, nonatomic) NSString *name;

- (id)initWithIdAndName:(NSNumber *)id_ name:(NSString *)name_;

@end
