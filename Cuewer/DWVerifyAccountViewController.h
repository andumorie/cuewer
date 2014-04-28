//
//  DWVerifyAccountViewController.h
//  Cuewer
//
//  Created by Stern Edi on 28.04.2014.
//  Copyright (c) 2014 Demoweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWVerifyAccountViewController : UIViewController <UITextFieldDelegate,UIAlertViewDelegate>{
    
    IBOutlet UITextField * txtPhoneNumber;
    IBOutlet UITextField * txtCodeNumber;
    IBOutlet UILabel     * lblTypeCode;
    IBOutlet UIButton    * btnSendMessage;
    
     UIAlertView *alert;
}

@property NSString * userName;
@property NSString * password;

- (IBAction)sendCode:(id)sender;

@end
