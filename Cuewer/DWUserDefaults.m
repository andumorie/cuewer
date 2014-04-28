//
//  DWUserDefaults.m
//  Cuewer
//
//  Created by Stern Edi on 28.04.2014.
//  Copyright (c) 2014 Demoweb. All rights reserved.
//

#import "DWUserDefaults.h"

@implementation DWUserDefaults


+ (void) setUserName:(NSString *)un
{
    NSUserDefaults *myUserDefault = [NSUserDefaults standardUserDefaults];
    [myUserDefault setValue:un forKey:@"UserName"];
}

+ (NSString *) getUserName
{
    NSUserDefaults *myUserDefault = [NSUserDefaults standardUserDefaults];
    return [myUserDefault valueForKey:@"UserName"];
}

+ (void) setPassword:(NSString *)pas
{
    NSUserDefaults *myUserDefault = [NSUserDefaults standardUserDefaults];
    [myUserDefault setValue:pas forKey:@"Password"];
}

+ (NSString *) getPassword
{
    NSUserDefaults *myUserDefault = [NSUserDefaults standardUserDefaults];
    return [myUserDefault valueForKey:@"Password"];
}

@end
