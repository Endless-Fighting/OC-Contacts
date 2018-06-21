//
//  EditInfoViewController.m
//  Contacts
//
//  Created by 刘瑞康 on 2018/6/17.
//  Copyright © 2018年 刘瑞康. All rights reserved.
//


#import "EditInfoViewController.h"

@interface EditInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *phoneNoText;
@property (weak, nonatomic) IBOutlet UITextField *weChatNoText;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressText;

@property (nonatomic,strong) SqliteManager * sqliteManager;
@property(nonatomic,strong)NSIndexPath * index;

@end

@implementation EditInfoViewController
@synthesize contact;

-(void) viewDidLoad
{
    self.sqliteManager = [SqliteManager getSqliteManager];
    
    //update
    if (self.contact)
    {
        self.navigationItem.title = @"Eidt";
        self.nameText.text = self.contact.name;
        self.phoneNoText.text = self.contact.phoneNo;
        self.weChatNoText.text = self.contact.weChatNo;
        self.emailAddressText.text = self.contact.emailAddress;
    }
    //add new
    else
    {
        self.navigationItem.title = @"Add";
    }
}

- (IBAction)saveTouched {
    NSLog(@"%@", self.nameText.text);
    
    ContactModel * contact = [[ContactModel alloc]
                              initWithName:self.nameText.text
                              PhoneNo:self.phoneNoText.text
                              WeChatNo:self.weChatNoText.text
                              EmailAddress:self.emailAddressText.text];
    
    self.contact.name = self.nameText.text;
    self.contact.phoneNo = self.phoneNoText.text;
    self.contact.weChatNo = self.weChatNoText.text;
    self.contact.emailAddress = self.emailAddressText.text;
    //update
    if (self.contact)
    {
        [self.sqliteManager updateContactFromSqlite:contact withIndex:contact.contactId + 1];
    }
    //add new
    else
    {
        [self.sqliteManager addContactToSqlite:contact];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
