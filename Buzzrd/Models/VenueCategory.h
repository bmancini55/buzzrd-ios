//
//  VenueCategory.h
//  Buzzrd
//
//  Created by Brian Mancini on 6/1/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VenueCategory : NSObject

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *pluralName;
@property (strong, nonatomic) NSString *shortName;
@property (strong, nonatomic) NSString *iconPrefix;
@property (strong, nonatomic) NSString *iconSuffix;

-(id) initWithJson:(NSDictionary *)json;

@end
