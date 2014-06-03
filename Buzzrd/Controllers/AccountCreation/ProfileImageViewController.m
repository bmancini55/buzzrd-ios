//
//  ProfileImageViewController.m
//  Buzzrd
//
//  Created by Robert Beck on 5/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "ProfileImageViewController.h"
#import "UIImage+thumbnail.h"
#import "BuzzrdAPI.h"

@interface ProfileImageViewController ()

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UIImage *thumbnail;

@end

@implementation ProfileImageViewController

-(void) loadView
{
    [super loadView];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTouch)];
    self.navigationItem.leftBarButtonItem = cancelItem;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"done", nil) style:UIBarButtonItemStylePlain target:self action:@selector(doneTouch)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    UILabel *accountSavedMessageLbl = [ [UILabel alloc] initWithFrame:CGRectMake(20.0,80,(self.view.frame.size.width-40.0),90)];
    [accountSavedMessageLbl setText:NSLocalizedString(@"account_created_successfully", nil)];
    accountSavedMessageLbl.textAlignment = NSTextAlignmentCenter;
    accountSavedMessageLbl.font = [UIFont systemFontOfSize:14.0];
    accountSavedMessageLbl.numberOfLines = 0;
    [self.view addSubview:accountSavedMessageLbl];
    
    UIView *profilePicContainerView =[[UIView alloc] initWithFrame: CGRectMake(0, 0, 88, 88)];
    profilePicContainerView.backgroundColor=[UIColor redColor];
    profilePicContainerView.clipsToBounds = YES;
    profilePicContainerView.contentMode = UIViewContentModeScaleAspectFill;
    [profilePicContainerView setCenter: CGPointMake(self.view.frame.size.width / 2, 230)];
    [self.view addSubview:profilePicContainerView];
    
    self.profileImageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, 88, 88)];
    self.profileImageView.image = [UIImage imageNamed:@"no_profile_pic.jpg"];
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    [profilePicContainerView addSubview:self.profileImageView];
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profilePicContainerViewSingleTap:)];
    [profilePicContainerView addGestureRecognizer:singleFingerTap];
}

- (UIImagePickerController *) imagePicker {
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }

    return _imagePicker;
}

- (void)profilePicContainerViewSingleTap:(UITapGestureRecognizer *)recognizer {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"No Camera Detected");
        
        //return;
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Take a Photo", @"Use Photo Library", nil];
    [actionSheet showInView:self.view];
}

- (void) pickPhotoFromLibrary {
    
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self.navigationController presentViewController: self.imagePicker animated:YES completion:nil];
}

- (void) takePhotoWithCamera {
    
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self.navigationController presentViewController: self.imagePicker animated:YES completion:nil];
}

- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == actionSheet.cancelButtonIndex) return;
    
    switch (buttonIndex) {
        case 0:
            [self takePhotoWithCamera];
            break;
        case 1:
            [self pickPhotoFromLibrary];
            break;
        default:
            break;
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated: YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    CGFloat side = 72.f;
    
    side *= [[UIScreen mainScreen]scale];
    
    _thumbnail = [image createThumbnail:image withSide:side];
    
    self.profileImageView.image = _thumbnail;
}

-(void) cancelTouch
{
    [self dismissViewControllerAnimated:false completion:nil];
}

-(void) doneTouch
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    // upload the image to the buzzrd server
    [[BuzzrdAPI current].imageService uploadImage:_thumbnail
     success:^(NSString *imageURI) {
         
         // Update the location of the user's profile pic
         [[BuzzrdAPI current].userService
          updateProfilePic:self.user.iduser imageURI:imageURI success:^(NSString *userId) {                  [[UIApplication sharedApplication] endIgnoringInteractionEvents];
              [self dismissViewControllerAnimated:false completion:nil];
          } failure:^(NSError *error) {
              [[UIApplication sharedApplication] endIgnoringInteractionEvents];
              UIAlertView* alert = [[UIAlertView alloc] initWithTitle: error.localizedDescription message: error.localizedFailureReason delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
              [alert show];
          }];
     }
     failure:^(NSError *error) {
         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
         UIAlertView* alert = [[UIAlertView alloc] initWithTitle: error.localizedDescription message: error.localizedFailureReason delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         [alert show];
     }];
}

@end
