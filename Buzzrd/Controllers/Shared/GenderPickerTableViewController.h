//
//  GenderPickerTableViewController.h
//  Buzzrd
//
//  Created by Robert Beck on 5/26/14.
//  Copyright (c) 2014 Brian Mancini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "StaticData.h"
#import "Gender.h"

@protocol ProcessDataDelegate <NSObject>

-(void) processGenderPickerSuccessful:(NSNumber *)data;

@end

@interface GenderPickerTableViewController : BaseTableViewController

@property (weak, nonatomic) id<ProcessDataDelegate> delegate;
@property (strong, nonatomic) NSNumber *selectedGenderId;

@end
