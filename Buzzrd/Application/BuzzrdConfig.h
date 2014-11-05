//
//  BuzzrdConfig.h
//  Buzzrd
//
//  Created by Brian Mancini on 10/3/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuzzrdConfig : NSObject

// PLIST properties
@property (strong, nonatomic) NSString *apiHost;
@property (nonatomic) long apiPort;
@property (nonatomic) bool apiUseTLS;
@property (strong, nonatomic) NSString *s3BucketUrl;

// Calculated properties
@property (nonatomic) bool apiUsesStandardPort;
@property (strong, nonatomic) NSString  *apiURLBase;
@property (strong, nonatomic) NSString  *apiProtocol;

@end
