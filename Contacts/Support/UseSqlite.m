//
//  useSqlite.m
//  Contacts
//
//  Created by 刘瑞康 on 2018/6/11.
//  Copyright © 2018年 刘瑞康. All rights reserved.
//

#import "UseSqlite.h"
@interface UseSqlite ()
{
    
}
@end

static sqlite3 *db;

@implementation UseSqlite

+(BOOL) openAndCreate
{
    NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"contacts.sqlite"];
    int result = sqlite3_open(fileName.UTF8String, &db);
    if(result == SQLITE_OK)
    {
        NSLog(@"open success");
        const char *sql = "create table if not exists contactsInfo (name text primary key, phoneNo text, weChatNo text, emailAddress text);";
        char *errorMsg = NULL;
        int result = sqlite3_exec(db, sql, NULL, NULL, &errorMsg);
        
        if (result == SQLITE_OK) {
            
            NSLog(@"create success");
            return YES;
            
        }else {
            NSLog(@"create failed: %s",errorMsg);
            return NO;
        }
    }
    else
    {
        NSLog(@"open failed");
        return NO;
    }
}


+(BOOL) insertContact:(ContactModel *)contact
{
    NSLog(@"%@,%@,%@,%@ - insert",contact.name,contact.phoneNo,contact.weChatNo,contact.emailAddress);
    NSString *sql = [NSString stringWithFormat:@"insert into contactsInfo (name,phoneNo,weChatNo,emailAddress) values ('%@','%@','%@','%@');",contact.name,contact.phoneNo,contact.weChatNo,contact.emailAddress];

    char *errorMesg = NULL;
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errorMesg);

    if (result == SQLITE_OK) {
        NSLog(@"insert success");
        return YES;
    }else {
        NSLog(@"insert failed");
        return NO;
    }
}

+(NSMutableArray *) getAllContacts
{
    NSMutableArray *contacts = nil;
    const char *sql = "select name,phoneNo,weChatNo,emailAddress from contactsInfo;";
    sqlite3_stmt *stmt = NULL;
    int result = sqlite3_prepare_v2(db, sql, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"select success");
        contacts = [NSMutableArray array];
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            ContactModel *contact = [[ContactModel alloc] init];
            const unsigned char *name = sqlite3_column_text(stmt, 0);
            contact.name = [NSString stringWithUTF8String:(const char *)name];
            const unsigned char *phoneNo = sqlite3_column_text(stmt, 1);
            contact.phoneNo = [NSString stringWithUTF8String:(const char *)phoneNo];
            const unsigned char *weChatNo = sqlite3_column_text(stmt, 2);
            contact.weChatNo = [NSString stringWithUTF8String:(const char *)weChatNo];
            const unsigned char *emailAddress = sqlite3_column_text(stmt, 3);
            contact.emailAddress = [NSString stringWithUTF8String:(const char *)emailAddress];
            [contacts addObject:contact];
        }
        
    } else {
        NSLog(@"select failed");
        
    }
    return contacts;
}

+(ContactModel *) getInfo:(NSString *) name
{
    ContactModel *contact = nil;
    NSString *nsSql = [NSString stringWithFormat:@"select name,phoneNo,weChatNo,emailAddress from contactsInfo where name = '%@';",name];
    const char *sql = [nsSql UTF8String];
    sqlite3_stmt *stmt = NULL;
    int result = sqlite3_prepare_v2(db, sql, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"select success");
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            contact = [[ContactModel alloc] init];
            const unsigned char *name = sqlite3_column_text(stmt, 0);
            contact.name = [NSString stringWithUTF8String:(const char *)name];
            const unsigned char *phoneNo = sqlite3_column_text(stmt, 1);
            contact.phoneNo = [NSString stringWithUTF8String:(const char *)phoneNo];
            const unsigned char *weChatNo = sqlite3_column_text(stmt, 2);
            contact.weChatNo = [NSString stringWithUTF8String:(const char *)weChatNo];
            const unsigned char *emailAddress = sqlite3_column_text(stmt, 3);
            contact.emailAddress = [NSString stringWithUTF8String:(const char *)emailAddress];
        }
        
    } else {
        NSLog(@"select failed");
    }
    return contact;
}

+(BOOL) updateContact:(ContactModel *)contact
{
    NSLog(@"%@,%@,%@,%@ - update",contact.name,contact.phoneNo,contact.weChatNo,contact.emailAddress);
    if([self isContactExisted:contact.name])
    {
        NSString *sql = [NSString stringWithFormat:@"update contactsInfo set phoneNo='%@',weChatNo='%@',emailAddress='%@' where name = '%@'", contact.phoneNo, contact.weChatNo, contact.emailAddress, contact.name];
        char *errorMesg = NULL;
        int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errorMesg);
        if (result == SQLITE_OK) {
            NSLog(@"update success");
            return YES;
        }else {
            NSLog(@"update failed");
            return NO;
        }
    }
    else
    {
        if([self insertContact:contact])
            return YES;
        else
            return NO;
    }
}

+(BOOL) deleteContact:(NSString *) name
{
    NSLog(@"%@ - delete",name);
    NSString *sql = [NSString stringWithFormat:@"delete from contactsInfo where name = '%@';", name];
    char *errorMesg = NULL;
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errorMesg);
    if (result == SQLITE_OK) {
        NSLog(@"delete success");
        return YES;
    }else {
        NSLog(@"delete failed");
        return NO;
    }
}

+(BOOL) isContactExisted:(NSString *) name
{
    NSString *sql = [NSString stringWithFormat:@"select COUNT(*) from contactsInfo where name = '%@';",name];
    sqlite3_stmt *stmt = NULL;
    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"select success");
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            int count = sqlite3_column_int(stmt, 0);
            NSLog(@"%d counts found", count);
            if(count == 0)
                return NO;
            else
                return YES;
        }
    } else {
        NSLog(@"select failed");
    }
    return NO;
}

+(BOOL) clearContacts
{
    NSString *sql = @"delete from contactsInfo;";
    char *errorMesg = NULL;
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errorMesg);
    if (result == SQLITE_OK) {
        NSLog(@"delete all success");
        return YES;
    }else {
        NSLog(@"delete all failed");
        return NO;
    }
}


@end

