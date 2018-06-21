//
//  KeyPadViewController.m
//  Contacts
//
//  Created by 刘瑞康 on 2018/6/9.
//  Copyright © 2018年 刘瑞康. All rights reserved.
//

#import "KeyPadViewController.h"
#import "CallingViewController.h"

@interface KeyPadViewController ()
@property (weak, nonatomic) IBOutlet UILabel *phoneNum;
@property (strong, nonatomic) NSString *currentNum;
@end

@implementation KeyPadViewController

- (IBAction)numberTouched:(UIButton *)sender {
    self.currentNum = [self.currentNum stringByAppendingString: sender.currentTitle];
    [self.phoneNum setText: self.currentNum];
}

- (IBAction)deleteTouched {
    if([self.currentNum length] != 0)
    {
        self.currentNum = [self.currentNum substringToIndex:[self.currentNum length]-1];
        [self.phoneNum setText: self.currentNum];
    }
    
}

- (void)viewDidLoad{
    [super loadView];
    self.currentNum = @"";
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"call"]){
        NSString * s = ((KeyPadViewController *)[segue sourceViewController]).currentNum;
        ((CallingViewController *)segue.destinationViewController).phoneNum = s;
    }
}


@end
