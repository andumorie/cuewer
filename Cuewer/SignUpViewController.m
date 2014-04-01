//
//  SignUpViewController.m
//  Cuewer
//
//  Created by Andu Morie on 18/03/14.
//  Copyright (c) 2014 Demoweb. All rights reserved.
//

#import "SignUpViewController.h"
#import "VerifyNet.h"

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

    
    self.navigationItem.hidesBackButton = YES;
    
    VerifyNet * vn = [[VerifyNet alloc] init];
    if ([vn hasConnectivity]) {
        
        [self showLoading];
        
        NSString *urlAsString = @"http://cuewer-api.herokuapp.com/users";
        NSURL *url = [NSURL URLWithString:urlAsString];
        
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        [urlRequest setTimeoutInterval:30.0f];
        [urlRequest setHTTPMethod:@"POST"];
        
        NSString *username = [NSString stringWithFormat:@"username=%@",txtUser.text];
        NSString *email = [NSString stringWithFormat:@"email=%@",txtEmail.text];
        NSString *password = [NSString stringWithFormat:@"password=%@",txtPassword.text];
        NSString *confirmPassord = [NSString stringWithFormat:@"confirmpassword=%@",txtPasswordConfirm.text];
        [urlRequest setHTTPBody:[username dataUsingEncoding:NSUTF8StringEncoding]];
        [urlRequest setHTTPBody:[email dataUsingEncoding:NSUTF8StringEncoding]];
        [urlRequest setHTTPBody:[password dataUsingEncoding:NSUTF8StringEncoding]];
        [urlRequest setHTTPBody:[confirmPassord dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            
            if ([data length] > 0 && error == nil) {
                NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"response = %@", response);
                @try {
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                    NSString * str = [json objectForKey:@"success"];
                    if ([str isEqualToString:@"true"])
                        succes = YES;
                    else succes = NO;
                }
                @catch (NSException *exception) {
                    succes = NO;
                }
                //[self showPopUpWithDesc:succes];
            }else if ([data length] == 0 && error == nil){
                NSLog(@"error");
            }else if (error != nil){
                NSLog(@"Error Happend = %@", error);
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^
             {
                 // Your code that presents the alert view(s)]]
                 [self showPopUp:succes];
                 [self hideLoading];
             }];
            
            
        }];
    
    }
    
    
}

# pragma alert

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


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -100; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}




@end
