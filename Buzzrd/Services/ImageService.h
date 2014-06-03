//
//  ImageService.h
//  Buzzrd
//
//  Created by Robert Beck on 5/31/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceBase.h"

@interface ImageService : ServiceBase

-(void)uploadImage:(UIImage *)image
              success:(void (^)(NSString *imageURI))success
              failure:(void (^)(NSError *error))failure;

@end
