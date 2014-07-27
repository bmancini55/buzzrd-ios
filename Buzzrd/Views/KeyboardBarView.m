//
//  KeyboardBarView.m
//  Buzzrd
//
//  Created by Brian Mancini on 5/17/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "KeyboardBarView.h"
#import "ThemeManager.h"

@interface KeyboardBarView()

@property (strong, nonatomic) UIButton *mainButton;

@end


@implementation KeyboardBarView

const int MARGIN_SIZE = 6;
const int BUTTON_WIDTH = 52;

-(id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        // set view level properties
        self.backgroundColor = [ThemeManager getPrimaryColorMediumLight];
        
        // create the textbox
        self.textView = [[UITextView alloc] init];
        self.textView.frame = CGRectMake(40, MARGIN_SIZE, self.frame.size.width - 100, self.frame.size.height - (2 * MARGIN_SIZE));
        self.textView.editable = true;
        self.textView.keyboardType = UIKeyboardTypeDefault;
        self.textView.delegate = self;
        self.textView.backgroundColor = [UIColor whiteColor];
        self.textView.font = [ThemeManager getPrimaryFontRegular:15.0];
        self.textView.layer.masksToBounds = true;
        self.textView.layer.cornerRadius = 6.0f;
        self.textView.tintColor = [UIColor colorWithRed:242.0f/255.0f green:114.0f/255.0f blue:78.0f/255.0f alpha:1.0];
        [self addSubview:self.textView];
        
        // create the send button
        self.mainButton = [[UIButton alloc]init];
        self.mainButton.frame = CGRectMake(self.frame.size.width - BUTTON_WIDTH - MARGIN_SIZE, MARGIN_SIZE, BUTTON_WIDTH, self.frame.size.height - (2 * MARGIN_SIZE));
        self.mainButton.backgroundColor = [ThemeManager getPrimaryColorMedium];
        self.mainButton.titleLabel.font = [ThemeManager getPrimaryFontDemiBold:16.0];
        self.mainButton.layer.masksToBounds = true;
        self.mainButton.layer.cornerRadius = 6.0f;
        [self.mainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.mainButton setTitle:NSLocalizedString(@"post", nil) forState:UIControlStateNormal];
        [self.mainButton addTarget:self action:@selector(buttonTouchedAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mainButton];
        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
