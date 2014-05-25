//
//  KeyboardBarView.m
//  Buzzrd
//
//  Created by Brian Mancini on 5/17/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "KeyboardBarView.h"

@interface KeyboardBarView()

@property (strong, nonatomic) UIButton *mainButton;

@end


@implementation KeyboardBarView

const int MARGIN_SIZE = 5;
const int BUTTON_WIDTH = 52;

-(id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        // set view level properties
        self.backgroundColor = [[UIColor alloc]initWithRed:225.0f/255.0f green:225.0f/255.0f blue:225.0f/255.0f alpha:1.0f];
        
        // create the textbox
        self.textView = [[UITextView alloc] init];
        self.textView.frame = CGRectMake(40, MARGIN_SIZE, self.frame.size.width - 100, self.frame.size.height - (2 * MARGIN_SIZE));
        self.textView.editable = true;
        self.textView.keyboardType = UIKeyboardTypeDefault;
        self.textView.delegate = self;
        self.textView.backgroundColor = [UIColor whiteColor];
        self.textView.layer.masksToBounds = true;
        self.textView.layer.cornerRadius = 5.0f;
        self.textView.layer.borderWidth = 1.0f;
        self.textView.layer.borderColor = [[UIColor alloc]initWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1.0f].CGColor;
        [self addSubview:self.textView];
        
        // create the send button
        self.mainButton = [[UIButton alloc]init];
        self.mainButton.frame = CGRectMake(self.frame.size.width - BUTTON_WIDTH - MARGIN_SIZE, MARGIN_SIZE, BUTTON_WIDTH, self.frame.size.height - (2 * MARGIN_SIZE));
        self.mainButton.backgroundColor = [UIColor orangeColor];
        self.mainButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        self.mainButton.layer.masksToBounds = true;
        self.mainButton.layer.cornerRadius = 5.0f;
        [self.mainButton setTitle:@"Send" forState:UIControlStateNormal];
        [self.mainButton addTarget:self action:@selector(buttonTouchedAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mainButton];
        
        // create hooks for keyboard
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidShowOrHide:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidShowOrHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - Instance Methods

- (void)dismissKeyboard
{
    [self.textView resignFirstResponder];
}

#pragma mark -  Action Handlers


-(void)buttonTouchedAction
{
    NSString *message = self.textView.text;
    self.textView.text = @"";
    
    // TODO reset the size of the textview
    
    [self.delegate keyboardBar:self buttonTouched:message];
}


#pragma mark - Keyboard methods

-(void)keyboardDidShowOrHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
 
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = self.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
    self.frame = newFrame;
    
    [UIView commitAnimations];
}


#pragma mark - UITextViewDelegate methods

-(BOOL)textViewShouldBeginEditing:(UITextView *)aTextView
{
    return true;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self.textView resignFirstResponder];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if(textView.frame.size.height != textView.contentSize.height)
    {
        float delta = textView.contentSize.height - textView.frame.size.height;
        
        // change textview size
        CGRect textViewFrame = textView.frame;
        textViewFrame.size.height = textView.contentSize.height;
        textView.frame = textViewFrame;
        
        // change view size
        CGRect inputFrame = self.frame;
        inputFrame.size.height = inputFrame.size.height + delta;
        inputFrame.origin.y = inputFrame.origin.y - delta;
        self.frame = inputFrame;
        
        // change button position
        CGRect buttonFrame = self.mainButton.frame;
        buttonFrame.origin.y = buttonFrame.origin.y + delta;
        self.mainButton.frame = buttonFrame;
    }
}




@end
