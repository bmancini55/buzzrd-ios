//
//  ProfileImageView.m
//  Buzzrd
//
//  Created by Brian Mancini on 4/22/14.
//  Copyright (c) 2014 Buzzrd Inc. All rights reserved.
//

#import "ProfileImageView.h"
#import "AFHTTPSessionManager.h"

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


-(void)loadImage:(NSString *)url
{
    // verify we have a url
    if(url == nil)
        return;
    
    // check image cache and fetch from url if necessary
    UIImage *image = [[ProfileImageView imageCache] objectForKey:url];
    if(image == nil) {
        NSLog(@"Loading image: %@", url);
        [self fetchImage:url];
    } else {
        [self showImage:image];
    }
}

-(void)fetchImage:(NSString *)url
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    [manager GET:url
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
             
             // add to cache
             [[ProfileImageView imageCache] setObject:responseObject forKey:url];
             
             // show image
             [self showImage:(UIImage *)responseObject];
         }
         failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
             NSLog(@"Failed to load: %@", error);
         }];
}

-(void)showImage:(UIImage *)image
{
    // remove view if it already exists
    if(imageView != nil) {
        [imageView removeFromSuperview];
    }
    
    // add the new view
    imageView = [[UIImageView alloc]initWithImage:(UIImage *)image];
    [self addSubview:imageView];
}

@end
