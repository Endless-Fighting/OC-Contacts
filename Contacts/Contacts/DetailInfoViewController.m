//
//  DetailInfoViewController.m
//  Contacts
//
//  Created by 刘瑞康 on 2018/6/14.
//  Copyright © 2018年 刘瑞康. All rights reserved.
//

#import "DetailInfoViewController.h"
#import "UseSqlite.h"
#import "EditInfoViewController.h"

@interface DetailInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *weChatNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailAddressLabel;
@property (strong, nonatomic) ContactModel *contact;

@end

@implementation DetailInfoViewController
@synthesize name = _name;



-(void) viewDidLoad
{
    self.contact = [UseSqlite getInfo:self.name];
    [self.nameLabel setText:self.name];
    [self.phoneNoLabel setText:self.contact.phoneNo];
    [self.weChatNoLabel setText:self.contact.weChatNo];
    [self.emailAddressLabel setText:self.contact.emailAddress];
}

- (IBAction)deleteTouched {
    [UseSqlite deleteContact:self.name];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareTouched {
    NSArray *info = @[[NSString stringWithFormat:@"%@ - PhoneNo: %@ - WeChatNo: %@ - Email: %@", self.contact.name, self.contact.phoneNo, self.contact.weChatNo, self.contact.emailAddress]];
    UIActivityViewController *activityController=[[UIActivityViewController alloc]initWithActivityItems:info applicationActivities:nil];
    [self.navigationController presentViewController:activityController animated:YES completion:nil];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"editInfo"]){
        ((EditInfoViewController *)segue.destinationViewController).contact = self.contact;
    }
}

@end
