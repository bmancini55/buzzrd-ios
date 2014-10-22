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
    
    NSData *test = [[ProfileImageView imageCache] objectForKey:url];
    UIImage *image = [[UIImage alloc] initWithData: test];

    // check image cache and fetch from url if necessary
//    UIImage *image = [UIImage imageWithData:[[ProfileImageView imageCache] objectForKey:url]];
    if(image == nil) {
        [self fetchImage:url];
    } else {
        [self showImage:image];
    }
}

-(void)fetchImage:(NSString *)url
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    [manager GET:url
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {

             UIImage *image = (UIImage *) responseObject;
            
             NSData *imgData = UIImagePNGRepresentation(image);
             
             // add to cache
             [[ProfileImageView imageCache] setValue:imgData forKey:url];
             
             // show image
             [self showImage:image];
         }
         failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
             NSLog(@"Failed to load: %@", error);
             [self showImage:[UIImage imageNamed:@"no_profile_pic.png"]];
         }];
}

-(void)showImage:(UIImage *)image
{
    // remove view if it already exists
    if(imageView != nil) {
        [imageView removeFromSuperview];
    }
    
    // add the new view
//    imageView = [[UIImageView alloc]initWithImage:(UIImage *)image];
    
    
        imageView = [[UIImageView alloc]initWithImage:image];
    
    imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:imageView];
}

@end
