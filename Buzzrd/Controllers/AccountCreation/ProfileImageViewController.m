//
//  ProfileImageViewController.m
//  Buzzrd
//
//  Created by Robert Beck on 5/29/14.
//  Copyright (c) 2014 Buzzrd. All rights reserved.
//

#import "ProfileImageViewController.h"
#import "UIImage+thumbnail.h"
#import "BuzzrdNav.h"
#import "BuzzrdAPI.h"
#import "UploadImageCommand.h"
#import "UpdateProfilePicCommand.h"
#import "ThemeManager.h"
#import "LoginCommand.h"

@interface ProfileImageViewController ()

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UIImage *thumbnail;

@end

@implementation ProfileImageViewController

-(void) loadView
{
    [super loadView];
    
    [self.view setBackgroundColor: [ThemeManager getPrimaryColorLight]];
    
    self.navigationController.navigationBar.hidden = YES;
    
    UILabel *successLbl = [[UILabel alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,20)];
    [successLbl setText:NSLocalizedString(@"SUCCESS!", nil)];
    successLbl.textAlignment = NSTextAlignmentCenter;
    successLbl.font = [ThemeManager getPrimaryFontBold:28.0];
    successLbl.translatesAutoresizingMaskIntoConstraints = NO;
    successLbl.textColor = [ThemeManager getSecondaryColorMedium];
    [self.view addSubview:successLbl];
    
    UILabel *accountSavedMessageLbl = [[UILabel alloc] init];
    [accountSavedMessageLbl setText:NSLocalizedString(@"account_created_successfully", nil)];
    accountSavedMessageLbl.textAlignment = NSTextAlignmentCenter;
    accountSavedMessageLbl.font = [ThemeManager getPrimaryFontRegular:16.0];
    accountSavedMessageLbl.numberOfLines = 0;
    accountSavedMessageLbl.translatesAutoresizingMaskIntoConstraints = NO;
    accountSavedMessageLbl.textColor = [ThemeManager getPrimaryColorDark];
    [self.view addSubview:accountSavedMessageLbl];
    
    UIView *profilePicContainerView =[[UIView alloc] init];
    profilePicContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:profilePicContainerView];
    
    self.profileImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.profileImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.profileImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.profileImageView.image = [UIImage imageNamed:@"no_profile_pic.png"];
    [profilePicContainerView addSubview:self.profileImageView];
    
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profilePicContainerViewSingleTap:)];
    [profilePicContainerView addGestureRecognizer:singleFingerTap];
    
    UIButton *selectPicButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [selectPicButton setTitle: NSLocalizedString(@"SELECT PROFILE PICTURE", nil) forState:UIControlStateNormal];
    selectPicButton.translatesAutoresizingMaskIntoConstraints = NO;
    selectPicButton.backgroundColor = [ThemeManager getSecondaryColorMedium];
    selectPicButton.titleLabel.font = [ThemeManager getPrimaryFontDemiBold:15.0];
    [selectPicButton addTarget:self action:@selector(selectPicButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [selectPicButton setTitleColor:[ThemeManager getPrimaryColorLight] forState:UIControlStateNormal];
    selectPicButton.layer.cornerRadius = 5; // this value vary as per your desire
    [self.view addSubview:selectPicButton];
    
    UIButton *whatsBuzzingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [whatsBuzzingButton setTitle: NSLocalizedString(@"SEE WHAT'S BUZZING", nil) forState:UIControlStateNormal];
    whatsBuzzingButton.translatesAutoresizingMaskIntoConstraints = NO;
    whatsBuzzingButton.backgroundColor = [ThemeManager getSecondaryColorMedium];
    whatsBuzzingButton.titleLabel.font = [ThemeManager getPrimaryFontDemiBold:15.0];
    [whatsBuzzingButton addTarget:self action:@selector(whatsBuzzingTouch) forControlEvents:UIControlEventTouchUpInside];
    [whatsBuzzingButton setTitleColor:[ThemeManager getPrimaryColorLight] forState:UIControlStateNormal];
    whatsBuzzingButton.layer.cornerRadius = 5; // this value vary as per your desire
    [self.view addSubview:whatsBuzzingButton];

    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[successLbl]-40-|" options:0 metrics:nil views:@{ @"successLbl" : successLbl }]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[accountSavedMessageLbl]-40-|" options:0 metrics:nil views:@{ @"accountSavedMessageLbl" : accountSavedMessageLbl }]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-110-[profilePicContainerView]-110-|" options:0 metrics:nil views:@{ @"profilePicContainerView" : profilePicContainerView }]];
    
    [profilePicContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[profileImageView]-0-|" options:0 metrics:nil views:@{ @"profileImageView" :self.profileImageView }]];
    
    [profilePicContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[profileImageView]-0-|" options:0 metrics:nil views:@{ @"profileImageView" :self.profileImageView }]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[selectPicButton]-20-|" options:0 metrics:nil views:@{ @"selectPicButton" : selectPicButton }]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[whatsBuzzingButton]-20-|" options:0 metrics:nil views:@{ @"whatsBuzzingButton" : whatsBuzzingButton }]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-85-[successLbl]-15-[accountSavedMessageLbl]-20-[profilePicContainerView]-25-[selectPicButton]-15-[whatsBuzzingButton]" options:0 metrics:nil views:@{ @"successLbl" : successLbl, @"accountSavedMessageLbl" : accountSavedMessageLbl, @"profilePicContainerView" : profilePicContainerView, @"selectPicButton" : selectPicButton, @"whatsBuzzingButton" : whatsBuzzingButton }]];
}

- (UIImagePickerController *) imagePicker {
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }

    return _imagePicker;
}

- (void)profilePicContainerViewSingleTap:(UITapGestureRecognizer *)recognizer {
    
//    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        NSLog(@"No Camera Detected");
//        
//        return;
//    }
    
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
            //[self pickPhotoFromLibrary];
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
    
    if (_thumbnail != nil){

        UploadImageCommand *command = [[UploadImageCommand alloc]init];
        command.image = _thumbnail;
        [command listenForCompletion:self selector:@selector(getImageUploadDidComplete:)];

        [[BuzzrdAPI dispatch] enqueueCommand:command];
    }
    else
    {
        [self hideActivityView];
    }

}

-(void) whatsBuzzingTouch
{
    [self login];
}

-(void) selectPicButtonTouch
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) destructiveButtonTitle:nil otherButtonTitles: NSLocalizedString(@"take_a_photo", nil), NSLocalizedString(@"use_photo_library", nil), nil];
    [actionSheet showInView:self.view];
}

- (void)getImageUploadDidComplete:(NSNotification *)notif
{
    UploadImageCommand *command = notif.object;
    
    if(command.status == kSuccess)
    {
        UpdateProfilePicCommand *profilePicCommand = [[UpdateProfilePicCommand alloc]init];
        profilePicCommand.iduser = self.user.iduser;
        profilePicCommand.imageURI = command.results;
        [profilePicCommand listenForCompletion:self selector:@selector(updateProfilePicDidComplete:)];
        
        self.user.profilePic = command.results;
        [BuzzrdAPI current].profilePic = command.results;
        
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
    
    if(command.status != kSuccess)
    {
        [self showDefaultRetryAlert:command];
    }
}

-(void)dismissToRootView {
    [self dismissViewControllerAnimated:true completion:^{ [self dismissViewControllerAnimated:true completion:nil]; }];
}

- (void)login {
    LoginCommand *command = [[LoginCommand alloc]init];
    command.username = self.user.username; //self.usernameTextField.text;
    command.password = self.user.password; //self.passwordTextField.text;
    
    [command listenForCompletion:self selector:@selector(loginDidComplete:)];
    
    [[BuzzrdAPI dispatch] enqueueCommand:command];
}

- (void)loginDidComplete:(NSNotification *)notif
{
    LoginCommand *command = notif.object;
    if(command.status == kSuccess)
    {
        [BuzzrdAPI current].authorization = (Authorization *)command.results;

        [BuzzrdAPI current].user = self.user;

        [self performSelectorOnMainThread:@selector(dismissToRootView) withObject:nil waitUntilDone:NO];
    }
    else
    {
        [self showDefaultRetryAlert:command];
    }
}

@end
