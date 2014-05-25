//
//  FrameUtils.h
//  Buzzrd
//
//  Created by Brian Mancini on 5/13/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FrameUtils : NSObject

+(CGSize) getScreenSize;
+(CGSize) getStatusBarSize;
+(CGRect) getInnerFrame:(UINavigationBar *)navBar
                 tabBar:(UITabBar* )tabBar;

@end
