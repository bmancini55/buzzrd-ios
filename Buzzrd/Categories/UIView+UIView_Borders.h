//
//  UIView+UIView_Borders.h
//  Buzzrd
//
//  Created by Robert Beck on 7/23/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIView_Borders)

- (void) addTopBorder:(UIColor *)color
                      width:(CGFloat) width;

- (void) addRightBorder:(UIColor *)color
                  width:(CGFloat) width;

- (void) addBottomBorder:(UIColor *)color
                width:(CGFloat) width;

- (void) addLeftBorder:(UIColor *)color
                   width:(CGFloat) width;

@end
