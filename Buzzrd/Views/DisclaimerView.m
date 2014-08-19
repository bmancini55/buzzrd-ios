//
//  DisclaimerView.m
//  Buzzrd
//
//  Created by Robert Beck on 8/17/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "BuzzrdNav.h"
#import "DisclaimerView.h"
#import "ThemeManager.h"
#import "UIWindow+Helpers.h"

@implementation DisclaimerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        By signing up, you agree to our Buzzrd Terms and that you have read our Privacy Policy.
        [self buildAgreeTextViewFromString:NSLocalizedString(@"By signing up, you agree to our <ts>Buzzrd Terms and that you have read our <pp>Privacy Policy", nil)];
    }
    return self;
}

- (void)buildAgreeTextViewFromString:(NSString *)localizedString
{
    // 1. Split the localized string on the # sign:
    NSArray *localizedStringPieces = [localizedString componentsSeparatedByString:@" "];
    
    // 2. Loop through all the pieces:
    NSUInteger msgChunkCount = localizedStringPieces ? localizedStringPieces.count : 0;
    CGPoint wordLocation = CGPointMake(0.0, 0.0);
    for (NSUInteger i = 0; i < msgChunkCount; i++)
    {
        NSString *chunk = [localizedStringPieces objectAtIndex:i];
        if ([chunk isEqualToString:@""])
        {
            continue;     // skip this loop if the chunk is empty
        }
        
        // 3. Determine what type of word this is:
        BOOL isTermsOfServiceLink = [chunk hasPrefix:@"<ts>"];
        BOOL isPrivacyPolicyLink  = [chunk hasPrefix:@"<pp>"];
        BOOL isLink = (BOOL)(isTermsOfServiceLink || isPrivacyPolicyLink);
        
        chunk = [chunk stringByAppendingString:@" "];
        
        if (isTermsOfServiceLink)
        {
            chunk = [chunk stringByAppendingString:[localizedStringPieces objectAtIndex:(++i)]];
            chunk = [chunk stringByAppendingString:@" "];
        }
        else if (isPrivacyPolicyLink) {
            chunk = [chunk stringByAppendingString:[localizedStringPieces objectAtIndex:(++i)]];
        }
        
        // 4. Create label, styling dependent on whether it's a link:
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:@"AvenirNext-Regular" size:11.0];
        label.text = chunk;
        label.userInteractionEnabled = isLink;
        
        if (isLink)
        {
            label.textColor = [UIColor colorWithRed:110/255.0f green:181/255.0f blue:229/255.0f alpha:1.0];
            label.highlightedTextColor = [UIColor yellowColor];
            
            // 5. Set tap gesture for this clickable text:
            SEL selectorAction = isTermsOfServiceLink ? @selector(tapOnTermsOfServiceLink:) : @selector(tapOnPrivacyPolicyLink:);
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                         action:selectorAction];
            [label addGestureRecognizer:tapGesture];
            
            // Trim the markup characters from the label:
            if (isTermsOfServiceLink) label.text = [label.text stringByReplacingOccurrencesOfString:@"<ts>" withString:@""];
            if (isPrivacyPolicyLink)  label.text = [label.text stringByReplacingOccurrencesOfString:@"<pp>" withString:@""];
        }
        else
        {
            label.textColor = [ThemeManager getPrimaryColorDark];
        }
        
        // 6. Lay out the labels so it forms a complete sentence again:
        
        // If this word doesn't fit at end of this line, then move it to the next
        // line and make sure any leading spaces are stripped off so it aligns nicely:
        
        [label sizeToFit];
        
        if (self.frame.size.width < wordLocation.x + label.bounds.size.width)
        {
            wordLocation.x = 0.0;                       // move this word all the way to the left...
            wordLocation.y += label.frame.size.height;  // ...on the next line
            
            // And trim of any leading white space:
            NSRange startingWhiteSpaceRange = [label.text rangeOfString:@"^\\s*"
                                                                options:NSRegularExpressionSearch];
            if (startingWhiteSpaceRange.location == 0)
            {
                label.text = [label.text stringByReplacingCharactersInRange:startingWhiteSpaceRange
                                                                 withString:@""];
                [label sizeToFit];
            }
        }
        
        // Set the location for this label:
        label.frame = CGRectMake(wordLocation.x,
                                 wordLocation.y,
                                 label.frame.size.width,
                                 label.frame.size.height);

        // Show this label:
        [self addSubview:label];
        
        // Update the horizontal position for the next word:
        wordLocation.x += label.frame.size.width;
    }
}

- (void)tapOnTermsOfServiceLink:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.state == UIGestureRecognizerStateEnded)
    {
        TermsOfServiceViewController *termsOfServiceController = [BuzzrdNav termsOfServiceViewController];
        
        UIViewController *visibleViewController = [self.window visibleViewController];
        
        [visibleViewController.navigationController pushViewController:termsOfServiceController animated:YES];
    }
}


- (void)tapOnPrivacyPolicyLink:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.state == UIGestureRecognizerStateEnded)
    {
        PrivacyPolicyViewController *privacyPolicyViewController = [BuzzrdNav privacyPolicyViewController];
        
        UIViewController *visibleViewController = [self.window visibleViewController];
        
        [visibleViewController.navigationController pushViewController:privacyPolicyViewController animated:YES];
    }
}

@end
