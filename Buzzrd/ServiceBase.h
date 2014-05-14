//
//  ServiceBase.h
//  Buzzrd
//
//  Created by Brian Mancini on 5/13/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface ServiceBase : NSObject

@property (strong, nonatomic) NSString *apiURLBase;

- (AFHTTPSessionManager *) getJSONRequestManager;

@end
