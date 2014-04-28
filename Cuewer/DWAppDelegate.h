//
//  DWAppDelegate.h
//  Cuewer
//
//  Created by Andu Morie on 18/03/14.
//  Copyright (c) 2014 Demoweb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (nonatomic, strong) UINavigationController * homeNavigationController;
@property (nonatomic, strong) UINavigationController * contactsNavigationController;
@property (nonatomic, strong) UINavigationController * askNavigationController;
@property (nonatomic, strong) UINavigationController * settingsNavigationController;

@end
