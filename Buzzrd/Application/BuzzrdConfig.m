//
//  BuzzrdConfig.m
//  Buzzrd
//
//  Created by Brian Mancini on 10/3/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "BuzzrdConfig.h"

@implementation BuzzrdConfig

- (id) init {
    self = [super init];
    if(self) {
        
        NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Buzzrd-Config" ofType:@"plist"]];
        
        self.apiHost = [plist objectForKey:@"API Host"];
        self.apiPort = [[plist objectForKey:@"API Port"] integerValue];
        self.apiUseTLS = [[plist objectForKey:@"API Use TLS"] boolValue];
    }
    return self;
}

- (bool) apiUsesStandardPort {
    return  (!self.apiUseTLS && self.apiPort == 80) ||
            (self.apiUseTLS && self.apiPort == 443);
}

- (NSString *) apiURLBase {
    if(self.apiUsesStandardPort) {
        return [NSString stringWithFormat:@"%@://%@", self.apiProtocol, self.apiHost];
    } else {
        return [NSString stringWithFormat:@"%@://%@:%lu", self.apiProtocol, self.apiHost, self.apiPort];
    }
}

- (NSString *) apiProtocol {
    return self.apiUseTLS ? @"https" : @"http";
}

@end
