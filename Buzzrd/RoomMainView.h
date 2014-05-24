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

- (id) initWithFrame:(CGRect)frame delegate:(id<KeyboardBarDelegate, UITableViewDelegate, UITableViewDataSource>)delegate;

@property (strong, nonatomic) KeyboardBarView *keyboardBarView;
@property (strong, nonatomic) UITableView *tableView;

@end
