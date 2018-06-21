//
//  CallingViewController.m
//  Contacts
//
//  Created by 刘瑞康 on 2018/6/10.
//  Copyright © 2018年 刘瑞康. All rights reserved.
//

#import "CallingViewController.h"

@interface CallingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@end

@implementation CallingViewController
@synthesize phoneNum = _phoneNum;

- (IBAction)HangupTouched {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) viewDidLoad
{
    [self.phoneNumLabel setText: self.phoneNum];
    [self.navigationController.navigationItem setHidesBackButton:YES];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar.backItem setHidesBackButton:YES];
}




@end
