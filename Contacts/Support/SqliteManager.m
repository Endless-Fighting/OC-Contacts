//
//  SqliteManager.m
//  Contacts
//
//  Created by 刘瑞康 on 2018/6/21.
//  Copyright © 2018年 刘瑞康. All rights reserved.
//

#import "SqliteManager.h"



@interface SqliteManager ()

@property(nonatomic)sqlite3 * contactData;
@property(nonatomic,strong)NSMutableArray * mContacts;

@end


@implementation SqliteManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mContacts = [NSMutableArray array];
        [self openSqlite_db];
        [self creatSqlite_db];
        [self loadContacts];
    }
    return self;
}

+(instancetype)getSqliteManager
{
    static SqliteManager * sqliteManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sqliteManager = [[SqliteManager alloc] init];
    });
    return sqliteManager;
}

-(void)openSqlite_db
{
    NSString * path1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSString * path = [path1 stringByAppendingPathComponent:@"contact.db"];
    
    sqlite3_open([path UTF8String],&self->_contactData);
}

-(void)creatSqlite_db
{
    char * createTableSQL = "create table if not exists contact (id integer primary key,name varchar(30),phoneNo varchar(100),weChatNo varchar(100),emailAddress varchar(100))";
    
    sqlite3_exec(self->_contactData, createTableSQL, NULL, NULL, NULL);
}

-(void)loadContacts
{
    [self.mContacts removeAllObjects];
    
    char * selectSQL = "select * from contact order by id";
    
    sqlite3_stmt * stmt;
    sqlite3_prepare_v2(self->_contactData, selectSQL, -1, &stmt, NULL);
    
    while (sqlite3_step(stmt) ==SQLITE_ROW)
    {
        ContactModel * contact = [[ContactModel alloc]
            initWithName:[NSString stringWithUTF8String:(char *)(sqlite3_column_text(stmt, 1))]
            PhoneNo:[NSString stringWithUTF8String:(char *)(sqlite3_column_text(stmt, 2))]
            WeChatNo:[NSString stringWithUTF8String:(char *)(sqlite3_column_text(stmt, 3))]
            EmailAddress:[NSString stringWithUTF8String:(char *)(sqlite3_column_text(stmt, 4))]];
        
        contact.contactId = sqlite3_column_int(stmt, 0);
        [self.mContacts addObject:contact];
    }
    
    sqlite3_finalize(stmt);
}


-(void)addContactToSqlite:(ContactModel *)contact;
{
    [self.mContacts addObject:contact];
    char * insertSQL = "insert into contact values(NULL,?,?,?,?)";
    
    sqlite3_stmt * stmt;
    sqlite3_prepare_v2(self->_contactData, insertSQL, -1, &stmt, NULL);
    
    sqlite3_bind_text(stmt, 1, [contact.name UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 2,  [contact.phoneNo UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 3, [contact.weChatNo UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 4, [contact.emailAddress UTF8String], -1, NULL);
    
    int rst = sqlite3_step(stmt);
    if (rst == SQLITE_DONE)
    {
        NSLog(@"insert success");
    }else
    {
        NSLog(@"insert failed %d",rst);
    }
    
    sqlite3_finalize(stmt);
}


-(void)deleteContactFromSqlite:(NSInteger)index;
{
    NSInteger ID = ((ContactModel *)self.mContacts[index - 1]).contactId;
    [self.mContacts removeObjectAtIndex:index - 1];
    
    char * deleteSQL = "delete from contact where id=?";
    
    sqlite3_stmt * stmt;
    sqlite3_prepare_v2(self.contactData, deleteSQL, -1, &stmt, NULL);
    sqlite3_bind_int(stmt, 1, (int)ID);
    
    int rst = sqlite3_step(stmt);
    if (rst == SQLITE_DONE)
    {
        NSLog(@"delete success");
    }
    else
    {
        NSLog(@"delete failed");
    }
    
    sqlite3_finalize(stmt);
}


-(void)updateContactFromSqlite:(ContactModel *)contact withIndex:(NSInteger)index;
{
    NSInteger ID = ((ContactModel *)self.contacts[index - 1]).contactId;
    
    [self.mContacts replaceObjectAtIndex:index - 1 withObject:contact];
    
    char * updateSQL = "update contact set name=?,phoneNo=?,weChatNo=?,emailAddress=? where id=?";
    
    sqlite3_stmt * stmt;
    sqlite3_prepare_v2(self.contactData, updateSQL, -1, &stmt, NULL);
    
    sqlite3_bind_text(stmt, 1, [contact.name UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 2, [contact.phoneNo UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 3, [contact.weChatNo UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 4, [contact.emailAddress UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 5, (int)ID);
    
    int rst = sqlite3_step(stmt);
    if (rst == SQLITE_DONE)
    {
        NSLog(@"update success");
    }else
    {
        NSLog(@"update failed %d",rst);
    }
    
    sqlite3_finalize(stmt);
}


-(void)selectContactFromWithName:(NSString *)name;
{
    NSMutableArray * mutableContacts = [NSMutableArray array];
    
    for (ContactModel * contact in self.mContacts)
    {
        if ([contact.name isEqualToString:name])
        {
            [mutableContacts addObject:contact];
        }
    }
    
    self.mContacts = mutableContacts;
}

-(void)closeSqlite_db
{
    sqlite3_close(self->_contactData);
}

-(void)dealloc
{
    [self closeSqlite_db];
}  
@end
