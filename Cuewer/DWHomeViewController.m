//
//  DWHomeViewController.m
//  Cuewer
//
//  Created by Andu Morie on 02/04/14.
//  Copyright (c) 2014 Demoweb. All rights reserved.
//

#import "DWHomeViewController.h"
#import "DWUtils.h"

@interface DWHomeViewController ()

@end

@implementation DWHomeViewController
@synthesize tableData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont fontWithName:@"Myriad Pro" size:20];
    cell.textLabel.textColor = [DWUtils colorFromHexString:@"#3e3e3e"];
    cell.detailTextLabel.textColor = [DWUtils colorFromHexString:@"#888888"];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Myriad Pro" size:16];
    cell.imageView.image = [UIImage imageNamed:@"cuewer58.png"];
    cell.imageView.layer.cornerRadius = 28;
    cell.imageView.layer.borderColor = (__bridge CGColorRef)([UIColor clearColor]);
    cell.imageView.layer.borderWidth = 1.0f;
    cell.imageView.layer.masksToBounds = NO;
    cell.imageView.clipsToBounds = YES;
    
    cell.textLabel.text = @"Nume";
    cell.detailTextLabel.text = @"ultimul mesaj";
    
    if (indexPath.row % 2 != 0 && indexPath.row != 0) {
        CGRect frame = CGRectMake(0, 0, 320, 60);
        UIView *bgColor = [[UIView alloc] initWithFrame:frame];
        [cell addSubview:bgColor];
        [cell sendSubviewToBack:bgColor];
        bgColor.backgroundColor = [DWUtils colorFromHexString:@"#fafafa"];
    }
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.extendedLayoutIncludesOpaqueBars = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
