//
//  ContactObject.h
//  Cuewer
//
//  Created by Stern Edi on 29.04.2014.
//  Copyright (c) 2014 Demoweb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBContactModel.h"

@interface ContactObject : NSObject <MBContactPickerModelProtocol>

@property (nonatomic, copy) NSString *contactTitle;
@property (nonatomic, copy) NSString *contactSubtitle;
@property (nonatomic) UIImage *contactImage;

@end