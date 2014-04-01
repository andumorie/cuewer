//
//  SignUpViewController.h
//  Cuewer
//
//  Created by Andu Morie on 18/03/14.
//  Copyright (c) 2014 Demoweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController <UITextFieldDelegate,UIAlertViewDelegate>
{
    IBOutlet UITextField * txtUser;
    IBOutlet UITextField * txtEmail;
    IBOutlet UITextField * txtPassword;
    IBOutlet UITextField * txtPasswordConfirm;
    
    UIAlertView *alert;
    BOOL succes;
}



@end
