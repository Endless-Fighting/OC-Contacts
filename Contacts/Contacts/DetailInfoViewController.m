//
//  DetailInfoViewController.m
//  Contacts
//
//  Created by 刘瑞康 on 2018/6/14.
//  Copyright © 2018年 刘瑞康. All rights reserved.
//

#import "DetailInfoViewController.h"
#import "EditInfoViewController.h"
#import "CallingViewController.h"

@interface DetailInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *weChatNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailAddressLabel;

@end

@implementation DetailInfoViewController

-(void) viewDidLoad
{
    [self.nameLabel setText:self.contact.name];
    [self.phoneNoLabel setText:self.contact.phoneNo];
    [self.weChatNoLabel setText:self.contact.weChatNo];
    [self.emailAddressLabel setText:self.contact.emailAddress];
}

- (IBAction)deleteTouched {
    [[SqliteManager getSqliteManager] deleteContactFromSqlite:self.contact.contactId];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareTouched {
    NSArray *info = @[[NSString stringWithFormat:@"%@ \n - PhoneNo: %@ \n- WeChatNo: %@ \n- Email: %@", self.contact.name, self.contact.phoneNo, self.contact.weChatNo, self.contact.emailAddress]];
    UIActivityViewController *activityController=[[UIActivityViewController alloc]initWithActivityItems:info applicationActivities:nil];
    [self.navigationController presentViewController:activityController animated:YES completion:nil];
}

- (IBAction)editTouched {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    EditInfoViewController * editInfoView = [storyboard instantiateViewControllerWithIdentifier:@"EditInfoView"];
    editInfoView.contact = self.contact;
    
    [self.navigationController pushViewController:editInfoView animated:YES];
}

- (IBAction)callTouched {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    CallingViewController * editInfoView = [storyboard instantiateViewControllerWithIdentifier:@"CallingView"];
    editInfoView.phoneNum = self.contact.name;
    
    [self.navigationController pushViewController:editInfoView animated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.nameLabel setText:self.contact.name];
    [self.phoneNoLabel setText:self.contact.phoneNo];
    [self.weChatNoLabel setText:self.contact.weChatNo];
    [self.emailAddressLabel setText:self.contact.emailAddress];
}


@end
