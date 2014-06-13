//
//  ProfileImageViewController.h
//  Buzzrd
//
//  Created by Robert Beck on 5/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ImageService.h"
#import "User.h"

@interface ProfileImageViewController : BaseTableViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) User *user;

@end
