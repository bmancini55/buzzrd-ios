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
        [self.tableView endEditing:true];
        
        [self addSubview:self.tableView];
        
        // create the keyboard bar
        self.keyboardBarView = [[KeyboardBarView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-KEYBOARD_HEIGHT,self.frame.size.width, KEYBOARD_HEIGHT)];
        self.keyboardBarView.delegate = keyboardBarDelegate;
        [self addSubview:self.keyboardBarView];
        
        
        // create hooks for keyboard to shrink table view on open/close
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Methods

- (void)scrollToBottom:(BOOL)animated
{
    NSInteger lastSection = [self.tableView.dataSource numberOfSectionsInTableView:self.tableView] - 1;
    NSInteger rowIndex = [self.tableView.dataSource tableView:self.tableView numberOfRowsInSection:lastSection] - 1;
    
    if(rowIndex >= 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:lastSection];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

#pragma mark - Keyboard methods

-(void)keyboardDidShowOrHide:(NSNotification *)notification
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
    newFrame.size.height = newFrame.origin.y + keyboardEndFrame.origin.y - self.keyboardBarView.frame.size.height;
    self.tableView.frame = newFrame;
    
    [UIView commitAnimations];
    [self scrollToBottom:false];
}


@end
