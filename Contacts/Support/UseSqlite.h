//
//  useSqlite.h
//  Contacts
//
//  Created by 刘瑞康 on 2018/6/11.
//  Copyright © 2018年 刘瑞康. All rights reserved.
//

#ifndef UseSqlite_h
#define UseSqlite_h
#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ContactModel.h"

@interface UseSqlite :NSObject



+(BOOL) openAndCreate;
+(BOOL) insertContact:(ContactModel *)contact;
+(NSMutableArray *) getAllContacts;
+(BOOL) isContactExisted:(NSString *) name;
+(ContactModel *) getInfo:(NSString *) name;
+(BOOL) updateContact:(ContactModel *)contact;
+(BOOL) deleteContact:(NSString *) name;
+(BOOL) clearContacts;
@end

#endif /* UseSqlite_h */
