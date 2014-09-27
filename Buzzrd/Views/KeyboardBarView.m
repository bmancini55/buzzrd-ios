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

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *mainButton;
@property (nonatomic) bool hasConstraints;

@property (nonatomic) bool pictureUpload;

@end


@implementation KeyboardBarView

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        // set view level properties
        self.backgroundColor = [ThemeManager getPrimaryColorMediumLight];
        self.frame = CGRectMake(0, 0, 360, 41 );
        self.pictureUpload = false;
        
        // create the image
        self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Camera.png"]];
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.imageView.hidden = !self.pictureUpload;
        [self addSubview:self.imageView];
        
        // create the textbox
        self.textView = [[PlaceholderTextView alloc] init];
        self.textView.translatesAutoresizingMaskIntoConstraints = NO;
        self.textView.editable = true;
        self.textView.keyboardType = UIKeyboardTypeDefault;
        self.textView.delegate = self;
        self.textView.backgroundColor = [UIColor whiteColor];
        self.textView.font = [ThemeManager getPrimaryFontRegular:15.0f];
        self.textView.layer.masksToBounds = true;
        self.textView.layer.cornerRadius = 6.0f;
        self.textView.textContainerInset = UIEdgeInsetsMake(5, 1, 3, 1);
        self.textView.tintColor = [ThemeManager getTertiaryColorDark];
        self.textView.placeholder = NSLocalizedString(@"keyboard_bar_placeholder", nil);
        [self addSubview:self.textView];
        
        
        // create the send button
        self.mainButton = [[UIButton alloc]init];
        self.mainButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.mainButton.backgroundColor = [ThemeManager getPrimaryColorMedium];
        self.mainButton.titleLabel.font = [ThemeManager getPrimaryFontDemiBold:16.0];
        self.mainButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.mainButton.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.mainButton.layer.masksToBounds = true;
        self.mainButton.layer.cornerRadius = 6.0f;
        [self.mainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.mainButton setTitle:NSLocalizedString(@"post", nil) forState:UIControlStateNormal];
        [self.mainButton addTarget:self action:@selector(buttonTouchedAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.mainButton];
        
        // force it to update constraints
        [self setNeedsUpdateConstraints];
        [self setNeedsLayout];
    }
    return self;
}

- (void) updateConstraints
{
    if(!self.hasConstraints) {
        self.hasConstraints = true;
        
        // horizontal constraints
        NSDictionary *hcon = @{ @"imageView": self.imageView, @"textView": self.textView, @"mainButton": self.mainButton };
        if(self.pictureUpload) {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[imageView(26)]-12-[textView]-6-[mainButton]-6-|" options:0 metrics:nil views:hcon]];
        } else {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-12-[textView]-6-[mainButton]-6-|" options:0 metrics:nil views:hcon]];
        }
        
        // vertical constraints
        if(self.pictureUpload) {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[imageView(19.5)]" options:0 metrics:nil views:@{ @"imageView": self.imageView }]];
        }
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[textView]-6-|" options:0 metrics:nil views:@{ @"textView": self.textView }]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[mainButton]-6-|" options:0 metrics:nil views:@{ @"mainButton": self.mainButton }]];
        
        // button label constraints
        NSDictionary *buttonConstraintView = @{ @"titleLabel": self.mainButton.titleLabel };
        [self.mainButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-6-[titleLabel(44)]-6-|" options:0 metrics:nil views:buttonConstraintView]];
        [self.mainButton addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[titleLabel]-6-|" options:0 metrics:nil views:buttonConstraintView]];
    }
    
    [super updateConstraints];
}

- (void) layoutIfNeeded
{
    float singleLineHeight = 29.0;
    float secondLineHeight = 16.0;
    float baseBarHeight = 41.0;
    
    if(self.textView.contentSize.height <= singleLineHeight || [self.textView.text isEqualToString:@""]) {
        CGRect frame = self.frame;
        frame.size.height = baseBarHeight;
        self.frame = frame;
    }
    else {
        CGRect frame = self.frame;
        frame.size.height = baseBarHeight + secondLineHeight;
        self.frame = frame;
    }
    [super layoutIfNeeded];
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
    
    if(![message isEqualToString:@""]) {
        [self.delegate keyboardBar:self buttonTouched:message];
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
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
    [self setNeedsLayout];
    [self layoutIfNeeded];
}




@end
