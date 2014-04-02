//
//  SignUpViewController.m
//  Cuewer
//
//  Created by Andu Morie on 18/03/14.
//  Copyright (c) 2014 Demoweb. All rights reserved.
//

#import "SignUpViewController.h"
#import "VerifyNet.h"
#import "AFNetworking.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    txtPassword.secureTextEntry = YES;
    txtPasswordConfirm.secureTextEntry = YES;
    txtUser.delegate = self;
    txtEmail.delegate = self;
    txtPasswordConfirm.delegate = self;
    txtPassword.delegate = self;
    succes = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Consume WebService


- (IBAction) callSignUp {

    [self.view endEditing:YES];
    
    VerifyNet * vn = [[VerifyNet alloc] init];
    if ([vn hasConnectivity]) {
        
        [self showLoading];
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{
                                        @"username": txtUser.text,
                                        @"password": txtPassword.text,
                                        @"confirmpassword": txtPasswordConfirm.text,
                                        @"email": txtEmail.text,
                                    };
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager POST:@"http://cuewer-api.herokuapp.com/users" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                                                      message:@"Your account has been created !"
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
    const int movementDistance = 160; // tweak as needed
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

@end
