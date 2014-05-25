//
//  RoomMainView.h
//  Buzzrd
//
//  Created by Brian Mancini on 5/24/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyboardBarView.h"


@interface RoomMainView : UIView

- (id) initWithFrame:(CGRect)frame
 keyboardBarDelegate:(id<KeyboardBarDelegate>)keyboardBarDelegate
   tableViewDelegate:(id<UITableViewDelegate>)tableViewDelegate
 tableViewDataSource:(id<UITableViewDataSource>)tableViewDataSource;

- (void)scrollToBottom:(BOOL)animated;

@property (strong, nonatomic) KeyboardBarView *keyboardBarView;
@property (strong, nonatomic) UITableView *tableView;

@end
