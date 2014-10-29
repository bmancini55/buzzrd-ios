//
//  ProfileImageView.m
//  Buzzrd
//
//  Created by Brian Mancini on 4/22/14.
//  Copyright (c) 2014 Buzzrd Inc. All rights reserved.
//

#import "ProfileImageView.h"
#import "AFHTTPSessionManager.h"
#import "BuzzrdAPI.h"
#import "UIImageView+WebCache.h"

@interface ProfileImageView()

+(NSMutableDictionary *)imageCache;

@end

@implementation ProfileImageView
{
    UIImageView *imageView;
}

+(NSMutableDictionary *)imageCache
{
    static NSMutableDictionary *imageCacheSingleton = nil;
    
    if(imageCacheSingleton == nil)
        imageCacheSingleton = [[NSMutableDictionary alloc]init];
    
    return imageCacheSingleton;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


-(void)loadImageFromUrl:(NSString *)url
{
    // remove view if it already exists
    if(imageView != nil) {
        [imageView removeFromSuperview];
    }
    
    // add the new view
    imageView = [[UIImageView alloc] init];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageCacheMemoryOnly];
    
    imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:imageView];
}

-(void)loadImage:(UIImage *)image
{
    // remove view if it already exists
    if(imageView != nil) {
        [imageView removeFromSuperview];
    }
    
    // add the new view
    imageView = [[UIImageView alloc]initWithImage:(UIImage *)image];
    
    imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:imageView];
}

@end
