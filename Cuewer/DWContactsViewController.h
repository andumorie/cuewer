//
//  DWContactsViewController.h
//  Cuewer
//
//  Created by Andu Morie on 08/04/14.
//  Copyright (c) 2014 Demoweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWContactsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView * tableView;
}

@property (strong, nonatomic) NSMutableArray *tableData;
@property (strong, nonatomic) NSArray *contacts;

@end