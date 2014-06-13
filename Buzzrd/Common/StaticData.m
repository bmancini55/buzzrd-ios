//
//  StaticData.m
//  Buzzrd
//
//  Created by Robert Beck on 5/26/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "StaticData.h"

@implementation StaticData

+(void) initialize {
    [self listOfGenders];
}

+(NSArray *) listOfGenders {
    
    static NSArray *sGenders;
    static dispatch_once_t sInitGenders;
    dispatch_once(&sInitGenders, ^{
        sGenders = [[NSArray alloc]
                    initWithObjects:
                    [[Gender alloc] initWithIdAndName:@1 name: NSLocalizedString(@"male", nil)],
                    [[Gender alloc] initWithIdAndName:@2 name: NSLocalizedString(@"female", nil)],
                    [[Gender alloc] initWithIdAndName:@0 name: NSLocalizedString(@"i_dont_want_to_tell", nil)]
                    , (void *)nil];
    });
    return sGenders;
}

@end
