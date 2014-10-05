//
//  KeyboardBarTableView.h
//  Buzzrd
//
//  Created by Brian Mancini on 10/5/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardBarView.h"



@interface KeyboardBarTableView : UITableView

- (id)initWithDelegate:(id<KeyboardBarDelegate>)delegate;

@end
