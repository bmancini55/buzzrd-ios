//
//  LoadingOverlay.h
//  Buzzrd
//
//  Created by Brian Mancini on 4/16/14.
//  Copyright (c) 2014 Buzzrd Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingOverlay : UIView

@property (strong, atomic) NSString *title;

-(void)show;
-(void)hide;

@end
