//
//  PlaceholderTextView.m
//  Buzzrd
//
//  Created by Brian Mancini on 8/5/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "PlaceholderTextView.h"

@interface PlaceholderTextView()

@property (strong, nonatomic) UILabel *placeholderLabel;

@end

@implementation PlaceholderTextView

- (id) init {
    self = [super init];
    if(self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}


- (void)textChanged:(NSNotification *)notification
{
    if(self.placeholder.length == 0)
        return;
    
    [UIView animateWithDuration:0.1 animations:^{
        if(self.text.length == 0)
           [self showPlaceholder];
        else
            [self hidePlaceholder];
    }];
}

- (void)showPlaceholder
{
    [self.placeholderLabel setAlpha:1.0];
}

- (void)hidePlaceholder
{
    [self.placeholderLabel setAlpha:0];
}

- (void)drawRect:(CGRect)rect
{
    if(self.placeholder.length > 0) {
        if(self.placeholderLabel == nil) {
            self.placeholderLabel = [[UILabel alloc]initWithFrame:CGRectInset(self.frame, 0, -1)];
            self.placeholderLabel.font = self.font;
            self.placeholderLabel.textAlignment = self.textAlignment;
            self.placeholderLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
            [self addSubview:self.placeholderLabel];
        }
        
        self.placeholderLabel.text = self.placeholder;
        [self.placeholderLabel sizeToFit];
    }
    
    if(self.text.length == 0 && self.placeholder.length > 0)
       [self showPlaceholder];
    
    [super drawRect:rect];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
