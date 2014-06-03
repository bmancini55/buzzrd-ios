//
//  UIImage+thumbnail.h
//  Buzzrd
//
//  Created by Robert Beck on 5/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (thumbnail)

- (UIImage *) createThumbnail: (UIImage *) image withSide: (CGFloat) side;

@end
