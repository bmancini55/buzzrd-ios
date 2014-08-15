//
//  AccessoryIndicatorView.m
//  Buzzrd
//
//  Created by Robert Beck on 8/14/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "AccessoryIndicatorView.h"

@implementation AccessoryIndicatorView

#define PADDING 4.f

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(context, 3.f);
    CGContextSetLineJoin(context, kCGLineJoinMiter);
    
    CGContextMoveToPoint(context, PADDING, PADDING);
    CGContextAddLineToPoint(context, self.frame.size.width - PADDING, self.frame.size.height/2);
    CGContextAddLineToPoint(context, PADDING, self.frame.size.height - PADDING);
    
    CGContextStrokePath(context);
}

@end
