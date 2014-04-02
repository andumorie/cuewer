//
//  DWViewController.m
//  Cuewer
//
//  Created by Andu Morie on 18/03/14.
//  Copyright (c) 2014 Demoweb. All rights reserved.
//

#import "DWViewController.h"
#import "SignUpViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AFNetworking.h"

@interface DWViewController ()

@end

@implementation DWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    txtUser.delegate = self;
    txtPassword.delegate = self;
    txtPassword.secureTextEntry = YES;
    FBLoginView *loginView = [[FBLoginView alloc] init];
    // Align the button in the center horizontally
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 350);
    loginView.readPermissions = @[@"basic_info", @"email", @"user_likes"];
    loginView.delegate = self;
    [self.view addSubview:loginView];

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [user username]];
    
    NSURL *imageURL = [NSURL URLWithString:userImageURL];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    self.profilePictureView.profileID = user.id;
    self.nameLabel.text = user.name;

    imgProfile.image = image;
    
}

// Logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    lblSignUp.hidden = YES;
    btnLogin.hidden = YES;
    btnSignUp.hidden = YES;
    txtPassword.hidden = YES;
    txtUser.hidden = YES;
    self.statusLabel.text = @"You're logged in as";
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.profilePictureView.profileID = nil;
    imgProfile.image = nil;
    self.nameLabel.text = @"";
    lblSignUp.hidden = NO;
    btnLogin.hidden = NO;
    btnSignUp.hidden = NO;
    txtPassword.hidden = NO;
    txtUser.hidden = NO;
    self.statusLabel.text= @"";
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogin:(UIButton *)sender {
    
    [self.view endEditing:YES];
    [self showLoading];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"username": txtUser.text,
                                 @"password": txtPassword.text
                                 };
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@%@", @"http://cuewer-api.herokuapp.com/users/", txtUser.text] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        // parse responseObject here
        NSString *success = [responseObject valueForKey:@"success"];
        
        BOOL suc;
        if ([success isEqualToString:@"true"]) {
            suc = YES;
        }
        else {
            suc = NO;
        }
        
        [self showPopUp:suc];
        [self hideLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self showPopUp:NO];
        [self hideLoading];
    }];

}

- (IBAction)onSignUp:(UIButton *)sender {
    SignUpViewController * signUpVC = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle: nil];
    [self.navigationController pushViewController: signUpVC animated: YES];
}

#pragma textfield

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


- (IBAction)closeKeyboard:(UITextField *)sender {
    [sender resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

#pragma alert

- (void) showLoading
{
    
    alert = [[UIAlertView alloc] initWithTitle:@"Loading..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]
                                          initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame=CGRectMake(150, 150, 16, 16);
    [indicator startAnimating];
    [alert setValue:indicator forKey:@"accessoryView"];
    [alert show];
}

- (void) showPopUp :(BOOL) suc
{
    if (suc){
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Succes"
                                                          message:@"You have successfully logged in!"
                                                         delegate:self
                                                cancelButtonTitle:nil
                                                otherButtonTitles:nil];
        [message addButtonWithTitle:@"OK"];
        [message show];
    }else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:@"There was an error,please try again."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"OK"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) hideLoading
{
    [alert dismissWithClickedButtonIndex:77 animated:YES];
}

@end
