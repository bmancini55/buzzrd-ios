//
//  CreateFriendViewController.h
//  Buzzrd
//
//  Created by Robert Beck on 10/9/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "BaseTableViewController.h"
#import "User.h"

@interface CreateFriendViewController : BaseTableViewController <UISearchDisplayDelegate>

-(id)initWithCallback:(void (^)(User *created))onFriendCreated;

@property (strong, nonatomic) void(^onFriendCreated)(User *created);

@end
