//
//  SqliteManager.h
//  Contacts
//
//  Created by 刘瑞康 on 2018/6/21.
//  Copyright © 2018年 刘瑞康. All rights reserved.
//

#ifndef SqliteManager_h
#define SqliteManager_h

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ContactModel.h"

@interface SqliteManager :NSObject


@property(nonatomic,strong,readonly)NSArray * contacts;

-(void)addContactToSqlite:(ContactModel *)contact;

-(void)updateContactFromSqlite:(ContactModel *)contact withIndex:(NSInteger)index;

-(void)deleteContactFromSqlite:(NSInteger)index;

-(void)selectContactFromWithName:(NSString *)name;

+(instancetype)getSqliteManager;

-(void)loadContacts;

@end

#endif /* SqliteManager_h */
