//
//  RoomListView.m
//  Buzzrd
//
//  Created by Brian Mancini on 5/24/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import "RoomMainView.h"

@interface RoomMainView()

@end

@implementation RoomMainView

- (id) initWithFrame:(CGRect)frame delegate:(id<KeyboardBarDelegate, UITableViewDelegate, UITableViewDataSource>)delegate;
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // create the table view
        self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.tableView.delegate = delegate;
        self.tableView.dataSource = delegate;
        [self addSubview:self.tableView];
        
        // create the keyboard bar
        self.keyboardBarView = [[KeyboardBarView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-40,self.frame.size.width, 40)];
        self.keyboardBarView.delegate = delegate;
        [self addSubview:self.keyboardBarView];
        
        // adjust table view
        CGRect tableFrame = self.tableView.frame;
        tableFrame.size.height = tableFrame.size.height - self.keyboardBarView.frame.size.height;
        self.tableView.frame = tableFrame;
        
        // create hooks for keyboard to shrink table view on open/close
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onKeyboardOpen:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onKeyboardClose:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - Keyboard methods

-(void)onKeyboardOpen:(NSNotification *)notification
{
    // This code will move the keyboard
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
    
    CGRect newFrame = self.tableView.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height - self.keyboardBarView.frame.size.height;
    self.tableView.frame = newFrame;
    
    [UIView commitAnimations];
}

-(void)onKeyboardClose:(NSNotification *)notification
{
    NSDictionary *keyboardInfo = [notification userInfo];
    NSValue *keyboardFrameEnd = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameEndRect = [keyboardFrameEnd CGRectValue];
    
    CGRect newFrame = self.tableView.frame;
    newFrame.origin.y = keyboardFrameEndRect.origin.y - newFrame.size.height - self.keyboardBarView.frame.size.height;
}

@end
