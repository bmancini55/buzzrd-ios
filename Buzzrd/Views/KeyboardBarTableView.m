//
//  KeyboardBarTableView.m
//  Buzzrd
//
//  Created by Brian Mancini on 10/5/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "KeyboardBarTableView.h"

@interface KeyboardBarTableView()

@property (nonatomic, readwrite, retain) KeyboardBarView *inputAccessoryView;

@end


@implementation KeyboardBarTableView

- (id)init {
    return [self initWithDelegate:nil];
}

- (id)initWithDelegate:(id<KeyboardBarDelegate>)delegate {
    self = [super init];
    if(self) {
        self.inputAccessoryView = [[KeyboardBarView alloc]init];
        self.inputAccessoryView.delegate = delegate;        
    }
    return self;
}

- (bool) canBecomeFirstResponder {
    return true;
}

@end
