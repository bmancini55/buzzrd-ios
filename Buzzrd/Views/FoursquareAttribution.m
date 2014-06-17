//
//  FoursquareAttribution.m
//  Buzzrd
//
//  Created by Brian Mancini on 6/16/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "FoursquareAttribution.h"

@interface FoursquareAttribution()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation FoursquareAttribution


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        
        CGSize imageSize = CGSizeMake(482, 121);
        
        float imageRatio = imageSize.width / imageSize.height;
        
        float newHeight = frame.size.height;
        float newWidth = frame.size.height * imageRatio;
        
        CGRect imageFrame = CGRectMake((frame.size.width / 2 ) - (newWidth / 2), 0, newWidth, newHeight);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:imageFrame];
        imageView.image = [UIImage imageNamed:@"poweredByFoursquare_gray.png"];
        
        [self addSubview:imageView];
    }
    return self;
}

@end
