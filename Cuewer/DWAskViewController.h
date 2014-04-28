//
//  DWAskViewController.h
//  Cuewer
//
//  Created by Andu Morie on 08/04/14.
//  Copyright (c) 2014 Demoweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWAskViewController : UIViewController <UITextFieldDelegate,UIAlertViewDelegate,UIPickerViewDataSource >{
   
    IBOutlet UIPickerView  *pickerCategory;
    IBOutlet UIPickerView  *pickerQuestion;
    IBOutlet UITextField   *txtQuestion;
    IBOutlet UILabel      *lblCategory;
    IBOutlet UILabel      *lblQuestion;
    
    IBOutlet UIView        *vwCategory;
    IBOutlet UIView        *vwQuestion;
}

- (IBAction)showCategories:(id)sender;
- (IBAction)showQuestions:(id)sender;

@end
