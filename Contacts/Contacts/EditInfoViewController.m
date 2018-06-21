//
//  EditInfoViewController.m
//  Contacts
//
//  Created by 刘瑞康 on 2018/6/17.
//  Copyright © 2018年 刘瑞康. All rights reserved.
//


#import "EditInfoViewController.h"
#import "UseSqlite.h"

@interface EditInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *phoneNoText;
@property (weak, nonatomic) IBOutlet UITextField *weChatNoText;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressText;

@end

@implementation EditInfoViewController
@synthesize contact;

-(void) viewDidLoad
{
    [self.nameText setText:self.contact.name];
    [self.phoneNoText setText:self.contact.phoneNo];
    [self.weChatNoText setText:self.contact.weChatNo];
    [self.emailAddressText setText:self.contact.emailAddress];
}

- (IBAction)saveTouched {
    NSLog(@"%@", self.nameText.text);
    
    ContactModel *newConact = [[ContactModel alloc] init];
    newConact.name = [NSString stringWithFormat:@"%@", self.nameText.text];
    newConact.phoneNo = [NSString stringWithFormat:@"%@", self.phoneNoText.text];
    newConact.weChatNo = [NSString stringWithFormat:@"%@", self.weChatNoText.text];
    newConact.emailAddress = [NSString stringWithFormat:@"%@", self.emailAddressText.text];
    [UseSqlite updateContact:newConact];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
