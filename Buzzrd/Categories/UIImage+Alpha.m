//
//  UIImage+Alpha.m
//  Buzzrd
//
//  Created by Brian Mancini on 9/26/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//
//  Refer to http://stackoverflow.com/questions/5084845/how-to-set-the-opacity-alpha-of-a-uiimage

#import "UIImage+Alpha.h"

@implementation UIImage (Alpha)

- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
