//
//  BuzzrdBackgroundView.m
//  Buzzrd
//
//  Created by Brian Mancini on 8/9/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "BuzzrdBackgroundView.h"

@interface BuzzrdBackgroundView()

@property (strong, nonatomic) UIImageView *backgroundImage;

@end

@implementation BuzzrdBackgroundView

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void) setup
{
    self.backgroundColor = [UIColor whiteColor];
    self.backgroundImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Buzzrd_Silhouette.png"]];
    self.backgroundImage.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.backgroundImage];
    
    [self updateConstraints];
    
}

- (void) updateConstraints
{
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[image(274)]" options:0 metrics:nil views:@{ @"image": self.backgroundImage }]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[image(316)]" options:0 metrics:nil views:@{ @"image": self.backgroundImage }]];
    
    UIView *superview = self;
    UIView *image = self.backgroundImage;
    NSDictionary *variables = NSDictionaryOfVariableBindings(image, superview);
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[superview]-(<=1)-[image]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:variables]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[superview]-(<=1)-[image]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:variables]];
    
    [super updateConstraints];
}


@end
