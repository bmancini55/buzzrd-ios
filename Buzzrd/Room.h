//
//  Room.h
//  FizBuz
//
//  Created by Brian Mancini on 3/9/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Room : NSObject

@property (strong, nonatomic) NSNumber *idroom;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *lon;
@property (strong, nonatomic) NSNumber *lat;

@end
