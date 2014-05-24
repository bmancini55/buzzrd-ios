//
//  OptionalInfoViewController.h
//  Buzzrd
//
//  Created by Robert Beck on 5/22/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "OptionalInfoView.h"
#import "AccountCreationBaseViewController.h"

@interface OptionalInfoViewController : AccountCreationBaseViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    OptionalInfoView *mainView;
}

@property (strong, nonatomic) UITextField *firstNameTextField;
@property (strong, nonatomic) UITextField *lastNameTextField;
@property (strong, nonatomic) UITextField *genderTextField;

@property (strong, nonatomic) UIButton *saveButton;

@end