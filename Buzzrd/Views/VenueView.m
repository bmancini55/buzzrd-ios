//
//  VenueView.m
//  Buzzrd
//
//  Created by Brian Mancini on 6/2/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "VenueView.h"
#import "FrameUtils.h"
#import "ProfileImageView.h"

@interface VenueView()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) ProfileImageView *categoryImage;

@end

@implementation VenueView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        

        
    }
    return self;
}

- (id)initWithVenue:(Venue *)venue
{
    const int HEIGHT = 50;
    CGSize screenSize = [FrameUtils getScreenSize];
    CGRect viewFrame = CGRectMake(0, 0, screenSize.width, HEIGHT);
    
    self = [super initWithFrame:viewFrame];
    if(self) {
        
        self.backgroundColor = [[UIColor alloc]initWithRed:241.0f/255.0f green:178.0f/255.0f blue:69.0f/255.0f alpha:1.0f];
        

        if(venue.categories.count > 0) {
            VenueCategory *primaryCategory = venue.categories[0];
            self.categoryImage = [[ProfileImageView alloc]initWithFrame:CGRectMake(3, 3, 44, 44)];
            [self.categoryImage loadImage:[NSString stringWithFormat:@"%@%@%@", primaryCategory.iconPrefix, @"88", primaryCategory.iconSuffix]];
            [self addSubview:self.categoryImage];
        }
        
        CGRect titleFrame = CGRectMake(55, 10, viewFrame.size.width - 60, 30);
        self.titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
        self.titleLabel.text = venue.name;
        [self addSubview:self.titleLabel];
    }
    return self;
}



@end
