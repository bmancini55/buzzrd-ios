//
//  LoadingOverlay.m
//  Buzzrd
//
//  Created by Brian Mancini on 4/16/14.
//  Copyright (c) 2014 Buzzrd Inc. All rights reserved.
//

#import "LoadingOverlay.h"
#import "FrameUtils.h"

@implementation LoadingOverlay
{
    UILabel *label;
    UIActivityIndicatorView *spinner;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        // configure view
        self.title = @"Loading...";
        self.opaque = false;

        
        // add the loading label
        label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;;
        label.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
        [self addSubview:label];
        
        // add the spinner
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self addSubview:spinner];
        [spinner startAnimating];
    }
    return self;
}


-(void)show
{
    // Animate fade-in
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [[self.superview layer] addAnimation:animation forKey:@"layerAnimation"];
    
    // Set the frame
    const CGFloat DEFAULT_WIDTH = 160;
    const CGFloat DEFAULT_HEIGHT = 120;
    CGRect frame = CGRectMake(self.superview.frame.size.width / 2 - DEFAULT_WIDTH / 2,
                              self.superview.frame.size.height / 2 - DEFAULT_HEIGHT / 2,
                              DEFAULT_WIDTH,
                              DEFAULT_HEIGHT);
    
    self.frame = frame;
    
    label.text = self.title;
    label.frame = CGRectMake(0, 25, DEFAULT_WIDTH, 20);
    spinner.frame = CGRectMake(0, 55, DEFAULT_WIDTH, spinner.frame.size.height);            
}

-(void)hide
{
    // Animate fade-out
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [[self.superview layer] addAnimation:animation forKey:@"layerAnimation"];
    
    // Remove
    [self removeFromSuperview];
}


CGPathRef roundedRectPath(CGRect rect, CGFloat cornerRadius)
{
	//
	// Create the boundary path
	//
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL,
                      rect.origin.x,
                      rect.origin.y + rect.size.height - cornerRadius);
    
	// Top left corner
	CGPathAddArcToPoint(path, NULL,
                        rect.origin.x,
                        rect.origin.y,
                        rect.origin.x + rect.size.width,
                        rect.origin.y,
                        cornerRadius);
    
	// Top right corner
	CGPathAddArcToPoint(path, NULL,
                        rect.origin.x + rect.size.width,
                        rect.origin.y,
                        rect.origin.x + rect.size.width,
                        rect.origin.y + rect.size.height,
                        cornerRadius);
    
	// Bottom right corner
	CGPathAddArcToPoint(path, NULL,
                        rect.origin.x + rect.size.width,
                        rect.origin.y + rect.size.height,
                        rect.origin.x,
                        rect.origin.y + rect.size.height,
                        cornerRadius);
    
	// Bottom left corner
	CGPathAddArcToPoint(path, NULL,
                        rect.origin.x,
                        rect.origin.y + rect.size.height,
                        rect.origin.x,
                        rect.origin.y,
                        cornerRadius);
    
	// Close the path at the rounded rect
	CGPathCloseSubpath(path);
	
	return path;
}


- (void)drawRect:(CGRect)rect
{
    rect.size.height -= 1;
    rect.size.width -= 1;
    
    const CGFloat RECT_PADDING = 5.0;
    rect = CGRectInset(rect, RECT_PADDING, RECT_PADDING);
    
    const CGFloat ROUND_RECT_CORNER_RADIUS = 5.0;
    CGPathRef roundRectPath = roundedRectPath(rect, ROUND_RECT_CORNER_RADIUS);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    const CGFloat BACKGROUND_OPACITY = 0.85;
    
    CGContextSetRGBFillColor(context, 97.0f/255.0f, 98.0f/255.0f, 100.0f/255.0f, BACKGROUND_OPACITY);
    CGContextAddPath(context, roundRectPath);
    CGContextFillPath(context);
    
    const CGFloat STROKE_OPACITY = 0.25;
    CGContextSetRGBStrokeColor(context, 0, 0, 0, STROKE_OPACITY);
    CGContextAddPath(context, roundRectPath);
    CGContextStrokePath(context);
    
    CGPathRelease(roundRectPath);
}


@end
