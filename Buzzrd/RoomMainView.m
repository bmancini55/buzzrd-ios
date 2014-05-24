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

- (id) initWithFrame:(CGRect)frame
 keyboardBarDelegate:(id<KeyboardBarDelegate>)keyboardBarDelegate
   tableViewDelegate:(id<UITableViewDelegate>)tableViewDelegate
 tableViewDataSource:(id<UITableViewDataSource>)tableViewDataSource;
{
    self = [super initWithFrame:frame];
    if (self) {
        
        const int KEYBOARD_HEIGHT = 40;
        
        // create the table view
        CGRect tableFrame = frame;
        tableFrame.size.height = tableFrame.size.height - KEYBOARD_HEIGHT;
        self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.tableView.frame = tableFrame;
        self.tableView.delegate = tableViewDelegate;
        self.tableView.dataSource = tableViewDataSource;
        
        [self addSubview:self.tableView];
        
        // create the keyboard bar
        self.keyboardBarView = [[KeyboardBarView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-KEYBOARD_HEIGHT,self.frame.size.width, KEYBOARD_HEIGHT)];
        self.keyboardBarView.delegate = keyboardBarDelegate;
        [self addSubview:self.keyboardBarView];
        
        
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
