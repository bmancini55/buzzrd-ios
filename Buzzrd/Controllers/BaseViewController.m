//
//  BaseViewController.m
//  Buzzrd
//
//  Created by Brian Mancini on 5/16/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "BaseViewController.h"
#import "ThemeManager.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

-(void)loadView
{
    [super loadView];
    
    [self.view setBackgroundColor: [ThemeManager getBackgroundColor]];
}

@end
