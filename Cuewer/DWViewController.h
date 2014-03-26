//
//  DWViewController.h
//  Cuewer
//
//  Created by Andu Morie on 18/03/14.
//  Copyright (c) 2014 Demoweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface DWViewController : UIViewController  <FBLoginViewDelegate>
{
    IBOutlet UITextField * txtUser;
    IBOutlet UITextField * txtPassword;
    IBOutlet UIImageView * imgProfile;
    IBOutlet UIButton    * btnLogin;
    IBOutlet UILabel     * lblSignUp;
    IBOutlet UIButton    * btnSignUp;
}

@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;


- (IBAction)onLogin:(UIButton *)sender;

- (IBAction)onFacebookLogin:(UIButton *)sender;

- (IBAction)onSignUp:(UIButton *)sender;

- (IBAction)closeKeyboard:(UITextField *)sender;

@end



