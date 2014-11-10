//
//  CornerIndicator.m
//  Buzzrd
//
//  Created by Brian Mancini on 10/24/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "CornerIndicator.h"
#import "ThemeManager.h"

@implementation CornerIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.indicatorColor = [ThemeManager getTertiaryColorDark];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.indicatorColor.CGColor);

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 0, 0);
    CGPathAddLineToPoint(path, nil, 15, 0);
    CGPathAddLineToPoint(path, nil, 15, 15);
    
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    
    CGPathRelease(path);
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    [self setNeedsDisplay];
}

@end
