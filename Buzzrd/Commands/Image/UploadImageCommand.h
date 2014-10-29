//
//  UploadImageCommand.h
//  Buzzrd
//
//  Created by Robert Beck on 7/1/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "CommandBase.h"

@interface UploadImageCommand : CommandBase

@property (strong, nonatomic) UIImage *image;

@end
