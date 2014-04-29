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

@interface DWContactsViewController ()

@end

@implementation DWContactsViewController

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
    ABAddressBookRef m_addressbook = ABAddressBookCreate();

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
            strNumber = [strNumber stringByReplacingOccurrencesOfString: @"+" withString: @""];
            strNumber = [strNumber stringByReplacingOccurrencesOfString: @" " withString: @""];
            strNumber = [strNumber stringByReplacingOccurrencesOfString: @"(" withString: @""];
            strNumber = [strNumber stringByReplacingOccurrencesOfString: @")" withString: @""];
            if (strNumber) {
                [numbers addObject: strNumber];
                [allNumbers addObject: strNumber];
            }
            NSLog(@"%@", strNumber);
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
    [manager POST:[NSString stringWithFormat: @"%@%@", @"http://0.0.0.0:3000/users/get_contacts", userName] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);

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
            NSMutableArray * contacts = [responseObject valueForKey: @"data"];
            // do stuff with the contacts
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

@end
