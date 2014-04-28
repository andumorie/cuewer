//
//  DWSettingsViewController.h
//  Cuewer
//
//  Created by Andu Morie on 08/04/14.
//  Copyright (c) 2014 Demoweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *username;

@property (strong, nonatomic) NSArray *tableData;

@property (strong, nonatomic) IBOutlet UITableView *table;


@end