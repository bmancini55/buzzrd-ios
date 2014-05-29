//
//  StaticData.h
//  Buzzrd
//
//  Created by Robert Beck on 5/26/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gender.h"

@interface StaticData : NSObject

+(void) initialize;

+(NSArray *) listOfGenders;

@end
