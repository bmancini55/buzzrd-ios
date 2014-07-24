//
//  UIView+UIView_Borders.m
//  Buzzrd
//
//  Created by Robert Beck on 7/23/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "UIView+UIView_Borders.h"

@implementation UIView (UIView_Borders)

- (void) addTopBorder:(UIColor *)color
                      width:(CGFloat) width
{
    [self addBorder:CGRectMake(0, 0, self.frame.size.width, width) andColor:color];
}

- (void) addRightBorder:(UIColor *)color
                  width:(CGFloat) width
{
    [self addBorder:CGRectMake(self.frame.size.width-width, 0, width, self.frame.size.height) andColor:color];
}

- (void) addBottomBorder:(UIColor *)color
                width:(CGFloat) width
{
    [self addBorder:CGRectMake(0, self.frame.size.height-width, self.frame.size.width, width) andColor:color];
}

- (void) addLeftBorder:(UIColor *)color
                width:(CGFloat) width
{
    [self addBorder:CGRectMake(0, 0, width, self.frame.size.height) andColor:color];
}

-(void) addBorder:(CGRect)frame andColor:(UIColor*)color
{
    CALayer *border = [CALayer layer];
    border.frame = frame;
    [border setBackgroundColor:color.CGColor];
    [self.layer addSublayer:border];
}
@end
