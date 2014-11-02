//
//  UpdateProfileImageViewController.m
//  Buzzrd
//
//  Created by Robert Beck on 9/6/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "UpdateProfileImageViewController.h"
#import "UIImage+thumbnail.h"
#import "BuzzrdNav.h"
#import "BuzzrdAPI.h"
#import "UploadImageCommand.h"
#import "UpdateProfilePicCommand.h"
#import "ThemeManager.h"
#import "DownloadImageCommand.h"

@interface UpdateProfileImageViewController ()

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) UIButton *savePicButton;

@end

@implementation UpdateProfileImageViewController

-(void) loadView
{
    [super loadView];
    
    [self.view setBackgroundColor: [ThemeManager getPrimaryColorLight]];
    
    UIView *profilePicContainerView =[[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2) - (72),100,144,144)];
    [self.view addSubview:profilePicContainerView];
    
    self.profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,144,144)];
    self.profileImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.profileImageView.image = [UIImage imageNamed:@"no_profile_pic.png"];
    self.profileImageView.layer.borderColor = [ThemeManager getPrimaryColorMedium].CGColor;
    self.profileImageView.layer.borderWidth = 1;
    [profilePicContainerView addSubview:self.profileImageView];
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profilePicContainerViewSingleTap:)];
    [profilePicContainerView addGestureRecognizer:singleFingerTap];
    
    self.savePicButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.savePicButton setTitle: NSLocalizedString(@"SAVE PROFILE PICTURE", nil) forState:UIControlStateNormal];
    self.savePicButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.savePicButton.backgroundColor = [ThemeManager getSecondaryColorMedium];
    self.savePicButton.titleLabel.font = [ThemeManager getPrimaryFontDemiBold:15.0];
    [self.savePicButton addTarget:self action:@selector(savePicButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [self.savePicButton setTitleColor:[ThemeManager getPrimaryColorLight] forState:UIControlStateNormal];
    self.savePicButton.layer.cornerRadius = 5;
    self.savePicButton.enabled = false;
    [self.view addSubview:self.savePicButton];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[savePicButton]-20-|" options:0 metrics:nil views:@{ @"savePicButton" : self.savePicButton }]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[profilePicContainerView]-25-[savePicButton]" options:0 metrics:nil views:@{ @"profilePicContainerView" : profilePicContainerView, @"savePicButton" : self.savePicButton }]];
    
    if ([BuzzrdAPI current].user.profilePic != nil){
        if ([BuzzrdAPI current].profilePic == nil) {
            DownloadImageCommand *command = [[DownloadImageCommand alloc]init];
            command.url = [BuzzrdAPI current].user.profilePic;
            
            [command listenForCompletion:self selector:@selector(downloadImageDidComplete:)];
            
            [[BuzzrdAPI dispatch] enqueueCommand:command];
        }
        else {
            self.profileImageView.image = [BuzzrdAPI current].profilePic;
        }
    }
}

- (void)downloadImageDidComplete:(NSNotification *)notif
{
    DownloadImageCommand *command = notif.object;
    if(command.status == kSuccess)
    {
        self.profileImageView.image = command.results;
        [BuzzrdAPI current].profilePic = command.results;
    }
    else
    {
        [self showRetryAlertWithTitle:NSLocalizedString(@"Unexpected Error", nil)
                              message:NSLocalizedString(@"An unexpected error occurred while processing your request", nil)
                       retryOperation:command];
    }
}

- (UIImagePickerController *) imagePicker {
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}

- (void)profilePicContainerViewSingleTap:(UITapGestureRecognizer *)recognizer {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) destructiveButtonTitle:nil otherButtonTitles: NSLocalizedString(@"take_a_photo", nil), NSLocalizedString(@"use_photo_library", nil), nil];
    [actionSheet showInView:self.view];
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            [button setTitleColor:[ThemeManager getSecondaryColorMedium] forState:UIControlStateNormal];
        }
    }
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
    
    self.savePicButton.enabled = true;
}

-(void) savePicButtonTouch
{
    if (_thumbnail != nil){
        
        UploadImageCommand *command = [[UploadImageCommand alloc]init];
        command.image = _thumbnail;
        [command listenForCompletion:self selector:@selector(getImageUploadDidComplete:)];
        
        [[BuzzrdAPI dispatch] enqueueCommand:command];
    }
    else
    {
        [self hideActivityView];
        [self dismissViewControllerAnimated:false completion:nil];
    }
}

- (void)getImageUploadDidComplete:(NSNotification *)notif
{
    UploadImageCommand *command = notif.object;
    
    if(command.status == kSuccess)
    {
        UpdateProfilePicCommand *profilePicCommand = [[UpdateProfilePicCommand alloc]init];
        profilePicCommand.iduser = [BuzzrdAPI current].user.iduser;
        profilePicCommand.imageURI = command.results;
        [profilePicCommand listenForCompletion:self selector:@selector(updateProfilePicDidComplete:)];
        
        [BuzzrdAPI current].user.profilePic = command.results;
        [BuzzrdAPI current].profilePic = _thumbnail;
        
        [[BuzzrdAPI dispatch] enqueueCommand:profilePicCommand];
    }
    else
    {
        [self showDefaultRetryAlert:command];
    }
}

- (void)updateProfilePicDidComplete:(NSNotification *)notif
{
    UploadImageCommand *command = notif.object;
    
    if(command.status == kSuccess)
    {
        self.onProfilePicUpdated([BuzzrdAPI current].profilePic);

        [self.navigationController popViewControllerAnimated:TRUE];
    }
    else
    {
        [self showDefaultRetryAlert:command];
    }
}

@end
