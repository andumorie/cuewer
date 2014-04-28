//
//  DWVerifyAccountViewController.m
//  Cuewer
//
//  Created by Stern Edi on 28.04.2014.
//  Copyright (c) 2014 Demoweb. All rights reserved.
//

#import "DWVerifyAccountViewController.h"
#import "AFNetworking.h"

@interface DWVerifyAccountViewController ()

@end

@implementation DWVerifyAccountViewController

@synthesize userName;
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
    txtPhoneNumber.delegate = self;
    txtCodeNumber.delegate = self;
    txtCodeNumber.enabled = NO;
    [txtPhoneNumber setKeyboardType:UIKeyboardTypeNumberPad];
    [txtCodeNumber setKeyboardType:UIKeyboardTypeNumberPad];
    // Do any additional setup after loading the view from its nib.
}



- (IBAction)sendCode:(id)sender{
    if ([txtPhoneNumber.text isEqualToString:@""])
    {
        [txtPhoneNumber becomeFirstResponder];
        return;
    }
    
    
    [self.view endEditing:YES];
    [self showLoading];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"number": txtPhoneNumber.text,
                                 };
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@%@", @"http://cuewer-api.herokuapp.com/users/send_code/", userName] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        // parse responseObject here
        NSString *success = [responseObject valueForKey:@"success"];
        
        BOOL suc;
        if ([success isEqualToString:@"true"]) {
            txtPhoneNumber.enabled = NO;
            txtCodeNumber.enabled = YES;
            btnSendMessage.enabled = NO;
            suc = YES;
        }
        else {
            suc = NO;
        }
        [self hideLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self hideLoading];
    }];
    
}

- (IBAction)sendCodeBackToApi:(NSString *)sender{
    if ([txtPhoneNumber.text isEqualToString:@""])
    {
        [txtPhoneNumber becomeFirstResponder];
        return;
    }
    
    
    [self.view endEditing:YES];
    [self showLoading];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"number": txtPhoneNumber.text,
                                 };
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@%@", @"http://cuewer-api.herokuapp.com/users/validate_code/", sender] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        // parse responseObject here
        NSString *success = [responseObject valueForKey:@"success"];
        
        BOOL suc;
        if ([success isEqualToString:@"true"]) {
            suc = YES;
        }
        else {
            suc = NO;
            txtCodeNumber.enabled = YES;
        }
        [self hideLoading];
        [self showPopUp:suc];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self hideLoading];
    }];
    
}

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
                                                          message:@"Your account has been verified !"
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
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void) hideLoading
{
    [alert dismissWithClickedButtonIndex:77 animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma textfield

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == txtPhoneNumber)
    {
        [textField resignFirstResponder];
    }
    
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
    const int movementDistance = 170; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == txtCodeNumber)
    {
        if (textField.text.length == 5 && string.length == 1)
        {
            [textField setText:[NSString stringWithFormat:@"%@%@",textField.text, string] ];
            [textField resignFirstResponder];
            [self sendCodeBackToApi:textField.text];
        }
    }
    return YES;
}


- (IBAction)closeKeyboard:(UITextField *)sender {
    [sender resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}


@end
