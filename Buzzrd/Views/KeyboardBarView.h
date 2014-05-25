//
//  KeyboardBarView.h
//  Buzzrd
//
//  Created by Brian Mancini on 5/17/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KeyboardBarView;

@protocol KeyboardBarDelegate

- (void)keyboardBar:(KeyboardBarView *)keyboardBarView buttonTouched:(NSString *)text;

@end


@interface KeyboardBarView : UIView <UITextViewDelegate>

@property (weak, nonatomic) id<KeyboardBarDelegate> delegate;
@property (weak, nonatomic) id accordianRelated;
@property (strong, nonatomic) UITextView *textView;

-(void)dismissKeyboard;

@end
