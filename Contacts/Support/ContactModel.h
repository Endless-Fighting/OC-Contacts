//
//  ContactModel.h
//  Contacts
//
//  Created by 刘瑞康 on 2018/6/14.
//  Copyright © 2018年 刘瑞康. All rights reserved.
//

#ifndef ContactModel_h
#define ContactModel_h
#import <Foundation/Foundation.h>

@interface ContactModel :NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phoneNo;
@property (nonatomic, strong) NSString *weChatNo;
@property (nonatomic, strong) NSString *emailAddress;
@property(nonatomic,assign)NSInteger contactId;

-(instancetype)initWithName:(NSString *)name PhoneNo:(NSString *)phone WeChatNo:(NSString *)weChat EmailAddress:(NSString *)email;
@end
#endif /* ContactModel_h */
