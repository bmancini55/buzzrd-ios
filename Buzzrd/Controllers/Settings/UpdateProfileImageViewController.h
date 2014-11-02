//
//  UpdateProfileImageViewController.h
//  Buzzrd
//
//  Created by Robert Beck on 9/6/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "BaseViewController.h"
#import "User.h"

@interface UpdateProfileImageViewController : BaseViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) void(^onProfilePicUpdated)(UIImage *profilePic);

@end
