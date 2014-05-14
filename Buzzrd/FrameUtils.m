//
//  FrameUtils.m
//  Buzzrd
//
//  Created by Brian Mancini on 5/13/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "FrameUtils.h"

@implementation FrameUtils

+(CGSize) getScreenSize
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    //CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize screenSize = CGSizeMake(screenBounds.size.width, screenBounds.size.height);
    
    return screenSize;
}

+(CGSize) getStatusBarSize
{
    return [UIApplication sharedApplication].statusBarFrame.size;
}

+(CGRect) getInnerFrame:(UINavigationBar *)navBar
                 tabBar:(UITabBar* )tabBar
{
    CGSize screenSize = [FrameUtils getScreenSize];
    float statusBarHeight = [FrameUtils getStatusBarSize].height;
    float navBarHeight = navBar.frame.size.height;
    float tabBarHeight = tabBar.frame.size.height;
    
    return CGRectMake(0,
                      statusBarHeight + navBarHeight,
                      screenSize.width,
                      screenSize.height - statusBarHeight - navBarHeight - tabBarHeight);
    
}

@end
