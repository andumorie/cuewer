//
//  DWSettingsViewController.m
//  Cuewer
//
//  Created by Andu Morie on 08/04/14.
//  Copyright (c) 2014 Demoweb. All rights reserved.
//

#import "DWSettingsViewController.h"
#import "DWAppDelegate.h"
#import "DWViewController.h"
#import "DWUserDefaults.h"
#import <MessageUI/MFMessageComposeViewController.h>

@interface DWSettingsViewController ()
@end

@implementation DWSettingsViewController

@synthesize table;
@synthesize tableData;
@synthesize username;

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
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.extendedLayoutIncludesOpaqueBars = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    username.text = [prefs stringForKey:@"UserName"];
    
    tableData = [NSArray arrayWithObjects: @"Invite friends", @"Buy credits", @"", @"Log out", nil];
    
    table = [[UITableView alloc] init];
    table.frame = CGRectMake(0, 200, 320, 430);
    table.dataSource = self;
    table.delegate = self;
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SimpleTableItem"];
    [table reloadData];
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    table.scrollEnabled = NO;
    [self.view addSubview:table];
}

- (void) viewDidAppear:(BOOL)animated
{
    NSLog(@"%@",[DWUserDefaults getUserName]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [table cellForRowAtIndexPath: indexPath];
    if ([cell.textLabel.text isEqualToString: @"Log out"])
    {
        [self clickLogOut];
    } else if ([cell.textLabel.text isEqualToString: @"Invite friends"])
    {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        if([MFMessageComposeViewController canSendText])
        {
            controller.body = @"Hey, try out this awesome app! Link here";
            controller.recipients = [NSArray arrayWithObjects: nil];
            controller.messageComposeDelegate = self;
            [self presentModalViewController:controller animated:YES];
        }
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) clickLogOut
{
    alert = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) { // Set buttonIndex == 0 to handel "Ok"/"Yes" button response
        [self logOut];
    }
    if (buttonIndex == 0)
    {
        alertView.hidden = YES;
    }
    
}

- (void)logOut
{
    [DWUserDefaults setPassword:@""];
    [DWUserDefaults setUserName:@""];

    DWViewController * vc = [[DWViewController alloc] initWithNibName: @"DWViewController" bundle: nil];
    DWAppDelegate * delegate = (DWAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.window setRootViewController: vc];
    [self.tabBarController setSelectedIndex: 0];
}

@end
