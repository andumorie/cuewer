//
//  DWContactsViewController.m
//  Cuewer
//
//  Created by Andu Morie on 08/04/14.
//  Copyright (c) 2014 Demoweb. All rights reserved.
//

#import "DWContactsViewController.h"
#import "DWAppDelegate.h"
#import <AddressBook/ABAddressBook.h>
#import <AddressBook/ABRecord.h>
#import <AddressBook/AddressBook.h>
#import "AFNetworking.h"
#import "DWUtils.h"

@interface DWContactsViewController ()

@end

@implementation DWContactsViewController

@synthesize contacts;
@synthesize tableData;

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

    [self getAllContacts];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getAllContacts
{
    NSMutableArray *allNumbers = [NSMutableArray new];
    NSMutableArray* contactsArray = [NSMutableArray new];

    // open the default address book.
    ABAddressBookRef m_addressbook =  ABAddressBookCreateWithOptions(NULL, NULL);

    if (!m_addressbook)
    {
        NSLog(@"opening address book");
    }
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(m_addressbook);
    CFIndex nPeople = ABAddressBookGetPersonCount(m_addressbook);
    for (int i=0;i < nPeople;i++)
    {
        NSMutableDictionary* tempContactDic = [NSMutableDictionary new];
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
        CFStringRef firstName, lastName;
        firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        NSString * name = [NSString stringWithFormat: @"%@ %@", firstName, lastName];
        [tempContactDic setValue: name forKey:@"name"];

        //fetch email id
        NSString *strEmail;
        ABMultiValueRef email = ABRecordCopyValue(ref, kABPersonEmailProperty);
        CFStringRef tempEmailref = ABMultiValueCopyValueAtIndex(email, 0);
        strEmail = (__bridge  NSString *)tempEmailref;
        [tempContactDic setValue:strEmail forKey:@"email"];

        //fetch number
        NSMutableArray *numbers = [NSMutableArray new];
        NSString *strNumber;
        ABMultiValueRef number = ABRecordCopyValue(ref, kABPersonPhoneProperty);
        for (int i=0; i < 6; i++) {
            CFStringRef tempNumberref = ABMultiValueCopyValueAtIndex(number, i);
            strNumber = (__bridge  NSString *)tempNumberref;
            if (strNumber) {
                strNumber = [strNumber stringByReplacingOccurrencesOfString: @"+" withString: @""];
                strNumber = [strNumber stringByReplacingOccurrencesOfString: @" " withString: @""];
                strNumber = [strNumber stringByReplacingOccurrencesOfString: @"(" withString: @""];
                strNumber = [strNumber stringByReplacingOccurrencesOfString: @")" withString: @""];

                [numbers addObject: strNumber];
                [allNumbers addObject: strNumber];
                NSLog(@"%@", strNumber);
            }
        }
        [tempContactDic setValue: [self indexKeyedDictionaryFromArray: numbers] forKey:@"number"];
        
        [contactsArray addObject:tempContactDic];
    }

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"numbers": allNumbers
                                 };
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *userName = [prefs stringForKey:@"UserName"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat: @"%@%@", @"http://cuewer-api.herokuapp.com/users/get_contacts/", userName] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", [responseObject valueForKey: @"data"]);

        // parse responseObject here
        NSString *success = [responseObject valueForKey:@"success"];

        BOOL suc;
        if ([success isEqualToString:@"true"]) {
            suc = YES;
        }
        else {
            suc = NO;
        }

        if (suc) {
            // do stuff with the contacts
            contacts = [responseObject valueForKey: @"data"];
//            for (int i=0; i < data.count; i++) {
//                NSDictionary *contact_data = data[i];
//                NSString *displayName;
//                if ([contact_data[@"display_name"] isEqual:[NSNull null]]) {
//                    displayName = contact_data[@"username"];
//                }
//                else {
//                    displayName = contact_data[@"display_name"];
//                }
//                NSLog(@"%@", displayName);
//            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (NSDictionary *) indexKeyedDictionaryFromArray:(NSArray *)array
{
    id objectInstance;
    NSUInteger indexKey = 0;

    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    for (objectInstance in array)
        [mutableDictionary setObject:objectInstance forKey:[NSNumber numberWithUnsignedInt:indexKey++]];

    return (NSDictionary *) mutableDictionary;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contacts.count;
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

    NSString *displayName;
    if ([contacts[indexPath.row][@"display_name"] isEqual:[NSNull null]]) {
        displayName = contacts[indexPath.row][@"username"];
    }
    else {
        displayName = contacts[indexPath.row][@"display_name"];
    }
    cell.textLabel.text = displayName;
    //cell.detailTextLabel.text = @"ultimul mesaj";

    if (indexPath.row % 2 != 0 && indexPath.row != 0) {
        CGRect frame = CGRectMake(0, 0, 320, 60);
        UIView *bgColor = [[UIView alloc] initWithFrame:frame];
        [cell addSubview:bgColor];
        [cell sendSubviewToBack:bgColor];
        bgColor.backgroundColor = [DWUtils colorFromHexString:@"#fafafa"];
    }
    return cell;
}


@end
