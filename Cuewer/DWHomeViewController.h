//
//  DWHomeViewController.h
//  Cuewer
//
//  Created by Andu Morie on 02/04/14.
//  Copyright (c) 2014 Demoweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWHomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    IBOutlet UITableView    * tableView;
    
}

@property (strong, nonatomic) NSMutableArray *tableData;

@end
