//
//  DownloadImageCommand.h
//  Buzzrd
//
//  Created by Robert Beck on 9/10/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "CommandBase.h"

@interface DownloadImageCommand : CommandBase

@property (strong, nonatomic) NSString *imageDownloadBaseUrl;
@property (strong, nonatomic) NSString *url;

@end
