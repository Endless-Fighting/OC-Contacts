//
//  ContactModel.m
//  Contacts
//
//  Created by 刘瑞康 on 2018/6/14.
//  Copyright © 2018年 刘瑞康. All rights reserved.
//

#import "ContactModel.h"

@interface ContactModel ()

@end

@implementation ContactModel
@synthesize name=_name, phoneNo=_phoneNo, weChatNo=_weChatNo, emailAddress=_emailAddress;

-(instancetype)initWithName:(NSString *)name PhoneNo:(NSString *)phone WeChatNo:(NSString *)weChat EmailAddress:(NSString *)email;
{
    if (self = [super init])
    {
        self.name = name;
        self.phoneNo = phone;
        self.weChatNo = weChat;
        self.emailAddress = email;
    }
    
    return self;
}  
@end
