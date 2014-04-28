//
//  DWAppDelegate.m
//  Cuewer
//
//  Created by Andu Morie on 18/03/14.
//  Copyright (c) 2014 Demoweb. All rights reserved.
//

#import "DWAppDelegate.h"
#import "DWViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "DWHomeViewController.h"
#import "DWContactsViewController.h"
#import "DWAskViewController.h"
#import "DWSettingsViewController.h"
#import "DWUserDefaults.h"

@implementation DWAppDelegate

@synthesize homeNavigationController;
@synthesize contactsNavigationController;
@synthesize askNavigationController;
@synthesize settingsNavigationController;
@synthesize tabBarController;
@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[FBLoginView class];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIViewController *viewController0 = [[DWHomeViewController alloc] initWithNibName:@"DWHomeViewController" bundle:nil];
    viewController0.tabBarItem.image = [UIImage imageNamed: @"HomeIcon"];
    viewController0.tabBarItem.title = @"Home";
    self.homeNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController0];
    self.homeNavigationController.navigationBar.topItem.title = @"Home";
    [self.homeNavigationController.navigationBar setTranslucent: YES];
    [self.homeNavigationController.navigationBar setBarTintColor: [UIColor colorWithRed:0.231 green:0.741 blue:0.506 alpha:1]];
    [self.homeNavigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.homeNavigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIViewController *viewController1 = [[DWContactsViewController alloc] initWithNibName:@"DWContactsViewController" bundle:nil];
    viewController1.tabBarItem.image = [UIImage imageNamed: @"ContactsIcon"];
    viewController1.tabBarItem.title = @"Contacts";
    self.contactsNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController1];
    self.contactsNavigationController.title = @"Contacts";
    self.contactsNavigationController.navigationBar.topItem.title = @"Contacts";
    [self.contactsNavigationController.navigationBar setTranslucent: YES];
    [self.contactsNavigationController.navigationBar setBarTintColor: [UIColor colorWithRed:0.231 green:0.741 blue:0.506 alpha:1]];
    [self.contactsNavigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.contactsNavigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIViewController *viewController2 = [[DWAskViewController alloc] initWithNibName:@"DWAskViewController" bundle:nil];
    viewController2.tabBarItem.image = [UIImage imageNamed: @"AskIcon"];
    viewController2.tabBarItem.title = @"Ask";
    self.askNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController2];
    self.askNavigationController.title = @"Ask";
    self.askNavigationController.navigationBar.topItem.title = @"Ask";
    [self.askNavigationController.navigationBar setTranslucent: YES];
    [self.askNavigationController.navigationBar setBarTintColor: [UIColor colorWithRed:0.231 green:0.741 blue:0.506 alpha:1]];
    [self.askNavigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.askNavigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIViewController *viewController3 = [[DWSettingsViewController alloc] initWithNibName:@"DWSettingsViewController" bundle:nil];
    viewController3.tabBarItem.image = [UIImage imageNamed: @"SettingsIcon"];
    viewController3.tabBarItem.title = @"Settings";
    self.settingsNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController3];
    self.settingsNavigationController.title = @"Settings";
    self.settingsNavigationController.navigationBar.topItem.title = @"Settings";
    [self.settingsNavigationController.navigationBar setTranslucent: YES];
    [self.settingsNavigationController.navigationBar setBarTintColor: [UIColor colorWithRed:0.231 green:0.741 blue:0.506 alpha:1]];
    [self.settingsNavigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.settingsNavigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:homeNavigationController,contactsNavigationController,askNavigationController,settingsNavigationController,nil];
    self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:0.231 green:0.741 blue:0.506 alpha:1];
    UINavigationController * nc;
    NSString * userName = [DWUserDefaults getUserName];
    if (userName ==nil || [userName isEqualToString:@""]){
        DWViewController * vc = [[DWViewController alloc] initWithNibName:@"DWViewController" bundle: nil];
        nc = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nc;
    }else {
        self.window.rootViewController = self.tabBarController;
    }
    
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}


@end
