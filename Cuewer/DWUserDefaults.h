//
//  DWUserDefaults.h
//  Cuewer
//
//  Created by Stern Edi on 28.04.2014.
//  Copyright (c) 2014 Demoweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWUserDefaults : NSObject{
    
}


+ (void) setUserName : (NSString *) un;
+ (NSString *) getUserName;;
+ (void) setPassword : (NSString *) pas;
+ (NSString *) getPassword;
@end
