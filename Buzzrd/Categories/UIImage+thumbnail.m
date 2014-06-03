//
//  UIImage+thumbnail.m
//  Buzzrd
//
//  Created by Robert Beck on 5/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "UIImage+thumbnail.h"

@implementation UIImage (thumbnail)

- (UIImage *) createThumbnail: (UIImage *) image withSide: (CGFloat) side {
    
    CGSize size = image.size;
    
    CGSize croppedSize;
    
    CGFloat x = 0.0;
    CGFloat y = 0.0;
    
    if (size.width > size.height) {
        x = (size.height - size.width) / 2;
        croppedSize = CGSizeMake(size.height, size.height);
    } else { // height > width
        y = (size.width - size.height) / 2;
        croppedSize = CGSizeMake(size.width, size.width);
    }
    
    CGRect clippedRect = CGRectMake((x * -1), (y * -1), croppedSize.width, croppedSize.height);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
    
    CGRect finalRect = CGRectMake(0, 0, side, side);
    
    UIGraphicsBeginImageContext(finalRect.size);
    
    [[UIImage imageWithCGImage:imageRef] drawInRect: finalRect];
    
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return thumbnail;
}


@end
