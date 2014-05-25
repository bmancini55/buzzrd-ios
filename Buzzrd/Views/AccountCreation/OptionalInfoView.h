//
//  OptionalInfoView.h
//  Buzzrd
//
//  Created by Robert Beck on 5/22/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionalInfoView : UIView

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITextField *firstNameTextField;
@property (strong, nonatomic) UITextField *lastNameTextField;
//@property (strong, nonatomic) UITextField *sexTextField;

@property (strong, nonatomic) UIButton *continueButton;

@end
