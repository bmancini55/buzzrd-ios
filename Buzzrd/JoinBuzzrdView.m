//
//  JoinBuzzrdView.m
//  Buzzrd
//
//  Created by Robert Beck on 5/20/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "JoinBuzzrdView.h"

@implementation JoinBuzzrdView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *joinBuzzrdLbl = [ [UILabel alloc] initWithFrame:CGRectMake(0,100,self.frame.size.width,20)];
        [joinBuzzrdLbl setText:NSLocalizedString(@"join_buzzrd", nil)];
        joinBuzzrdLbl.textAlignment = NSTextAlignmentCenter;
        joinBuzzrdLbl.font = [UIFont boldSystemFontOfSize:17.0];
        [self addSubview:joinBuzzrdLbl];
        
        UILabel *createAccountSummaryLbl = [ [UILabel alloc] initWithFrame:CGRectMake(0,130,self.frame.size.width,20)];
        [createAccountSummaryLbl setText:NSLocalizedString(@"join_buzzrd_summary", nil)];
        createAccountSummaryLbl.textAlignment = NSTextAlignmentCenter;
        createAccountSummaryLbl.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:createAccountSummaryLbl];
        
        UILabel *createAccountDetailsLbl = [ [UILabel alloc] initWithFrame:CGRectMake(20.0,145,(self.frame.size.width-40.0),90)];
        [createAccountDetailsLbl setText:NSLocalizedString(@"join_buzzrd_detail", nil)];
        createAccountDetailsLbl.textAlignment = NSTextAlignmentCenter;
        createAccountDetailsLbl.font = [UIFont systemFontOfSize:12.0];
        createAccountDetailsLbl.numberOfLines = 0;
        [self addSubview:createAccountDetailsLbl];
        
        _getStartedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _getStartedButton.backgroundColor = [UIColor orangeColor];
        _getStartedButton.frame = CGRectMake(80, 235, 160, 40);
        [_getStartedButton setTitle:NSLocalizedString(@"get_started", nil) forState:UIControlStateNormal];
        [self addSubview:_getStartedButton];
    }
    
    return self;
}

@end
