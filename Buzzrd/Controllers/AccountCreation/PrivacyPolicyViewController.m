//
//  PrivacyPolicyViewController.m
//  Buzzrd
//
//  Created by Robert Beck on 8/18/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "PrivacyPolicyViewController.h"
#import "ThemeManager.h"
#import "GetPrivacyPolicyCommand.h"
#import "BuzzrdAPI.h"

@interface PrivacyPolicyViewController ()

@property (strong, nonatomic) UILabel *privacyPolicyLbL;
@property (strong, nonatomic) UIScrollView *scrollView;
@property CGRect fullScreenRect;

@end

@implementation PrivacyPolicyViewController

-(void) loadView
{
    [super loadView];
    
    self.fullScreenRect=[[UIScreen mainScreen] applicationFrame];
    self.scrollView=[[UIScrollView alloc] initWithFrame:self.fullScreenRect];

    self.view = self.scrollView;
    
    [self.view setBackgroundColor: [ThemeManager getPrimaryColorLight]];
    
    self.title = NSLocalizedString(@"Privacy Policy", nil);
    
    self.privacyPolicyLbL = [[UILabel alloc] init];
    self.privacyPolicyLbL.font = [UIFont fontWithName:@"AvenirNext-Regular" size:10.0];
    self.privacyPolicyLbL.textColor = [ThemeManager getPrimaryColorDark];
    self.privacyPolicyLbL.numberOfLines = 0;
    [self.view addSubview:self.privacyPolicyLbL];
    
    GetPrivacyPolicyCommand *command = [[GetPrivacyPolicyCommand alloc]init];
    
    [command listenForCompletion:self selector:@selector(getPrivacyPolicyDidComplete:)];
    
    [[BuzzrdAPI dispatch] enqueueCommand:command];
}

- (void)getPrivacyPolicyDidComplete:(NSNotification *)notif
{
    GetPrivacyPolicyCommand *command = notif.object;
    if(command.status == kSuccess)
    {
        [self.privacyPolicyLbL setText:NSLocalizedString(command.results, nil)];
        
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.privacyPolicyLbL.text attributes:@ { NSFontAttributeName: self.privacyPolicyLbL.font }];
        
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.fullScreenRect.size.width-40,CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        CGSize labelsize = rect.size;
        
        int y=20;
        self.privacyPolicyLbL.frame=CGRectMake(20, y, self.fullScreenRect.size.width-40, labelsize.height);
        [self.privacyPolicyLbL setBackgroundColor:[UIColor clearColor]];
        
        self.scrollView.showsVerticalScrollIndicator = NO;
        y+=labelsize.height;
        [self.scrollView setContentSize:CGSizeMake(self.fullScreenRect.size.width-40,y+20)];
        [self.scrollView addSubview:self.privacyPolicyLbL];
    }
    else
    {
        [self showDefaultRetryAlert:command];
    }
}

@end
