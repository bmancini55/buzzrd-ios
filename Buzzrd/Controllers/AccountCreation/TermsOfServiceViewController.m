//
//  TermsOfServiceViewController.m
//  Buzzrd
//
//  Created by Robert Beck on 8/18/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "TermsOfServiceViewController.h"
#import "ThemeManager.h"
#import "GetTermsOfServiceCommand.h"
#import "BuzzrdAPI.h"

@interface TermsOfServiceViewController ()

@property (strong, nonatomic) UILabel *buzzrdTermsLbL;
@property (strong, nonatomic) UIScrollView *scrollView;
@property CGRect fullScreenRect;

@end

@implementation TermsOfServiceViewController

-(void) loadView
{
    [super loadView];
    
    self.fullScreenRect=[[UIScreen mainScreen] applicationFrame];
    self.scrollView=[[UIScrollView alloc] initWithFrame:self.fullScreenRect];
    
    self.view = self.scrollView;
    
    [self.view setBackgroundColor: [ThemeManager getPrimaryColorLight]];
    
    self.title = NSLocalizedString(@"Buzzrd Terms", nil);
    
    self.buzzrdTermsLbL = [[UILabel alloc] init];
    self.buzzrdTermsLbL.font = [UIFont fontWithName:@"AvenirNext-Regular" size:10.0];
    self.buzzrdTermsLbL.textColor = [ThemeManager getPrimaryColorDark];
    self.buzzrdTermsLbL.numberOfLines = 0;
    [self.view addSubview:self.buzzrdTermsLbL];
        
    GetTermsOfServiceCommand *command = [[GetTermsOfServiceCommand alloc]init];
    
    [command listenForCompletion:self selector:@selector(getTermsOfServiceDidComplete:)];
    
    [[BuzzrdAPI dispatch] enqueueCommand:command];
}

- (void)getTermsOfServiceDidComplete:(NSNotification *)notif
{
    GetTermsOfServiceCommand *command = notif.object;
    if(command.status == kSuccess)
    {
        [self.buzzrdTermsLbL setText:NSLocalizedString(command.results, nil)];
        
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.buzzrdTermsLbL.text attributes:@ { NSFontAttributeName: self.buzzrdTermsLbL.font }];
        
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.fullScreenRect.size.width-40,CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        CGSize labelsize = rect.size;
        
        int y=20;
        self.buzzrdTermsLbL.frame=CGRectMake(20, y, self.fullScreenRect.size.width-40, labelsize.height);
        [self.buzzrdTermsLbL setBackgroundColor:[UIColor clearColor]];
        
        self.scrollView.showsVerticalScrollIndicator = NO;
        y+=labelsize.height;
        [self.scrollView setContentSize:CGSizeMake(self.fullScreenRect.size.width-40,y+20)];
        [self.scrollView addSubview:self.buzzrdTermsLbL];
            }
    else
    {
        [self showDefaultRetryAlert:command];
    }
}


@end
