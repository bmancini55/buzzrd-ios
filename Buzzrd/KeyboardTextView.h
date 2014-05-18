//
//  TextBarView.h
//  Buzzrd
//
//  Created by Brian Mancini on 5/17/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KeyboardTextView;

@protocol KeyboardTextViewDelegate

- (void)keyboardTextView:(KeyboardTextView *)keyboardTextView sendTouched:(NSString *)text;

@end


@interface KeyboardTextView : UIView <UITextViewDelegate>

@property (weak, nonatomic) id<KeyboardTextViewDelegate> delegate;
@property (strong, nonatomic) UITextView *textView;

-(void)dismissKeyboard;

@end
